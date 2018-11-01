#!/bin/bash

# Local user: exit
if [[ $HOME != /csehome/* ]]
then
  exit 0
fi

# Evil Xilinx ISE files
find "$HOME" -name '*.wdb' -type f -delete
# Domain user: invoke domain user session cleanup
/usr/bin/bacchus-sync --domain --logout

exit 0
