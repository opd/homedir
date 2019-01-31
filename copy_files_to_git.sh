cd HOME
for i in `find . -type f`;
do
    echo $i
    dest_file=${i##./}
    cp ~/.${i##./_} $dest_file
    sed -i "s:/home/$USER:H0Me:g" $dest_file
done
cd ..
