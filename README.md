# CPE-487-Final-Project

## Image Processing Edge Detector
At first, our project was intended to be an image reader and edge detector. We both had taken the course "CPE-462" and learned about image processing and matrix convolutions to detect edges on an image. 

### Plan
We found some existing verilog code online and we thought we could just implement convolution algorithms using math and logic while implementing the image read using a library. 

### Implementation
Unfortunately, not only was the actual edge detection algorithm very challenging to implement, we had a lot of trouble just trying to get the FPGA to read in an image properly. We had to use a third-party library and it would not work. We had to convert jpeg images into .mif ASCII text files and still couldn't get the image read functionality to work. We decided that this project was a bit too advanced for our skillset and available time to work on the project

## Depth Charge
Our next idea was to create a version of the Depthcharge game from 1977. Depthcharge was a game in which a ship at the top of the screen moved horizontally, and tossed down depth charges at submarines that earned more points the farther down the submarines were.

### Plan
Our version was going to have a few minor differences. First of all, the depth charges would be released directly under the boat, rather than to the sides. Secondly, there would be mines that randomly floated up from the bottom of the screen that would trigger a game over if they collided with the player boat. Finally, the score would be shown on the seven segment display on the FPGA board rather than the screen itself. 

### Implementation
This plan, however, unfortunently ran into problems. We wanted to repurpose some of the pong code from lab 6 instead of writing all the files from scratch. In doing so, however, our code often didn't synthesize, and when it did, did not give the expected results. This led to us running out of time, and we ultimately decided to simplify the project into it's bare essentials and create a new game. 

## Dodgeball
This game was called Dodgeball, and it would consist of a player character (a square initialized in the center of the screen) that would be moved with the keyboard, whose goal it was to dodge randomly generated balls initiallized around the edges of the screen. This would allow us to do three main aspects of Depthcharge in a much shorter timeframe. These aspects are the random ball (mine) generation, triggering a game over if a certain sprite got hit by these balls, and using the keyboard to move the player character.

### Plan
Our original plan was to duplicate the sprites from the lab 6 code by creating multiple instances of the components and using the balls as the dodgeballs. We would then code a keyboard-controlled input for the user to move around the screen.

### Implementation
We made progress with this plan and got multiple balls from the modified lab 6 pong code instantiated, but only one was visible due to overlapping sprites or not creating the second instance properly upon the "start" button being pressed. We also had some issues with the second ball instance where VGA pins were getting mapped to multiple times and thus passing the "Synthesis" stage, but creating critical errors in the "Implementation" stage.
