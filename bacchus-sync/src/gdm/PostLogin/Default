#!/bin/bash

# Local account
# 1. Create home directory if needed
# 2. Exit

if [[ $HOME != /csehome/* ]]
then
  if [[ ! -d "$HOME" ]]
  then
    cp -r /sherry/.skel "$HOME"
    chown -R "$USER":"$(id -gn "$USER")" "$HOME"
    chmod 700 "$HOME"
  fi
  exit 0
fi

# Domain account
# 1. Create space for control files

mkdir -p /sherry/.sync-status/"$USER"
chown -R "$USER":"$(id -gn "$USER")" /sherry/.sync-status/"$USER"
chmod 700 /sherry/.sync-status/"$USER"

mkdir -p /csehome/.sync-status/"$USER"
chown -R "$USER":"$(id -gn "$USER")" /csehome/.sync-status/"$USER"
chmod 700 /csehome/.sync-status/"$USER"

# 2-a. Exit if it's a guest account

while IFS='' read -r line || [[ -n "$line" ]]
do
  if [[ "$line" == "$USER" ]]
  then
    exit 0
  fi
done < /sherry/.guests

# 2-b. If not, create home directory if needed

mkdir -p /csehome/"$USER"
chown -R "$USER":"$(id -gn "$USER")" /csehome/"$USER"
chmod 700 /csehome/"$USER"

if [[ ! -d /sherry/"$USER" ]]
then
    cp -r /sherry/.skel /sherry/"$USER"
    chown -R "$USER":"$(id -gn "$USER")" /sherry/"$USER"
    chmod 700 /sherry/"$USER"
fi

exit 0
