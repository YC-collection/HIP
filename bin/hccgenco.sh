#!/bin/bash

function die {
  echo "${1-Died}." >&2
  exit 1
}

if [ $# = 0 ]; then
  die "$(basename $0): Invalid number of arguments"
fi

: ${ROCM_PATH:=/opt/rocm}
: ${ROCM_TARGET:=fiji}

INPUT_FILES=""
OUTPUT_FILE=""
while [[ $# -gt 1 ]]; do
  key="$1"
  case $key in
    -o)
    OUTPUT_FILE="$2"
    shift
    ;;
    *)
    INPUT_FILES="$INPUT_FILES $key"
  esac
  shift
done

[ INPUT_FILES != "" ] || die "No source files specified"
[ OUTPUT_FILE != "" ] || die "Output file not specified"

SOURCE="${BASH_SOURCE[0]}"
HIP_PATH="$( command cd -P "$( dirname "$SOURCE" )/.." && pwd )"

export KMDUMPISA=1
export KMDUMPLLVM=1
hipgenisa_dir=`mktemp -d --tmpdir=/tmp hip.XXXXXXXX`
hipgenisa_main=`mktemp src.XXXXXXXX.cpp`
hipgenisa_files="$hipgenisa_main"

for inputfile in $INPUT_FILES; do
  sed 's/extern \+"C" \+//g' $inputfile > $inputfile.kernel.tmp.cpp
  hipgenisa_files="$hipgenisa_files $inputfile.kernel.tmp.cpp"
done
printf "\nint main(){}\n" >> $hipgenisa_main

$HIP_PATH/bin/hipcc $hipgenisa_files -o $hipgenisa_dir/a.out
mv dump.* $hipgenisa_dir
$ROCM_PATH/hcc-lc/bin/llvm-mc -arch=amdgcn -mcpu=$ROCM_TARGET -filetype=obj $hipgenisa_dir/dump.isa -o $hipgenisa_dir/dump.o
$ROCM_PATH/llvm/bin/clang -target amdgcn--amdhsa $hipgenisa_dir/dump.o -o $hipgenisa_dir/dump.co

map_sym=""
kernels=$(objdump -t $hipgenisa_dir/dump.co | grep grid_launch_parm | sed 's/ \+/ /g; s/\t/ /g' | cut -d" " -f6)
for mangled_sym in $kernels; do
  real_sym=$(c++filt $(c++filt _$mangled_sym | cut -d: -f3 | sed 's/_functor//g') | cut -d\( -f1)
  map_sym="--redefine-sym $mangled_sym=$real_sym $map_sym"
done
objcopy -F elf64-little $map_sym $hipgenisa_dir/dump.co $OUTPUT_FILE

rm $hipgenisa_files
rm -r $hipgenisa_dir
