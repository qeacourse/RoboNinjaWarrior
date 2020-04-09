---
title: Bridge of Doom Solutions (QEA 2020)
layout: matlab_code
matlab_source: bridgeOfDoomQEA2020.m
---
This is a sample solution for the Bridge of Doom Challenge from QEA Spring 2020.  In this semester we used simulated Neatos, so some tweaks were necessary.  The main tweaks were to use ``rostime`` instead of ``tic`` and ``toc`` for tiiming and to use rosservice to place the Neato at the start of the bridge.  This code is means to be run with the ``bod_volcano`` simulator environment (see [Meeto Your Neato](../How to/meet_your_neato) for instructions on getting the simulator up and running).
