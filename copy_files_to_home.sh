#!/bin/bash
cd HOME
set -e


if [ "$1" == "-y" ]; then
    response=y
else
    read -r -p "Are you sure? [y/N] " response
fi

case "$response" in
    [yY][eE][sS]|[yY])
        echo ok
        ;;
    *)
        exit 0
        ;;
esac

for i in `find . -type f`;
do
    DEST=~/.${i##./_}
    DIR=$(dirname $DEST)
    echo $DEST
    mkdir -p $DIR
    dest_file=~/.${i##./_}
    cp ${i##./}  $dest_file
    sed -i -e "s:H0Me:/home/$USER:g" $dest_file
done
cd ..

# make links
ln -s ~/.vimrc ~/.config/nvim/init.vim
