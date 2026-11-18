#!/bin/bash
set -e
if [[ "$TARGET_JDK" == "arm" ]]; then
git clone --branch jdk8u482-b08-aarch32-20260122 --depth 1 https://github.com/openjdk/aarch32-port-jdk8u openjdk
else
git clone --branch jdk8u482-b08 --depth 1 https://github.com/openjdk/jdk8u openjdk
fi