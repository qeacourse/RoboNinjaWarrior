
# Shopping List for Neato Robot Platform

<p align="center">
<img src="Pictures/neato_overview.jpeg" alt="A picture of a Neato robotic vacuum cleaner with a custom remote control interface based on Raspberry Pi" width="60%" height="60%">
</p>

As of this writing, all of these supplies could be purchased for about $350.

## Robot Base

The robot platform for the module is based on the robot vacuum cleaning products of Neato Robotics.  The provided materials should work without modification for any XV or BotVac series robots.  As these models are phased out for newer ones, it is getting harder and harder to find these robots.  At the time of this writing, [you can purchase a new BotVac at Amazon for $299](https://www.amazon.com/Neato-Botvac-D85-Robot-Vacuum/dp/B00Y2ERFUI/ref=sr_1_7?keywords=neato+botvac&qid=1577470633&sr=8-7).   It's also possible that the BotVac connected series might work, but this has not been tested (if you have success with these, <a href="mailto:paul.ruvolo@olin.edu">we'd love to hear about it</a>).

## Raspberry Pi and Supporting Hardware

* [Raspberry Pi2](https://www.amazon.com/Raspberry-Pi-Model-Desktop-Linux/dp/B00T2U7R7I) (newer versions should work, but you will have to make your own image)
* [8GB MicroSD Card](https://www.amazon.com/SanDisk%C2%AE-microSDHCTM-8GB-Memory-Card/dp/B0012Y2LLE)
* USB Battery Pack (approximately 5000 mAH is good, e.g., this is [a good battery pack](https://www.amazon.com/Anker-Upgraded-Candy-Bar-High-Speed-Technology/dp/B06XS9RMWS/ref=sr_1_2?keywords=anker+5000+mah+battery&qid=1577474346&sr=8-2))
* 5Ghz, High Performance WiFi adapter (we've found these to be essential for good performance).  The provided image is designed for the [TP-LINK Archer T2UH AC600](https://www.amazon.com/TP-Link-Archer-T2UH-Dual-Band-Compatible/dp/B00UZRVY12).
* [Small, right angle USB cables](https://www.amazon.com/Cable-Matters-Combo-Pack-Right-Inches/dp/B00S8GU03A/ref=sr_1_2?keywords=left+right+angle+usb+micro&qid=1577474620&s=electronics&sr=1-2) (these are needed for getting the Pi to fit in the Neatos dustbin)

## Other Supporting infrastructure

Depending on the size of your class, you might need to support quite a few of these robots.  You'll need to think about things like providing charging stations in a relatively compact footprint (for both the robots themselves adn for the USB battery packs that power the Raspberry Pis), making sure you have good WiFi coverage, have a method of indicating when equipment breaks, and possibly purchasing an external SD Card writer to enable flashing of multiple cards simultaneously.
