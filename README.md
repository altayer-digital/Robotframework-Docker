# ATG UI Test Automation Project

## Installation

Clone repo 
  
```
git clone https://github.com/khanbhai89/robot-framework.git
```

Build Docker

```
docker build -t robotframework-docker .
```

## Running Tests

To run execute `./run_tests.sh`

Customize `run_tests.sh` for your own need

```
docker run --rm \
           -e USERNAME="Hammad Ahmed" \
           --net=host \
           -e ROBOT_TESTS=./suite   \
           -e ROBOT_LOGS=Result_Folder_Name   \
           -e ROBOT_TEST=Test_Name \
           -e BRAND=Brand_Name   \
           -e COUNTRY=Country_Name   \
           -e VERSION=Version_Name   \
           -e LANGUAGE=Language   \
           -e REMOTE_DESIRED=True_or_False   \
           -e PABOT_PROC=Number_of_Process      \
           -e ROBOT_ITAG=Tags_to_Execute   \
           -v "$PWD/execution/settings/":/execution/settings \
           -v "$PWD/execution/scripts":/execution/scripts \
           -v "$PWD/results":/results \
           -v "$PWD/":/suite \
           --security-opt seccomp:unconfined \
           --shm-size "256M" \
           robotframework-docker
```


## Tag List

When using tags on the projects you can select tags from below.

- search
- stable
- regression

## Feature List

- Variable-based run on Tests, Suites, Brand, Country, Version, Remote Desired, Number of Parallel Processes, Tags and Result folders.
- Async Run to cancel build on local
- Jenkins Supported build
- Parallel Run support
- Dockerized Container
- Browserstack Support
- Timeouts
- Headless run in Docker support
- Save screenshot in a folder
- URL Generator config
- Al Tayer library support i.e. write to log, browserstack build url in logs, save customers, generate random emails and save orders. 

