#!/usr/bin/env bash

docker run --rm \
           -e USERNAME="Hammad Ahmed" \
           --net=host \
           -e ROBOT_TESTS=./suite   \
           -e ROBOT_LOGS=/results   \
           -e ROBOT_TEST=search_items  \
           -e BRAND=main   \
           -e COUNTRY=us   \
           -e VERSION=prod   \
           -e LANGUAGE=english   \
           -e REMOTE_DESIRED=False   \
           -e PABOT_PROC=1      \
           -e ROBOT_ITAG=stable   \
           -v "$PWD/execution/settings/":/execution/settings/ \
           -v "$PWD/execution/scripts":/execution/scripts/ \
           -v "$PWD/results/":/results/ \
           -v "$PWD/":/suite/ \
           --security-opt seccomp:unconfined \
           --shm-size "256M" \
           robotframework-docker