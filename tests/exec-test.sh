#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"

find "$thisd" -name "test-*.sh" -type f | sort | while read testcase ; do
    tput setaf 2
    echo "EXECUTE: ${testcase}"
    tput sgr0
    "$testcase" ||
        (
            tput setaf 3
            echo "FAILED! ${testcase}"
            tput sgr0 && exit 1
        )
done
