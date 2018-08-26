#!/usr/bin/bash

echo "Synchronising Maildir."
mbsync -a

echo "Checking for spam."
COUNT=0

pushd $HOME/Maildir/personal/INBOX/ 1>/dev/null
while read p; do
    status=$(cat $p | mail2text.pl 2>/dev/null | bmf -p  | \
		 grep "X-Spam-Status: Yes" | head -n1 | wc -l)

    if [ $status -eq 1 ] ; then
	echo -n "... Moving to spam:"
	cat $p | grep "^Subject:" | head -n1 | cut -d: -f2

	# We are going to rename the email to keep mbsync happy on its
	# next run.
	randID=$(cat /dev/urandom | tr -dc 'a-fA-F0-9' | \
		     fold -w 16 | head -n 1)
	newname=`date +%s`.$randID.`hostname`":2,S"

	COUNT=$(( $COUNT + 1 ))

	mv $p $HOME/Maildir/personal/Junk/cur/$newname
    fi

done < <(find ./new -type f -mtime -1)
popd 1>/dev/null

if [ $COUNT -gt 0 ] ; then
    echo "Moved $COUNT email(s) to Junk."
else
    echo "No spam this time."
fi
