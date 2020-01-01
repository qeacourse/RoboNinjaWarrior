---
layout: splash
title: "Robo Ninja Warrior: Integrating Math, Science, and Engineering"
header:
  overlay_color: "#000"
  overlay_filter: "0.4"
  overlay_image: website_graphics/robo_splash.jpg
feature_row:
  - image_path: https://img.youtube.com/vi/MFL4gd2IMm8/0.jpg
    alt: "A thumbnail image for a video.  The text QEA Olin College of Engineering appears on a textured blue background"
    title: "Key Features of QEA"
    excerpt: "QEA is a highly interdisciplinary, integrated course for teaching technical content."
    url: "#course-philosophy"
    btn_label: "More details about QEA"
    btn_class: "btn--primary"
  - image_path: How to/Pictures/neato_overview.jpeg
    alt: "A picture of a Neato robotic vacuum cleaner with a custom remote control interface based on Raspberry Pi"
    title: "Robot Platform"
    excerpt: "We chose to customized a Neato Robot vacuum for its low price and powerful sensors."
    url: "#robot-details"
    btn_label: "Robot Details"
    btn_class: "btn--primary"
  - image_path: website_graphics/bridge_of_death.jpg
    alt: "A student taking a cell phone picture of a robot traversing a spiral wooden track called The Bridge of Doom"
    title: "Module Overview"
    excerpt: "The module uses 3 robotics challenges to teach math, physics, and engineering content."
    url: "#module-details"
    btn_label: "Module Details"
    btn_class: "btn--primary"

feature_row_robot:
  - image_path: How to/Pictures/neato_overview.jpeg
    alt: "A picture of a Neato robotic vacuum cleaner with a custom remote control interface based on Raspberry Pi"
    excerpt: "The documentation describes both how to connect to the the physical robot or a simulator and how to build your own customized Neato.

    ### Student Facing Documentation\n
    * [Meeto your Neato!: Environment Setup and Connecting](How to/Environment Setup and Connecting to the Neatos.pdf)\n
    * [Sample Code](Sample code/sample_code)\n

    ### Teaching Team Documentation\n
    * [Shopping list](How to/shopping_list)\n
    * [Platform Conversion Instructions](How to/Platform Conversion Instructions.pdf)\n
    * [Raspberry Pi Setup](How to/setup_raspberry_pi)
"

feature_row_bod:
  - image_path: website_graphics/bridge_of_death.jpg
    alt: "A student taking a cell phone picture of a robot traversing a spiral wooden track called The Bridge of Doom"
    excerpt: "
    The Bridge of Doom challenge involves programming the robot to successfully drive over a harrowing bridge.  The bridge is made less harrowing since students have a parametric equation defining its shape.  Students learn about robot kinematics, curves and motion, and using distance sensors to correct for errors.

    ### Schedule and Supporting Documents

    * [Night 1: Parametric Curves and Motion](Night 1- Parametric Curves, etc/M3_Night1.pdf) <!-- solutions seem to be missing [(Night 1 with Solutions)](Night 1- Parametric Curves, etc/M3_Night1_Solutions.pdf) -->\n
    * [Day 2: Curves, Motion, and Neato](Day 2- Curves, Motion, and Neato/M3_Day2.pdf)\n
    * [Night 2: Angular Velocity, Neato, and Partial\n Derivatives](Night 2- Robot Velocities, Partial Derivs, Chain Rule/M3_Night2.pdf) ([night 2 with solutions](Night 2- Robot Velocities, Partial Derivs, Chain Rule/M3_Night2_Solutions.pdf))\n
    * [Day 3: Encoders, Mapping, and Intro to the Bridge of Doom](Day 3- Encoders and Mapping/M3_Day3.pdf)\n
    * [Night 3: Crossing the Bridge of Doom](Night 3- Bridge of Doom/M3_Night3.pdf)"

feature_row_gauntlet:
  - image_path: website_graphics/gauntlet.png
    alt: "A Neato robot amidst an obstacle course called The Gauntlet"
    excerpt: "The Gauntlet is an obstacle course with four difficulty settings (students can choose which one to complete).  The challenge teaches robust optimization techniques, line and curve fitting, frames of reference, potential fields, and basic path planning.

    ### Schedule and Supporting Documents

    * [Night 5: Polar LIDAR Express](Night 5- LIDAR/M3_Night5.pdf) ([night 5 with solutions](Night 5- LIDAR/M3_Night5_Solutions.pdf))\n
    * [Day 6: The RANSAC Algorithm and Finding Lines](Day 6- RANSAC/M3_Day6.pdf)\n
    * [Night 6: Frames of Reference and LIDAR](Night 6- Frames of Reference and LIDAR/M3_Night6.pdf) ([night 6 with solutions](Night 6- Frames of Reference and LIDAR/M3_Night6_Solutions.pdf))\n
    * [Day 7: Potential Fields](Day 7- Potentials and Gauntlet intro/M3_Day7.pdf)\n
    * [Night 7, Day 8, Night 8: The Gauntlet](Night 7 and 8- Gauntlet Challenge/M3_Night7_and_8.pdf)\n
    * [Day 9: Module and QEA Synthesis and Reflection](Day 9 - Final Event/FinalEvent.pdf)"
---

The Robo Ninja Warrior module teaches math, physics, and engineering content through fun, hands-on, and customizable challenges. The module includes three challenges that provide scaffolded opportunities to master new theory and apply it to programming a mobile robot to accomplish a task.  Robo Ninja Warrior is part of a 12-credit, two course sequence at Olin College called Quantitative Engineering Analysis.  This module sits within [the first, 8-credit part of the course](https://olin.smartcatalogiq.com/en/2019-20/Catalog/Courses-Credits-Hours/ENGR-Engineering/2000/CIE2019A).


We uses a low-cost robotic platform with powerful sensors, including LIDAR, bump detectors, wheel encoders, and an accelerometer.  The robot can be put together for $350 and allows students to program it remotely on their own laptops using MATLAB's ROS toolbox.  This structure leads to an easy to manage classroom that can scale to many robots and many students.


{% include feature_row %}

*Inspired to learn more?  E-mail <a href="mailto:Collaboratory@olin.edu">Collaboratory@olin.edu</a>.*


## <a name="course-philosophy"/> QEA in a Nutshell

Quantitative Engineering Analysis (QEA) is an interdisciplinary, integrated, course for students to become proficient in learning new technical content and successfully completing projects that have a significant analytical component to them.  This video summarizes some of the rationale and specific pedagogy behind the course.

<p align="center">
 <iframe src="https://www.youtube.com/embed/MFL4gd2IMm8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>


## <a name="robot-details"/> Robot Details

{% include feature_row id="feature_row_robot" type="left" %}

## <a name="module-details"/> Intro to Mobile Robotics


The opening day of the course includes a number of activities to introduce fundamental concepts in mobile robotics.  The work is largely conceptual and lays the groundwork for the quantitative work to come.

### Schedule and Supporting Documents

* [Day 1: Introduction to Mobile Robotics Sensory Motor Loops, Motion of Rigid Bodies](Day 1- Intro to Mobile Robotics/M3_Day1.pdf)

## Challenge 1: Crossing the Bridge of Doom

{% include feature_row id="feature_row_bod" type="right" %}

## Challenge 2: Flatland

In the Flatland challenge, students program their robot to ascend a virtual mounting using the concept of steepest ascent (in the past we also used a physical mountain).  The challenge introduces concepts from numerical optimization and provides some light touch points with differential equations.

### Schedule and Supporting Documents

* [Day 4: Optimization](Day 4- Optimization/M3_Day4.pdf)
* [Night 4: Optimization and Gradient Ascent](Night 4- Gradient Ascent and Optimization/M3_Night4.pdf) ([night 4 with solutions](Night 4- Gradient Ascent and Optimization/M3_Night4_Solutions.pdf))
* [Day 5: Flatland Challenge](Day 5- Flatland/M3_Day5.pdf)

### Deprecated version

In the past we've done a version of this challenge where the Neato uses its accelerometer to implement steepest ascent to navigate to the top of a physical mountain.

* [An image of students watching their robot ascent the mountain](website_graphics/annie_nina_mount_doom.jpg)
* [A video of a student's robot ascending the mountain](https://www.youtube.com/watch?v=t7Caw4KeEV4)

## Challenge 3: The Gauntlet

{% include feature_row id="feature_row_gauntlet" type="left" %}

## Conclusion and Learning More

The Robo Ninja Warrior module serves as a point of integration between many of the core areas of QEA (e.g., linear algebra, optimization, vector calculus, kinematics, and motion).  The physical embodiment of these often abstract concepts is a strong contributor to the success of the module (as determined by student feedback).  Despite the fact that the module is successful at Olin, we realize that everyone's institutional context is different. To connect with folks at Olin College to learn more about this module or determine how you might build off of this at your own institution, e-mail <a href="mailto:Collaboratory@olin.edu">Collaboratory@olin.edu</a> to start the conversation.

### Other Documents on QEA

* S. Govindasamy, R.J. Christianson, J. Geddes, C. Lee, S. Michalka, P. Ruvolo, M.H. Somerville, A.C. Strong: [A Contextualized, Experiential Learning Approach to Quantitative Engineering Analysis](https://ieeexplore.ieee.org/document/8658526), FIE 2018.
