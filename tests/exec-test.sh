#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"

find "$thisd" -name "test-*.sh" -type f | while read testcase ; do
    echo "Execute: ${testcase}"
    "$testcase"
done
