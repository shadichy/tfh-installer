#!/bin/sh

# define the tasks that need to be done with the extracted content
process_tar() {
    cd $WORK_DIR
    chmod +x ./hpvn-$os_$arch
    ./hpvn-$os_$arch
}

# line number where payload starts
PAYLOAD_LINE=$(awk '/^__PAYLOAD_BEGINS__/ { print NR + 1; exit 0; }' $0)

# directory where a tarball is to be extracted
WORK_DIR=/tmp

# extract the embedded tar file
tail -n +${PAYLOAD_LINE} $0 | tar -zpvx -C $WORK_DIR

# perform actions with the extracted content
process_tar

exit 0
__PAYLOAD_BEGINS__
