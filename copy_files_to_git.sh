cd HOME
for i in `find . -type f`;
do
    echo $i
    dest_file=${i##./}
    source_file=~/.${i##./_}
    cp $source_file $dest_file
    sed -i '' -e "s:$HOME:H0Me:g" $dest_file
done
cd ..
