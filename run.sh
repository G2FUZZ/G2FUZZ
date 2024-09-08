#!/bin/bash

declare -A befores
declare -A afters
declare -A seed_froms
declare -A format

befores["wav2swf"]="-o /dev/null"
afters["wav2swf"]=""
seed_froms["wav2swf"]="seeds/general_evaluation/wav"

befores["sqlite3"]="<"
afters["sqlite3"]=""
seed_froms["sqlite3"]="seeds/general_evaluation/sql"

befores["ffmpeg"]="-y -i"
afters["ffmpeg"]="-c:v mpeg4 -c:a copy -f mp4 /dev/null"
seed_froms["ffmpeg"]="seeds/general_evaluation/ffmpeg100"
format["ffmpeg"]="mp4"


befores["nm-5279478"]="-A -a -l -S -s --special-syms --synthetic --with-symbol-versions -D"
afters["nm-5279478"]=""
seed_froms["nm-5279478"]="seeds/general_evaluation/nm"

befores["objdump"]="-S"
afters["objdump"]=""
seed_froms["objdump"]="seeds/general_evaluation/obj"


befores["tcpdump"]="-e -vv -nr"
afters["tcpdump"]=""
seed_froms["tcpdump"]="seeds/general_evaluation/tcpdump100"

befores["tiffsplit"]=""
afters["tiffsplit"]=""
seed_froms["tiffsplit"]="seeds/general_evaluation/tiff"
format["tiffsplit"]="tiff"

befores["gdk-pixbuf-pixdata"]=""
afters["gdk-pixbuf-pixdata"]="/dev/null"
seed_froms["gdk-pixbuf-pixdata"]="seeds/general_evaluation/pixbuf"

befores["cflow"]=""
afters["cflow"]=""
seed_froms["cflow"]="seeds/general_evaluation/cflow"

befores["jhead"]=""
afters["jhead"]=""
seed_froms["jhead"]="seeds/general_evaluation/jhead"

befores["exiv2"]=""
afters["exiv2"]=""
seed_froms["exiv2"]="seeds/general_evaluation/jpg"

befores["mp42aac"]=""
afters["mp42aac"]="/dev/null"
seed_froms["mp42aac"]="seeds/general_evaluation/mp4"
format["mp42aac"]="mp4"

befores["pdftotext"]=""
afters["pdftotext"]="/dev/null"
seed_froms["pdftotext"]="seeds/general_evaluation/pdf"

befores["mp3gain"]=""
afters["mp3gain"]=""
seed_froms["mp3gain"]="seeds/general_evaluation/mp3"
format["mp3gain"]="mp3"


befores["flvmeta"]=""
afters["flvmeta"]=""
seed_froms["flvmeta"]="seeds/general_evaluation/flv"
format["flvmeta"]="flv"

befores["imginfo"]="-f"
afters["imginfo"]=""
seed_froms["imginfo"]="seeds/general_evaluation/imginfo"

befores["infotocap"]="-o /dev/null"
afters["infotocap"]=""
seed_froms["infotocap"]="seeds/general_evaluation/text"

befores["lame"]=""
afters["lame"]="/dev/null"
seed_froms["lame"]="seeds/general_evaluation/lame3.99.5"
format["lame"]="wav"

befores["jq"]="."
afters["jq"]=""
seed_froms["jq"]="seeds/general_evaluation/json"

befores["mujs"]=""
afters["mujs"]=""
seed_froms["mujs"]="seeds/general_evaluation/mujs"


befores["bison"]="-vdty -b output_dir"
afters["bison"]=""
seed_froms["bison"]="seeds/Rosen_seeds/bison/seed_dir"

befores["catdoc"]="-a"
afters["catdoc"]=""
seed_froms["catdoc"]="seeds/Rosen_seeds/catdoc/seed_dir"

befores["sassc"]=""
afters["sassc"]=""
seed_froms["sassc"]="seeds/Rosen_seeds/sassc/seed_dir"

befores["dwarfdump"]="-a"
afters["dwarfdump"]=""
seed_froms["dwarfdump"]="seeds/Rosen_seeds/libdwarf/seed_dir"

befores["lou_translate"]="-f unicode.dis,en-us-g2.ctb <"
afters["lou_translate"]=""
seed_froms["lou_translate"]="seeds/Rosen_seeds/liblouis/seed_dir"

befores["listswf"]="-v"
afters["listswf"]=""
seed_froms["listswf"]="seeds/Rosen_seeds/libming/seed_dir"

befores["mpg123"]="-s"
afters["mpg123"]=""
seed_froms["mpg123"]="seeds/Rosen_seeds/libmpg123/seed_dir"

befores["asn1Parser"]="-s"
afters["asn1Parser"]=""
seed_froms["asn1Parser"]="seeds/Rosen_seeds/libtasn1/seed_dir"

befores["tiff2pdf"]="-o out.pdf"
afters["tiff2pdf"]=""
seed_froms["tiff2pdf"]="seeds/Rosen_seeds/tiff2pdf/seed_dir"

befores["tiff2ps"]="-1 -O out.ps"
afters["tiff2ps"]=""
seed_froms["tiff2ps"]="seeds/Rosen_seeds/tiff2ps/seed_dir"

befores["nasm"]="-f elf64 -l out.lst -o out.o"
afters["nasm"]=""
seed_froms["nasm"]="seeds/Rosen_seeds/nasm/seed_dir"

befores["pdftohtml"]="-f elf64 -l out.lst -o out.o"
afters["pdftohtml"]=""
seed_froms["pdftohtml"]="seeds/Rosen_seeds/poppler/seed_dir"

afl_fuzz=$1
seed=$2
output=$3
cmp_program=$4
program_name=$5
generator_base_path=$6
afl_program=$7
before_arg=${befores[$program_name]}
after_arg=${afters[$program_name]}

# For normal usage
mkdir $output
mkdir $output/default
python $generator_base_path/program_gen.py --output $output/default --program $program_name --input $seed --mode init >> $output/default/gen_log
mkdir initial_seeds
cp $seed/* initial_seeds
mv $output/default/gen_seeds/*  initial_seeds
$afl_fuzz -i initial_seeds -o $output -c $cmp_program -m 1024 -J $program_name -k $generator_base_path -- $afl_program $before_arg @@ $after_arg > $output/default/fuzz_log

# For ablation experiment
# mkdir $output
# mkdir $output/default
# mkdir $output/default/gen_seeds
# mkdir initial_seeds
# cp $seed/* initial_seeds
# cp $generator_base_path/all_gen_seeds/$program_name/gen_seeds/* initial_seeds
# cp -r $generator_base_path/all_gen_seeds/$program_name/feature_pool.json $output/default
# cp -r $generator_base_path/all_gen_seeds/$program_name/feature_programs.json $output/default
# cp -r $generator_base_path/all_gen_seeds/$program_name/gen_log $output/default
# cp -r $generator_base_path/all_gen_seeds/$program_name/generators $output/default
# $afl_fuzz -i initial_seeds -o $output -c $cmp_program -m none -J $program_name -k $generator_base_path -- $afl_program $before_arg @@ $after_arg > $output/default/fuzz_log