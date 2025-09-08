#! /bin/bash

echo "Hello World"

read a
read b
read c

echo $a , $b , $c

echo "For Conditional"
for i in {1..5}
do
    echo $i 
done


echo "While Conditional"
i=1
while [[ $i -le 10 ]] ; do
    echo "$i"
    ((i += 1))
done


echo "While to Read a TXT file"
LINE=1
while read -r CURRENT_LINE
    do
        echo "$LINE: $CURRENT_LINE"
    ((LINE++))
done < "dev-tools.txt"