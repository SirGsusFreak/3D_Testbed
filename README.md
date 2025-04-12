# 3D_Testbed
 
This personal project showcases my work on developing enemy behaviors in a 3D envirement similar to 3D Platformers.

This project was inspired by a YouTube video by [Pannenkoek2012](https://www.youtube.com/@pannenkoek2012) in which he breaks down the behaviors and quirks of the Goomba in Super Mario 64
[Every Goomba Glitch in Super Mario 64](https://youtu.be/mcI1kUvVMYM?si=uLaima1zga3EKeZy)

This project implements a modular movement AI system in Godot 4.3, designed for use in 3D games where enemies or characters need to move around in simplistic yet dynamic ways.

## Purpose
The goal of this project is to create a flexible and extensible enemy behavior system that allows different enemy types to share core logic (via a base Enemy class), while also allowing each type to implement or override its own unique behaviors. This includes base movement (e.g., wandering or patrolling), aggro logic (e.g., chasing or fleeing), and debugging tools for visualizing AI state and movement.

## Features Implemented
### Core Architecture
- Enemy Base Class: Shared behavior such as health, target tracking, movement logic routing, and signal handling.
- Movement Modes: Modular design with swappable scripts (e.g., wander_movement.gd) to enable diverse behaviors across different enemy types.

### Wander Movement Behavior
- Randomized walking within a defined home range.
- Periodic transitions between walking, standing, and turning states.
- Smooth turning toward a new target direction.
- Reflection logic when colliding with obstacles to bounce off and change direction.
- Auto-return to home if the enemy leaves its designated range (home_sick behavior).

### Debugging
- Visual debug arrows for facing and target direction.
- Target arrow updates in real-time to indicate movement direction.
- Home area and aggro range visualization toggles.
- Dynamic color changes on arrows for state feedback (e.g., blue for returning home).

### State and Signal Handling
- Uses GDScript signals to trigger behavior transitions when entering or exiting areas.
- Home range detection emits signals to return or resume normal wandering.

### Currently Working On
- Implement aggro logic behaviors such as chasing where the enemy quickly moves towards enemy target

### Future Plans
- Add patrol and guard movement scripts.
- Adding ranged attacking and fleeing aggro behaviors.
- Introduce size variations with scaling stats and visuals.
- Optional boss-specific behaviors separate from this base system.

### Inspiration
This project was inspired by a YouTube video by Pannenkoek2012 in which he breaks down the behaviors and quirks of the Goomba in Super Mario 64

[![Watch the video](https://img.youtube.com/vi/mcI1kUvVMYM/mqdefault.jpg)](https://youtu.be/mcI1kUvVMYM?si=uLaima1zga3EKeZy)


