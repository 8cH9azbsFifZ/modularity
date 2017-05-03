(for f in $(find . -name "*.o"); do nm $f | awk -v f=$f '{print f": "$0}'; d>nm.txt
