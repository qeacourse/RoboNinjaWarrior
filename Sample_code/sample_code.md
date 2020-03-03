---
title: "Sample MATLAB Code for Robo Ninja Warrior"
---

## Teleoperation and LIDAR visualization

![A screenshot showing a visualization of the Neato and its LIDAR readings](../How to/Pictures/sample_screenshot.png)

The first code you should run is the [teleoperation and LIDAR visualization script](teleopAndVisualizer.m).  The documentation for how to run it is included in the .m file.

## Challenge Solutions

* [Drive ellipse](driveEllipse) (this is basically the solution to the Bridge of Doom)
* A basic [implementation of physical gradient descent](hillClimbing.m).  The Neato can use its onboard accelerometer to reach the top of the mountain using this code.  In the first few iterations of this module we used to have students do this as one of the three challenges.  Recently, we've dropped it due to the complexity of supporting it.
* Building blocks of a solution to the Gauntlet ([find walls](findWalls.m), [find circles](findCircles.m), [make potential fields](makePotentials.m))

## Miscellaneous Robot Code

* [Drive until bump](driveUntilBump.m)
* [Drive until bump, then run away](driveUntilBumpThenRunAway.m)
* [Test twist](testTwist.m)
* [Test stop](testStop.m)
* [Symbolic function sample](symbolicFunExample.m) (supports the Bridge of Doom challenge)
