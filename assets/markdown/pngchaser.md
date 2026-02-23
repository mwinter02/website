# PNG Chaser

## Brief

PNG Chaser is a 3D survival horror game heavily inspired by Garry's Mod's "nextbot chase" game mode. The game was built
with a custom engine in C++ developed from scratch over the course of a 12-week semester, utilizing OpenGL for
rendering.

- **Project Type**: Solo

- **Skills**: C++, Game Engine development, OpenGL, ECS Architecture, Data-Oriented Design, Collision Detection (GJK/EPA), Pathfinding, Spatial Acceleration Structures


<video src="pngchaser_demo.mp4"> </video>


## Overview

PNG Chaser is a first-person survival horror game where you're trapped in a procedurally generated backrooms
environment. The goal is to avoid the PNG chaser for as long as possible. The chaser uses spatial audio
with left/right channel positioning and distance-based volume, so you can hear it getting closer.

The project was inspired by an Instagram trend at the time, combined with nostalgia for Garry's Mod's nextbot chase game
mode. The game was built as part of Brown University's CSCI 1950u - "3D Game Engine Development" course, entirely from
scratch using C++ and OpenGL.

### Engine Architecture

The engine was built with a focus on performance and scalability. I implemented an Entity Component System (ECS) using
data-oriented design principles, storing components as structures of arrays instead of arrays of structures. This
approach allows for better parallelization, more efficient memory usage, and faster processing. Collision detection uses
the GJK/EPA algorithms for accurate physics responses. Navigation is handled through navigation meshes paired with A*
pathfinding and string pulling for intelligent AI movement. Spatial acceleration structures—including BVH (Bounding
Volume Hierarchy) for static geometry and hierarchical grids for dynamic objects—allow for hundreds of dynamic colliders
with no framerate drops.

<!-- Image: Engine Architecture Diagram -->

### Development Timeline

The project was structured around six milestone assignments over the 12-week semester:

1. **Engine Architecture**: OpenGL renderer, input handling, game loop
2. **Gameworld, ECS, Systems**: Entity management and data-oriented systems
3. **Platformer (Collisions)**: Collision detection and physics responses
4. **Optimizations**: Spatial acceleration structures (BVH, hierarchical grids)
5. **Pathfinding and AI**: Navigation meshes and AI behavior
6. **Final Project**: Procedural generation, spatial audio, and gameplay polish

## Development Log

### Project 0: Engine Architecture

The first step was setting up the core rendering and game loop systems using OpenGL and GLFW. I implemented vertex and
fragment shaders with texture mapping and used the Phong lighting model for realistic surface illumination. Input
handling is managed through GLFW for keyboard and mouse events. The game loop uses a fixed timestep for physics
calculations to keep everything deterministic, while rendering uses a variable timestep to maximize frame rate.

<!-- Image: Early renderer test -->

This project established the basic framework for all the future engine features. The early stages were pretty
straightforward—the real challenges came later when I had to integrate more complex systems like collision detection and
spatial acceleration.

### Project 1: Gameworld, ECS, Systems

This project introduced the Entity Component System (ECS) architecture with a focus on data-oriented design.

Entities are simple IDs, with each system keeping a mapping from entity ID to array index for O(1) lookups using
`std::unordered_map`. Components are pure data structures stored using the "structure of arrays" approach instead of the
traditional "array of structures."

Instead of storing components as traditional structs in a vector:

```cpp
// Traditional approach (Array of Structures)
struct PhysicsComponent {
    vec3 position;
    vec3 velocity;
    float mass;
};
std::vector<PhysicsComponent> components;
```

I used separate arrays for each component field (Structure of Arrays):

```cpp
// Data-Oriented approach (Structure of Arrays)
struct PhysicsSystem {
    std::unordered_map<EntityID, size_t> entityToIndex;
    std::vector<vec3> positions;
    std::vector<vec3> velocities;
    std::vector<float> masses;
};
```

This approach has some major performance benefits:

- Cache efficiency: Related data is stored next to each other in memory, which improves cache hit rates
- Parallelization: Systems can easily process components in parallel batches
- Memory access patterns: Sequential memory access is way more efficient than jumping around

<!-- Image: ECS architecture diagram -->

I implemented several core component types including Transform (position, rotation, scale), Shape (mesh data for
rendering), Controller (input response data), and Physics (velocity, forces, mass). Systems are organized by their
update frequency: Rendering Systems run draw calls each frame with variable timestep, Tick Systems update game logic
each frame, Physics Systems run on fixed timestep for consistent simulation, and Input Systems handle player input.

Building a template-based DOD ECS system was tricky, especially trying to keep type safety while still getting the
performance benefits of data-oriented design. I had to think carefully about memory layout and how systems would
interface with each other to make sure everything stayed flexible and fast.

For more on data-oriented design principles, see [Data-Oriented Design](https://www.dataorienteddesign.com/dodbook/).

### Project 2: Platformer (Collisions)

This project focused on getting collision detection and physics-accurate collision responses working. To test
everything, I built a simple platformer game, though most of the work was on the engine side since it was pretty
complex.

I used the Gilbert-Johnson-Keerthi (GJK) algorithm for collision detection and the Expanding Polytope Algorithm (EPA)
for collision resolution. These are industry standard algorithms that work with any convex shape, which gives a lot of
flexibility.

The collision system supports a bunch of different shapes: cubes (both axis-aligned and oriented bounding boxes),
spheres, cones, cylinders, convex hulls, and triangle meshes.

<!-- Image: Collision shapes visualization -->

Collision responses use impulse-based physics with Newtonian mechanics. I calculate impulses and momentum based on the
masses and velocities of colliding objects, then apply forces in the direction of the Minimum Translation Vector (MTV)
that EPA gives me. This keeps energy conservation and makes things behave realistically.

<!-- Image: Collision response diagram -->

Getting GJK/EPA working was one of the hardest parts of the whole project. The algorithms are pretty complex and need a
solid understanding of computational geometry. The biggest pain point was floating-point precision errors—these caused
huge MTVs to get calculated for shallow collisions. I had to add careful numerical stability checks and epsilon
thresholds to fix it. Still, when I finally got it working and saw objects colliding with accurate physics, it was super
rewarding after all those weeks of debugging.

### Project 3: Optimizations (Spatial Acceleration)

With collision detection working, the next challenge was handling hundreds of dynamic objects. Without spatial
acceleration, checking every object against every other object (O(n²)) quickly became a bottleneck. This project
introduced two different spatial acceleration structures for different use cases.

BVH works great for static geometry. Building the structure is expensive, but once it's built, collision queries are
super fast. I use the Surface Area Heuristic (SAH) to recursively partition objects, which minimizes the surface area of
bounding volumes and makes traversal more efficient. Since you only need to build it once and then query it constantly,
it's perfect for level geometry and static props.

For moving objects, I used a hierarchical grid structure that updates quickly and handles spatial queries efficiently.
The system uses multiple grid levels where each level has cells twice as big as the previous level. Objects get assigned
to grid levels based on their size—small objects go in fine grids, large objects in coarse grids. When querying, I only
check the relevant grid levels, which avoids a ton of unnecessary tests. This setup handles both small and large objects
efficiently without rebuilding expensive structures every frame.

<!-- Image: Hierarchical grid visualization -->

I also added frustum culling to optimize rendering. Each object's bounding box gets tested against the view frustum. If
any corner is inside the frustum, the object gets rendered; otherwise it's culled, which cuts down on draw calls.

The performance improvement was massive. I did a stress test with 100 static floor tiles and 2500 dynamic colliding
spheres exploding outwards and it now runs at perfect frame rates with no drops. This proved that combining
BVH for static objects with hierarchical grids for dynamic objects really works.

> #### 2500 tightly packed spheres with stable 100+ fps
>
> ![explode.gif](/assets/assets/images/projects/pngchaser/explode.gif)
>

Debugging hierarchical grids in 3D was surprisingly hard. 1D and 2D examples made sense, but extending it to three
dimensions with multiple resolution levels took a lot of spatial reasoning. Figuring out which objects belonged in which
grid cells and making sure the multi-level queries worked correctly took a lot of debugging time.

### Project 4: Pathfinding and AI

This project brought the AI to life, getting the PNG chaser to actually hunt the player through complex environments.

Navigation meshes are automatically loaded from OBJ files, with each triangle becoming a navigable surface. This makes
level design pretty flexible—you can just export navigation geometry from your 3D modeling tools and the engine
processes it into something the pathfinding can use.

<!-- Image: Navigation mesh visualization -->

The pathfinding uses A* to find paths across the navigation mesh. The triangles form a graph where adjacent triangles
connect as neighbors. A* searches through this using Manhattan distance as a heuristic to find the shortest path from
the AI's current position to its target.

A* gives you a valid path, but it tends to zigzag from triangle center to triangle center. The funnel algorithm (also
called string pulling) fixes this by taking the sequence of triangles and finding the most direct path through them. It
basically "pulls a string" through the corridor of triangles to find the straightest route. This makes the movement look
way more natural and intelligent instead of robotic.

<!-- Image: Before/after string pulling comparison -->

I used simple decision trees to control AI behavior and pick target destinations based on the game state. These are easy
to extend with new behaviors when needed.

The pathfinding integrates with the ECS architecture pretty cleanly. The Pathfinding Component stores the navigation
mesh reference and current path. The Decision Tree System updates where the AI wants to go. The Navigation System
queries the pathfinding component, runs A* and the funnel algorithm, then updates entity velocities to follow the path.
This separation means multiple AI entities can share the same navigation mesh while keeping their own paths and
behaviors.


Getting pathfinding to work with the data-oriented ECS took some careful thinking. Paths vary in length and need
frequent updates, so finding a cache-friendly way to represent them that still fit the structure-of-arrays approach
needed some creative solutions.


### Project 5: Final Project

The final project brought everything together into an actual game, with procedural generation, spatial audio, and
polish.

The backrooms environment is procedurally generated using a modified Wilson's algorithm, which creates unbiased maze
layouts. I paired this with a modular asset system—walls, floors, and ceilings are designed as modular pieces, so by
just providing a few core assets, the system automatically builds a complete backrooms-themed maze. Each playthrough
generates a completely different layout that captures that liminal, unsettling backrooms vibe.

> #### Chaser approaching player
>
>![chaser_lurking.png](/assets/assets/images/projects/pngchaser/chaser_lurking.png)
>

The audio system uses RAudio for immersive 3D sound. Stereo panning shifts audio between left and right channels based
on where the chaser is relative to you. Volume drops with distance, which builds tension as the chaser gets closer.
You're forced to navigate by sound as much as sight—the chaser's audio cues turn the game from simple avoidance into a
tense cat-and-mouse experience where you're constantly listening for danger.

<!-- Image: Audio visualization -->

The final game has the core mechanics for a horror experience. The UI is minimal so it doesn't break immersion. If the
PNG chaser touches you, game over. I spent time on the lighting, textures, and audio to create that moody, unsettling
atmosphere that fits the survival horror genre.

<!-- Image: Final gameplay screenshot -->

The main challenge here was time management. With limited time to integrate everything, polish the game, and fix bugs, I
had to prioritize carefully. The focus was on creating a solid core experience that showed off what the engine could do
while keeping the game cohesive and playable.

## Conclusion

PNG Chaser was the result of a full semester of engine development, going from a basic OpenGL renderer to complex
systems like collision detection, spatial acceleration, and AI pathfinding. Building a 3D game engine from scratch
taught me a ton about performance-critical programming—data-oriented design and spatial acceleration structures made a
huge difference. Implementing GJK/EPA and navigation algorithms needed solid computational geometry knowledge. Getting
multiple complex systems—physics, rendering, AI, and audio—to work together required careful planning and system design.
And creating that tense horror atmosphere through visuals, audio, and gameplay showed me how important polish and game
feel really are.

The best part was watching everything come together in the final project. Seeing the PNG chaser intelligently navigate
the procedurally generated maze while you're frantically trying to escape, guided only by those terrifying spatial audio
cues—that was really satisfying. What started as a simple OpenGL renderer turned into a full game engine that could
create compelling experiences.

This project really validated data-oriented design and modern C++ techniques for game development. It also showed me how
important it is to pick the right algorithms and optimize carefully. Every challenge I worked through helped me gain a deeper
understanding of game engine architecture and real-time graphics programming.
