---
title: "Meeto your Neato!"
toc_sticky: true
---

## Purpose of this How-to

This document will help you to get you up and running with your Neato robot.  After following these instructions you will be able to connect to your robot (or a simulated robot), examine its sensor data, and drive it around.

> ***Note for Spring 2021 QEA Students:*** Please excuse the references to the physical robot in this document.  As you probably guessed we won't be able to use them this year, but we did create a really cool simulator for you to use!

## Overview

In this module we will be programming the Neato BotVac. The Neato is a powerful, low cost robot platform that we have customized for QEA (it's also technically a vacuum cleaner, but we'll be ignoring that for this module!). We have engineered the platform to abstract away a lot of the frustrating bits, allowing you to focus on learning the really fun robotics, physics, math, and computing content.

<p align="center">
<img src="Pictures/neato_overview.jpeg" alt="A picture of a Neato robotic vacuum cleaner with a custom remote control interface based on Raspberry Pi" width="60%" height="60%">
</p>

The robots have each been outfitted with a Raspberry Pi.  The Raspberry Pi is a low cost, Linux computer that will serve as a bridge between your laptop and the robot.  To use the robot you will initiate a connection from your laptop, via the Olin network, to the Raspberry Pi.  Once the connection has been made, the Raspberry Pi will start talking to the robot.  All sensor data will then be streamed from the Raspberry Pi to your laptop over Olin's wireless network.  Your laptop will process this sensor data and then send motor commands to the robot over the same network.  In this way, all important computation will be done on your laptop.  This architecture simplifies the sharing of robots and makes debugging and editing code as easy as possible.

Since you are not modifying the code running on the Raspberry Pi, each robot will function identically (i.e. there is no software you need to modify on the robot).  While we do have enough robots (31) to give each table their own robot, that wouldn't be optimal.  For example, sometimes your robot will run out of batteries, and you'll want to grab another robot while yours charges.

We'll be programming the robots using ROS.  ROS is a powerful, open-source framework for robotics that has been widely adopted in both industry and academia.  ROS runs natively on Linux, however, we are supporting Windows and Mac OSX via Docker.  Therefore, you can connect to the robots through Windows, Linux, or Mac OSX.

ROS supports several programming languages out of the box, including C++, Python, and Java.  Additionally, MATLAB's Robotics System Toolbox includes support for ROS as well.  In this document and in this module, we will walk you through setting up your environment to connect to the robots using Windows, and we will show you how to program the robots using MATLAB.  Some folks, especially those in SoftDes, may want to use Ubuntu instead.  This is totally fine, and we have instructions [on how to setup your environment for Ubuntu](#notes-for-working-in-linux).  If you'd like, we also have [instructions for using the robots in Mac OSX](#notes-for-working-in-macosx).

## Docker Setup

### Highly Recommended Pre-Install Instructions

For lots of folks, you will be able to skip this step, but we have noticed that some of the student Dell laptops will not be able to complete the Docker install process without doing these steps.  In any case, these steps do not hurt to do even if you could have gone through the installation without performing them.  As a result, we encourage you to do them.  If you are interested in why we have to do this, you can check out the Docker help article [Manually Enable Docker for Windows Prerequisites](https://success.docker.com/article/manually-enable-docker-for-windows-prerequisites).

In this step you'll be manually enable the Hyper-V and Container Features, which are both necessary for Docker.  First, run PowerShell by typing "powershell" into the windows search bar, right clicking on Windows PowerShell (not the ISE version), and then selecting "Run as Administrator" in the menu that appears. 

![an image showing powershell being opened with admin privileges](Pictures/run-powershell-from-cortana.png)

> If you are unfamiliar with how to run PowerShell, here are some links to help you.
> * [5 Ways to Open Windows PowerShell](https://www.isunshare.com/windows-10/5-ways-to-open-windows-powershell-in-windows-10.html)
> * [5 Ways to Run PowerShell as Administrator in Windows 10](https://www.top-password.com/blog/5-ways-to-run-powershell-as-administrator-in-windows-10/)

In the PowerShell window that pops up, type the following two commands (tip: when asked if you want to restart your computer after entering the first command, answer "no", and then answer "yes" to the same question after entering the second command.  This will save you one reboot).

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName containers -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

You will likely need to restart your computer after completing these steps. Once you've completed the restart process, you can run the Docker installer.

### Running the Docker Installer

The only operating systems officially supported by ROS are Ubuntu and Debian (although recently Windows support has been introduced, but it is not straightforward to use).  By using a virtual machine we can run an Ubuntu machine from within your Windows setup, which will allow us to run ROS.  The tool we will be using to accomplish this is called Docker.  Docker will allow us to get the QEA robot software installed on your machine in a relatively painless manner (avoiding the need to install and configure a bunch of software packages yourself).

To install Docker, download and run the installer from [DockerHub](https://hub.docker.com/editions/community/docker-ce-desktop-windows/) by clicking the "Get Docker" link. When you see two checkboxes, leave both as is; do not check the third option. You want to run Docker with Linux containers, not Windows containers, so that we can use Docker to run Linux code. Your selections will look like this (depending on how your machine is configured, you may not see the option regarding WSL2).

<p align="center">
<img alt="The docker installer with the first two checkboxes selected" src="Pictures/dockerconfig.png" width="80%"/>
</p>

Once the install is complete you may be asked to restart your computer.

### Making Sure Docker is Setup Properly

Once the Docker installation has completed (and you have possibly restarted your computer), you should run Docker desktop by either clicking on its icon on your Desktop (the icon looks like a smiling whale) or from the Windows 10 start menu.  If everything is working properly, you will see a message pop up that says something like "Docker is Running.  Open PowerShell to start hacking" (it takes a bit of time for this to show up upon reboot, so be patient). Sometimes Docker will say that it will take a few seconds to be up and running, but in our experience it often takes longer. 

You can also check the status of Docker by clicking on the Docker Desktop icon in the status bar at bottom-right of your screen.

As a final check, type the following command into PowerShell (which you can open via the Windows search box).

```powershell
docker run hello-world
```

If all went well, you should see output that starts with text like.

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Troubleshooting Docker

*Issue:* Docker Installer Got Stuck "Deploying Required Windows Features"

First, if you are having any issues with any of this (e.g., installing Docker), e-mail the QEA teaching team with a description of the problem!  If you ran into the issue where the installer got stuck, it is likely because you need to manually enable the required windows features as described in [this previous section](#highly-recommended-pre-install-instructions).

*Issue:* Docker Installed, but Won't Start 

There are some reports that Windows security features are interfering with the Virtual Machine software that Docker uses.  If Docker still won't start properly (e.g., as indicated when you click on the Docker Desktop icon or when you try to run the hello-world example), try the following steps.


1. Open "Window Security"
2. Open "App & Browser control"
3. Click "Exploit protection settings" at the bottom
4. Switch to "Program settings" tab
5. Locate "C:\WINDOWS\System32\vmcompute.exe" in the list and expand it
6. Click "Edit"
7. Scroll down to "Code flow guard (CFG)" and make sure it is set to "Override system settings" and the toggle immediately below is set to "Off".
8. Start vmcompute from an administrator PowerShell
```powershell
net start vmcompute
```
If this goes well, you should see something indicating that ``vmcompute`` is starting (or has already started).
9. Reboot your computer to give Docker a chance to start up again.  You can then try running the hello world image to see if everything works.

> ***If you still get an error after doing this, revisit the steps above but in step 7 use "Override system settings and put the toggle to "On" with "Use strict CFG" unchecked (we know that it is bizarre to try it both ways, but this is a weird error and there are reports of this working on the Docker forum.  It also worked for one of the Spring 2020 QEA students).***

### Getting Docker to Play Nice with Virtual Box

If you are already running a virtual machine on your system (e.g., for SoftDes), you will need to temporarily disable the Windows Hyper-V feature and reboot your machine.  When you want to use Docker again, you will have to re-enable Hyper-V.  Yes, this is super annoying.  Sorry!  Here are some [instructions for toggling Hyper-V on and off](https://hazaveh.net/2015/11/easily-disable-hyper-v-to-run-vmware-and-virtual-box/) so you can switch back and forth between Virtual Box and Docker.

## Downloading Required MATLAB Toolboxes

Before programming the robot in MATLAB, you will need to have the appropriate MATLAB toolbox installed.
* If you are using MATLAB R2019b or earlier, you want the Robotics System Toolbox.
* If you are using MATLAB R2020a or later, you want the ROS Toolbox.

To install additional toolboxes into your MATLAB environment, follow the [instructions on the IT Wiki for installing MATLAB](http://wikis.olin.edu/it/doku.php?id=matlab).  When running the MATLAB installer, make sure to select the appropriate toolbox for the robot (depending on your MATLAB version as described above).

## Connecting to the Physical Neatos

### Step 1: Grab a battery for the raspberry Pi

Checklist before performing this step:

1. The battery indicator light should be at least level 2 (preferably full)

### Step 2: Choose your Neato

Checklist before performing this step:

1. Make sure the Neato's batteries are charged.  To test this, pull the Neato away from it's charging station and for the newer Neato's hit the button near the front bumper of the Neato that has the home icon on it. For the older Neato's hit the larger orange power button.  The display should illuminate revealing a battery capacity indicator.  Sometimes you will have to click the button below the display to dismiss any errors that show up on the Neato’s screen before the battery level is displayed.

### Step 3: Connect the USB battery pack to the Raspberry Pi's USB cable.

It should take about 1 minute for the robot to be ready to use (see step 4 for a final checklist).

### Step 4: Connecting to the Neato from Your Laptop

Checklist before performing this step:

1. Raspberry pi display backlight is illuminated and not flashing on and off (see troubleshooting section for what to do if this is not the case)
2. Raspberry pi display shows that the Neato is connected to the OLIN-ROBOTICS network and has an IP address assigned to it.
3. Raspberry pi display shows that the signal strength of the Neato's connection is at least 70 (the max is 99) for the wifi dongles with antennas, and at least 50 (max is 65) for the dongles without antennas.  Note: If the signal strength is too low see troubleshooting section for more information.
4. Your laptop is either connected to the ethernet or the OLIN wifi network (Note: this will not work if you are on OLIN-GUEST).

Open PowerShell, enter the following command, and hit enter (unfortunately, the command is super long, but all parts are necessary).  Replace the part that says HOST=192.168.16.68 with the IP address of your robot (the IP address can be found from looking at the display of the Raspberry Pi on your Neato).

```powershell
docker run -e HOST=192.168.16.68 --rm --sysctl net.ipv4.ip_local_port_range="32401 32767" -p 11311:11311 -p 32401-32767:32401-32767 -it qeacourse/robodocker:actual
```

You can verify this worked because the robot will start making a quiet whirring sound and the laser (visible from the side) will start rotating. You should also see in the command window that you are "connected".

### Step 5: Shutting Down the Raspberry Pi

When you are done working with the robot it is important to properly shutdown the raspberry pi. DO NOT just unplug the battery. To shutdown the pi, push the "down" button until you see the message "Press select to Shutdown". Press select and wait for the green "ACT" LED on the left side of the Pi to flash steadily ten times then stay off. It is then safe to unplug the battery.

<p style="text-align: center;">
<img alt="Visual instructions for turning off the Raspberry Pi" src="Pictures/s7vHYkMHZEmtoXhtdLxNdig.png"/>
</p>

### Step 6: Connect through MATLAB

TBD (will update with instructions next time we run QEA with physical robots)


### Troubleshooting Your Neato

*Symptom:* Both the red and green LEDs on the raspberry pi are illuminated and not flashing.

*Potential Cause:* the Pi was unable to boot from its SD card.

<ul>

<li>Solution 1: the first thing to check is that the Raspberry Pi's SD card is fully inserted into the Raspberry Pi.  See the image below for the location of the SD card.  You will know it is fully inserted if you push on the card and it clicks into place.

<p align="center">
<img src="Pictures/raspberry_pi_b_6_0_0.jpg" width="70%"/>
</p>
</li>
<li>Solution 2: if the card is fully inserted, the SD card may have become corrupted (possibly because some people didn't properly shutdown the Raspberry Pi!).  Please send me (Paul.Ruvolo@olin.edu) an e-mail and tell me which robot is having the problem.  I'll fix it ASAP, but in the meantime just use another robot.</li>
</ul>

*Symptom:* the raspberry Pi display's backlight is flashing on and off.

*Potential Cause:* the Pi cannot connect to the robot via the USB cable.

* Solution: sometimes the Neato will turn off due to inactivity.  Press button near the front of the Neato’s bumper labeled with the home icon to wake your Neato up.  If that doesn't work, shutdown and then reboot the Pi.  If none of this works, the robot battery might be dead.  Try recharging the robot.  While the robot is recharging, switch to another robot.


### *Symptom:* the Wifi signal strength indicator on the Raspberry Pi is below 60 even though you are right near an access point.

*Problem:* The Pi has connected to an access point that is not the closest one (this will sometimes happen).

* Solution: Assuming the Pi display is at the screen showing the IP address, press right to enter the network setup menu.  OLIN-ROBOTICS should be highlighted with an asterisk.  Press right again to reconnect the Pi to the Wifi.  If it doesn't work the first time, try one more time.  If it doesn't work then, switch to a new robot.


## Connecting to the Simulated Robot

We will be using MATLAB as a means to connect to the your robot (both simulated and physical) and to program it to execute various behaviors.  Note that you need to have the correct MATLAB toolboxes installed in order for this to work (see previous ection).

Start up MATLAB.

Use this [MATLAB drive link](https://drive.matlab.com/sharing/e74dfe9c-44ed-4695-bb93-281bf955050a) to connect to the code for this module.  Once you accept this invitation, navigate to the ``QEASimulators`` directory.  Run the following command in MATLAB.

```MATLAB
>> qeasim start empty_no_spawn
```

If all went well, you will see output that looks like the following.

```MATLAB
Making sure docker is running
Docker is ready
Shutting down MATLAB ROS Node in case it is running
This might take up to 30 seconds
Shutting down docker container in case it is running

You will have to manually close any simulator visualizations in your browser
If you have yet to download the software, you will see a ton of output
60d3dffd10deb3942e8468631945a8c0538517d6e8b278b41d8133080aab64b5
ROS launched.  Waiting for ROS to be ready.
ROS not yet ready
ROS not yet ready
ROS not yet ready
initializing connection from MATLAB to ROS
Initializing global node /matlab_global_node_22997 with NodeURI http://host.docker.internal:64461/
Connection made.  Checking to see if connection is good.
Connection looks good.  Opening visualizer
If you need to connect from a different browser, use the following link to see the simulator.
http://localhost:8080
```

A browser window should open and display the following visualization of your robot.

![A visualization of a Neato in an empty simulated world](Pictures/empty_sim_visualization.png)

## Programming Your Robot

Now that you are connected, you can see the list of topics by typing the following command into the command window.

```matlab
rostopic list
```

Each of these topics is either a sensor channel (e.g., laser scanner, bump sensor, wheel encoder) or a motor control channel (e.g., ``cmd_vel``, ``raw_vel``, etc.).  Go ahead and display the data flowing across the ``/bump`` topic by typing the following command in the command window.

```matlab
rostopic echo /bump
```

You should see output like this.

```
  Data   :  [0, 0, 0, 0]
  Layout    
    DataOffset :  0
    Dim        :  []
```

The interpretation of each of these numbers is dependent on the particular topic you are examining, however, in the case of the /bump topic the four numbers in Data correspond to the output of each of the four bump sensors on the robot.  Go ahead and push the front bumper of the robot to see which bump sensor corresponds to which number.


As always, you can use Ctrl-C to terminate the execution of any Matlab script so you can keep programming.

### Trying the Teleop Script

As a final test of your environment, we're going to drive the robot around a little bit.  Please visit the [teleopAndVisualizer page](../Sample_code/teleopAndVisualizer) to download that script.  Assuming you are connected to the robot or the simulator, you can start that script and drive the robot around with your keyboard. Mappings between individual keys and robot motions are documented in the script itself.

### Your First MATLAB Robotics Program

Let's go ahead and create a program to drive the robot forward until it rams into something.  To do this we'll need to first learn how to control the robot's wheels.  In order to send a velocity to each of the robot's wheels we will need to create a publisher for the ``/raw_vel`` topic.

```matlab
pub = rospublisher('/raw_vel');
```

Once we have a publisher, we can create a message suitable for sending on that topic.

```matlab
msg = rosmessage(pub);
msg.Data = [.1, .1];
send(pub, msg);
```

This message corresponds to telling the robot’s wheels to each move forward at a velocity of 0.1 m/s.


If your robot is not moving, return to your firewall settings and make sure ALL MATLAB inbound rules are as described above. (There could be new inbound rules now that you've connected to the robot.)


We can create subscribers to topics using the rossubscriber command.

```matlab
sub_bump = rossubscriber('/bump');
```

We can put these two together to create a simple program where the robot will move forward with a constant velocity (in this case 0.1 m/s) until one of the bump sensors is triggered.  You can put this code in a MATLAB script (e.g., driveUntilBump.m).


```matlab
pub = rospublisher('/raw_vel');
sub_bump = rossubscriber('/bump');
msg = rosmessage(pub);

% get the robot moving
msg.Data = [0.1, 0.1];
send(pub, msg);

while 1
    % wait for the next bump message
    bumpMessage = receive(sub_bump);

    % check if any of the bump sensors are set to 1 (meaning triggered)
    if any(bumpMessage.Data)
        msg.Data = [0.0, 0.0];
        send(pub, msg);
        break;
    end
end
```

### Troubleshooting Your MATLAB Setup

*Problem:* you are able to receive sensor data by subscribing to topics, but the robot will not respond to motor commands.

*Potential Cause:* your security settings are preventing MATLAB from properly establishing a link between your code and the robot's motor controller.

*Solution:* in order to allow MATLAB to properly communicate with Docker, you need to make sure you have the right firewall settings.  When you run MATLAB for the first time, you were asked whether or not to allow incoming connections to this application.  If you selected "yes", you are good.  If you selected "no", or if you don't remember what you selected (which is probably most people!), then we need to make sure you have the right settings.

1. Type wf.msc into the run dialog (remember, hit the Windows key and "r" simultaneously to bring up the dialog).  This will bring up a dialog that shows your firewall settings.
2. Click on Inbound Rules
3. Browse the list for two rules that say "MATLAB R2019a" (assuming you are using this version of MATLAB.  If you are using a different version of MATLAB, you should look for rules labeled with that version.). If you do not see MATLAB, go on and come back to this later once you have connected to the robots.
4. Click on one of these two rules (you will repeat this process for both), and click the properties button on the right panel of the window.
5. Make sure the following settings are chosen:
* Under the "General" tab, make sure "Enabled" is checked and that "Action" is set to "Allow the connection".
* Under the "Advanced" tab, make sure that "Domain", "Private", and "Public" are all checked and make sure that "Edge traversal" is set to "Defer to user".
Repeat step 5 for the second firewall rule.
6. If you have done this correctly, your "Inbound Rules" list should look like the ones below (note: on this computer the version of MATLAB was R2016a).
![an image showing valid security settings](Pictures/securitysettings.png)


## Notes for working in Linux

You will first need to install MATLAB for Linux.  The [instructions on the IT website](http://wikis.olin.edu/it/doku.php?id=matlab) should work for Linux as well as Windows.  When you are running the installer, make sure to install the ROS Toolbox (if installing R2020a or later) or Robotics System Toolbox (if installing R2019b or earlier).

Follow the [Linux Docker install instructions](https://docs.docker.com/engine/installation/linux/ubuntu/#install-docker)

You want Docker CE, not Docker EE

### Post installation steps

Perform the steps to [manage Docker as a non root user](https://docs.docker.com/engine/installation/linux/linux-postinstall/#manage-docker-as-a-non-root-user). Then restart your computer.

Follow the instructions earlier in this document, but use terminal instead of PowerShell to run the relevant commands.

### Launching the Simulator

Run the simulator using the same Docker command given in the main Using the Simulator section.

### Connecting in MATLAB

When running the ``rosinit`` command, in contrast with the Windows instructions, you should run ``rosinit`` with the following parameters (note: the ``rosshutdown`` command is there in case you had ROS running already).
```matlab
rosshutdown(); rosinit('localhost', 'NodeHost', '172.17.0.1')
```

You will see output that looks like this.
```
Initializing global node /matlab_global_node_17952 with NodeURI http://172.17.0.1:36597/
```

## Notes for Working in MacOSX

Download [Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)

Follow the instructions earlier in this document, but use terminal instead of PowerShell to run the relevant commands.

Everything else should work as with Windows.


