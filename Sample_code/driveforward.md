---
title: Drive the robot by a specified distance in a specified amount of time
layout: matlab_code_linenumbers
matlab_source: driveforward.m
---
Let's break down what is happening in this program:

* The inputs to the function are the distance to drive, and the speed.
* Line 7 of the program specifies that you will be publishing to the ROS topic ``raw_vel``. 
* Line 10 defines a ROS message which will be sent to the ``raw_vel`` topic. 
* In line 13, a one by two vector with the left and right wheel velocities is assigned to the Matlab structure ``message.Data``. In this program the velocities are defined at the input to the function, but they could also come from a velocity vector, pre-computed list, etc.
* In line 16, we use the ``send`` command to send the data in ``message`` to the ROS topic specified by ``pubvel`` (in this case, ``raw_vel``)
* In line 19 we record the current time as determined by ROS using the function [rostic](rostic.m).  As explained in the text, we don't want to use ``tic`` and ``toc`` since the simulator's clock might run a bit slower than real time.



As soon as we use the ``send`` command, your robot will start moving according to the wheel velocities in ``message.Data``, and will not stop until we tell it to.  So, what is happening in the rest of this program? At this point, we are not using a distance sensor on the robot (we will introduce this soon).
* Line 20 starts a loop that monitors how long the robot has been moving forward. 
* In line 21 we use the [rostoc](rostoc.m) command to check how much time has elapsed since we started moving. This is very close to the amount of time the robot has been moving. We use the simple fact that distance is the product of velocity and time to find the elapsed time needed to travel the distance we specified in the function call. We say that if we have reached that maximum time, we send a zero velocity command in lines 26 and 27.
* If we have not reached the maximum elapsed time for our distance, we stay inside the loop and keep checking the time.
