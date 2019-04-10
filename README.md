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
