#!/usr/bin/env bash
set -x

# This file is subject to the terms and conditions defined in file 'LICENSE',
# which is part of this repository.

# Available environment variables
#
# n/a

# Set default values

HOST=$1
SERVICE=$2
ENVIRONMENT=$3

cd /tests
rake spec host=$HOST service=$SERVICE environment=$ENVIRONMENT
