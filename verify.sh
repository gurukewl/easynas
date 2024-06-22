#!/bin/bash

# Get the username and password from the command line arguments.
username="$1"
password="$2"

# Check if the user exists.
if id -u "$username" > /dev/null; then
  # Hash the password using the same algorithm and salt as in the original script.
  salt=$(grep -w "$username" /etc/shadow | cut -d: -f3)
  hash=$(perl -le 'print crypt("$ENV{password}","\$$ENV{salt}\$")')

  # Compare the hashed password with the user's password hash in /etc/shadow.
  if cat /etc/shadow | grep -q "^$username:$hash:"; then
    echo "1"
  else
    echo "0"
  fi
else
  echo "Error: User not found."
  exit 1
fi