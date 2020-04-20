#!/bin/sh

cd "$(dirname "$(realpath "$0")")";

hg clone https://bitbucket.org/osrf/gazebo_models -b default

cd gazebo_models

# Copy extracted files to the local model folder
cp -vfR * "/home/rnw/.gazebo/models/"

cd "$(dirname "$(realpath "$0")")";

rm -rf "gazebo_models"
