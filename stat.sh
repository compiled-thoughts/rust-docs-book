#! /bin/sh
#
# stat.sh
# Copyright (C) 2023 edgardleal <edgardleal@Mac-mini-Edgard.local>
#
# Distributed under terms of the MIT license.
#
declare -r WORDS_FROM_CHAPTERS=$(wc -w src/*.md | awk '/total/{print $1}')
# declare -r WORDS_FROM_CARDS=$(wc -w /*.md | awk '/total/{print $1}')
declare -r WORDS_FROM_CARDS=0
declare -r WORDS=$(($WORDS_FROM_CARDS+$WORDS_FROM_CHAPTERS))

declare year=`date +%Y`
declare month=`date +%m`
declare day=`date +%d`

echo "\"${year}-${month}-${day}\",$WORDS" >> stats.csv
