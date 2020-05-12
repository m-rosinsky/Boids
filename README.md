# FishSimulation
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
  
  ![alt text](https://imgur.com/lGzReKR "Boid")
  
  - We need to give the boid a detection radius, as well as a detection angle
  - The boid should be able to detect any boids that are within its detection arc
  - This image shows a view distance of 100 and a view angle of 60°
  
  ![alt text](https://imgur.com/tvErxtZ "Boid Detection Radius")
  
  - Notice the dot turns orange when it is detect by the boid
  
  ![alt text](https://imgur.com/hAZ1ZSu "Boid Detecting a Dot")
  
### Spawn the Boids!
  - With our prefab boid ready to go, I created an environment for the boids to swim/fly around in
  - Boids spawn in a random position with a random velocity vector
  
  ![alt text](https://imgur.com/ZzczdEV "Boid Spawning")
  
