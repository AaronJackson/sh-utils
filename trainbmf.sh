#!/usr/bin/bash

pushd $HOME/Maildir/personal/Junk/
find ./{cur,new} -type f | while read p; do
    cat $p | mail2text.pl | bmf -s
done
popd

pushd $HOME/Maildir/personal/Archive/.Inbox/.2018
find ./{cur,new} -type f -mtime -30 | while read p; do
    cat $p | mail2text.pl | bmf -n
done
popd

