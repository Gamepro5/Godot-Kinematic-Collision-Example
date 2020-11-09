# Godot-Kinematic-Collision-Example
Getting more low level, trying to understand godot's collision physics so that I can wrangle a perfect kinematic body that mirrors what the source engine does.

# How does this work?

The general Idea behind it is that we want to have the net x and z velocity (the directional plane) to be unaffected by slopes, just like how the source engine and many other game engines do it. This would make it appear that you go up the slope at the same speed as you go on the ground. The way Godot handles this is a nightmare, so I decided to draw a diagram to understand what I am trying to do and how I can work around it.

If we represent an arbitrary slope as a right angle triangle, we can get the angle of the slope from a kinematic collision. Suppose it's under 45 degrees. Then we take that angle and find the tangent of it. Why tangent? Because on a right triangle, we know the x or z value: speed, since direction is normalized. Suppose the speed is 1 unit per tick. Then, if the angle of the slope is 45 degrees, we need to offset the y velocity by the tangent of 45 degrees times the speed, Isolating our unknown, the vertical leg. This works like a charm, except rounding errors cause the collisions to not register sometimes. To solve this, I added a -0.28 buffer. This buffer also prevents the issue that if the developer decides to make the max floor angle 90 degrees for some reason, you won't go into infinity (since a tangent of 90 degrees is infinity.) Another issue I will solve later is that the player cant have a negative y offset when going down slopes, so you kind of bounce down slopes.

I'm quite proud of it, since so far it seems to be the closest anyone has gotten to making a perfect movement system. :)

# How is this "low level"

It isn't really aside from the fact that `move_and_slide()` actually uses `move_and_collide()`. That's why this project uses `move_and_collide()` because it gives me more flexibility with the move and collide but just a test parameter. I used gdscript but I plan to make my game in C# once I can figure out how to actually run Godot mono projects.