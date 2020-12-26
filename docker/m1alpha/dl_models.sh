#!/bin/sh

cd "$(dirname "$(realpath "$0")")";

git clone https://github.com/osrf/gazebo_models

cd gazebo_models

# Copy extracted files to the local model folder
cp -vfR * "/root/.gazebo/models/"

cd "$(dirname "$(realpath "$0")")";

rm -rf "gazebo_models"
