# Boid Simulation
  A simulation of fish/bird movement (flocking) based on the 1986 "Boid" paper by Craig Reynolds
  
# Link to the Paper:
  [Boids](https://www.red3d.com/cwr/boids/)

# About
  Recently I read a paper by Craig Reynolds entitled "Boids" (see link above) that modeled the "flocking" movement of birds/fish in computer simulations.
  I wanted to take a crack at making this using processing so here it is:
  
# Abstract / Summary
  Craig's paper details objects called "boids" that act as the birds or fish or whatever animal you are simulating.
  These boids have a detection radius, as well as a view angle that they can see.
  The boids use 3 "tenants" to choose how it moves and steers to immitate the flocking movement.
  These three tenants include:
  - Separation
  - Cohesion
  - Alignment
  
  Using these three tenants (which I detail more in their respective sections of development), we can simulate our desired movement
  
 # Development
 
 ### Creating our first Boid
  - A pretty simple ellipse will suffice for now!
  
  ![alt text](https://i.imgur.com/lGzReKR.png "A Single Boid")
  
  - We need to give the boid a detection radius, as well as a detection angle
  - The boid should be able to detect any boids that are within its detection arc
  - This image shows a view distance of 100 and a view angle of 60°
  
  ![alt text](https://i.imgur.com/tvErxtZ.png "Boid Detection Radius")
  
  - Notice the dot turns orange when it is detected by the boid
  
  ![alt text](https://i.imgur.com/hAZ1ZSu.gif "Boid Detecting a Dot")
  
### Spawn the Boids!
  - With our prefab boid ready to go, I created an environment for the boids to swim/fly around in
  - Boids spawn in a random position with a random velocity vector
  
  ![alt text](https://i.imgur.com/ZzczdEV.gif "Boid Spawning")
  
  - Instead of turning the boid orange when it is detected by another, I decided to draw an orange line from one boid to the other to demonstrate detection
  
  ![alt text](https://i.imgur.com/95w6EOg.gif "Boid Line Detection")
  
### Separation
  - Separation involves the boids spreading out from each other so as to not crash
  - This screenshot is from Craig's paper:
  
  ![alt text](https://i.imgur.com/rK5uwke.png "Paper Separation")
  
  - The boid will take the average position of all boids in its detection field, and move in the opposite direction of it
  - Here is the result of the boids with separation implemented:
  
  ![alt text](https://i.imgur.com/qa1yBUN.gif "Separation")
  
  - As expected, the boids try to create as much separation as possible from the other boids in the environment
  
### Cohesion
  - Cohesion will encourage the boids to move in schools or flocks
  
  ![alt text](https://i.imgur.com/zoCTgTR.png "Cohesion Paper")
  
  - This is in contrast to our separation factor, but in essence should keep the boids together in a pack, but not on top of each other
  
  - Here is a simualtion of ONLY cohesion, no separation:
  
  ![alt text](https://i.imgur.com/dj7HdpP.gif "Cohesion")
  
  - With only a cohesion factor, giving them the urge to... coheize (???), we can see they form groups on top of each other (except for that one boid in the center... poor guy), and disregard the need to move.
  
### Alignment
  - The alignment factor tells the boids to align its heading with other boids in its detection radius
  
  ![alt text](https://i.imgur.com/8qDOa86.png "Alignment Paper")
  
  - The boid will find the average heading of all boids in its detection radius, and turn to match it
  - Below is a simulation isolating the alignment factor in the boids
  
  ![alt text](https://i.imgur.com/EVu2wtG.gif "Alignment")
  
  - We see the boids all eventually align as one unit, moving in a single direction with no alternating speed
  
### Putting it all together
  - After finding the right balance of weight on each of the factors, we're left with our final product:
  - I went all out on the frames for the gif on this one :)
  
  ![alt text](https://i.imgur.com/mY5fymO.gif "Final Product")
  
  - This looks like a solid simulation of how birds/fish move as a pack
  - Playing around with the weights on the factors, the view distnace, and the view angle yields some interesting/fun results, so I enocurage you to play around with my code, or make your own!
  
### Thoughts
  - Overall this was a fun project to undertake in Processing, and I'm looking forward implementing it into a bigger project
  
# Future Plans
  - Adding a predator to avoid
  - Static obstacles
  - 3 Dimensions
  
# References
  - Craig Reynold's Paper
    - https://www.red3d.com/cwr/boids/
    
  - Coding Train's Video on Flocking
    - https://www.youtube.com/watch?v=mhjuuHl6qHM
    
  - Coding Train's Own Processing Project (Big Shoutout)
    - https://thecodingtrain.com/CodingChallenges/124-flocking-boids
  
  
