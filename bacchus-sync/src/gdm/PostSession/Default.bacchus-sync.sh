#!/bin/bash

# Local user: exit
if [[ $HOME != /csehome/* ]]
then
  exit 0
fi

# Domain user: invoke domain user session cleanup
/usr/bin/bacchus-sync --domain --logout

exit 0
