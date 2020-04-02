---
title: Record a Dataset of the Neato's Position (simulator only)
layout: matlab_code
matlab_source: makeNeatoPositionPlot.m
---
***Note: only applies to the simulated Neato***

This code allows record a dataset of the Neato's position.  The code will populate a figure window that shows the data that is being collected.  Once you are ready to stop collection, you can either close the figure window or hit space bar (provided the figure window has the focus).

Once collection is complete, you will have a ``.mat`` with a row per data point and where column 1 is a time stamp, column 2 is the x position, and column 3 is the y position.

To run the code you can just type

```
>> makeNeatoPositionPlot
```
