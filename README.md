# ATG UI Test Automation Project

## Installation

Clone repo 
  
```commandline
git clone https://github.com/khanbhai89/robot-framework.git
```

Build Docker

```commandline
docker build -t robotframework-docker .
```

## Running Tests

To run execute `./run_tests.sh`

Customize `run_tests.sh` for your own need

```commandline
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
- Al Tayer library support i.e. write to log, browserstack build url in logs, save customers, generate random emails and save orders. 
- Async Run to cancel build on local
- Jenkins Supported build
- Parallel Run support
- Retry to test if fails
- Dockerized Container
- Browserstack Support
- Timeouts
- Headless run in Docker support
- Save screenshot in a folder
- URL Generator config
- Virtual Display inside the docker

![alt text](https://github.com/altayer-digital/Robotframework-Docker/blob/master/tmp/Screen%20Shot%202019-04-11%20at%2012.06.25%20AM.png)
![alt text](https://github.com/altayer-digital/Robotframework-Docker/blob/master/tmp/Screen%20Shot%202019-04-11%20at%2012.06.45%20AM.png)
