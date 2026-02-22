# PNG Chaser

## Brief

PNG Chaser is a 3D survival horror game heavily inspired by Garry's Mod's "nextbot chase" game mode. The game was built
with a custom engine in C++ developed from scratch over the course of a 12-week semester, utilizing OpenGL for
rendering.

### Project Type: Solo

### Skills: C++, Game Engine development, OpenGL, ECS Architecture, Data-Oriented Design, Collision Detection (GJK/EPA), Pathfinding, Spatial Acceleration Structures

<!-- Video Here -->

## Overview

PNG Chaser is a first-person survival horror game where the player is trapped in a procedurally generated backrooms
environment. The objective is to avoid the relentless PNG chaser for as long as possible. The chaser uses spatial audio
to create tension, with left/right channel positioning and distance-based volume attenuation that alerts the player to
its proximity.

The project was inspired by an Instagram trend at the time, combined with nostalgia for Garry's Mod's nextbot chase game
mode. Developed as part of Brown University's CSCI 1950u - "3D Game Engine Development" course, the game was built
entirely from scratch using C++ and OpenGL.

### Engine Architecture

The custom engine was built with a focus on performance and scalability. The Entity Component System (ECS) was
implemented using data-oriented design principles, storing components as structures of arrays instead of arrays of
structures. This approach enables parallelization, more efficient memory usage, and faster processing. Collision
detection uses the industry-standard GJK/EPA algorithms for physics-accurate responses. Navigation is handled through
navigation meshes paired with A* pathfinding and string pulling algorithms for intelligent AI movement. Spatial
acceleration structures—including BVH (Bounding Volume Hierarchy) for static geometry and hierarchical grids for dynamic
objects—allow for hundreds of dynamic colliders with no framerate drops.

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

The foundation of the engine began with setting up the core rendering and game loop systems using OpenGL and GLFW. The
rendering system implements vertex and fragment shaders with texture mapping and uses the Phong lighting model for
realistic surface illumination. Input handling is managed through GLFW for keyboard and mouse events. The game loop uses
a fixed timestep for physics calculations to ensure deterministic simulation, while rendering uses a variable timestep
to maximize frame rate.

<!-- Image: Early renderer test -->

This milestone established the basic framework that would support all future engine features. While the early stages
were relatively straightforward, the real challenges would come in later projects when integrating complex systems like
collision detection and spatial acceleration.

### Project 1: Gameworld, ECS, Systems

This milestone introduced the Entity Component System (ECS) architecture with a focus on data-oriented design
principles.

Entities are represented as simple IDs, with each system maintaining a mapping from entity ID to array index for O(1)
lookups using `std::unordered_map`. Components are pure data structures that are stored using the "structure of arrays"
approach rather than the traditional "array of structures."

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

The engine uses separate arrays for each component field (Structure of Arrays):

```cpp
// Data-Oriented approach (Structure of Arrays)
struct PhysicsSystem {
    std::unordered_map<EntityID, size_t> entityToIndex;
    std::vector<vec3> positions;
    std::vector<vec3> velocities;
    std::vector<float> masses;
};
```

This approach provides significant performance benefits:

- Cache efficiency: Related data is stored contiguously in memory, improving cache hit rates
- Parallelization: Systems can easily process components in parallel batches
- Memory access patterns: Sequential memory access is far more efficient than scattered reads

<!-- Image: ECS architecture diagram -->

The engine implements several core component types including Transform (position, rotation, scale), Shape (mesh data for
rendering), Controller (input response data), and Physics (velocity, forces, mass). Systems are categorized by their
update frequency: Rendering Systems execute draw calls each frame on a variable timestep, Tick Systems update game logic
each frame, Physics Systems run on a fixed timestep for deterministic simulation, and Input Systems process player
input.

Implementing a template-based DOD ECS system presented unique challenges, particularly in maintaining type safety while
achieving the performance benefits of data-oriented design. The templated approach required careful consideration of
memory layout and system interfaces to ensure both flexibility and performance.

For more on data-oriented design principles, see [Data-Oriented Design](https://www.dataorienteddesign.com/dodbook/).

### Project 2: Platformer (Collisions)

This milestone focused on implementing robust collision detection and physics-accurate collision responses. To test the
engine's capabilities, a simple platformer game was developed, though the primary focus remained on the engine
implementation due to the complexity of the task.

The engine uses the Gilbert-Johnson-Keerthi (GJK) algorithm for collision detection and the Expanding Polytope
Algorithm (EPA) for collision resolution. These algorithms were chosen as they are industry standard and support
collision detection for any convex shape, providing both flexibility and accuracy.

The collision system supports a wide variety of primitive and complex shapes: cubes (axis-aligned and oriented bounding
boxes), spheres, cones, cylinders, convex hulls, and triangle meshes.

<!-- Image: Collision shapes visualization -->

Collision responses are calculated using impulse-based physics with Newtonian mechanics. Impulses and momentum are
computed based on the masses and velocities of colliding objects, and forces are applied in the direction of the Minimum
Translation Vector (MTV) provided by EPA. The system maintains energy conservation and realistic physical behavior.

<!-- Image: Collision response diagram -->

Implementing GJK/EPA proved to be one of the most challenging aspects of the project. The algorithms are conceptually
complex, requiring deep understanding of computational geometry and optimization theory. The most significant difficulty
came from floating-point precision errors, which caused enormous MTVs to be calculated for shallow collisions. These
precision issues required careful numerical stability considerations and epsilon thresholds to resolve. Despite the
difficulty, successfully implementing these algorithms was incredibly rewarding—watching objects collide and respond
with physically accurate behavior validated weeks of debugging and refinement.

### Project 3: Optimizations (Spatial Acceleration)

With collision detection working, the next challenge was scaling to hundreds of dynamic objects. Without spatial
acceleration, the naive O(n²) collision checking approach quickly became a performance bottleneck. This milestone
introduced two complementary spatial acceleration structures optimized for different use cases.

BVH provides excellent performance for static (non-moving) geometry. While construction is computationally expensive,
the resulting tree structure dramatically accelerates collision queries. Objects are recursively partitioned using the
Surface Area Heuristic (SAH) to minimize the surface area of bounding volumes, optimizing traversal efficiency. Since
the structure only needs to be built once and queried often, it's ideal for level geometry and static props that don't
move during gameplay.

For moving objects, a hierarchical grid structure provides fast updates and efficient spatial queries. The system uses
multiple grid levels with exponentially increasing cell sizes. Each grid level has cells with double the width, height,
and length of the previous level. Objects are assigned to grid levels based on their size—smaller objects occupy finer
grids while larger objects use coarser grids. Queries check relevant grid levels, avoiding unnecessary tests. This
multi-resolution approach ensures that both small and large objects can be efficiently queried without rebuilding
expensive data structures every frame.

<!-- Image: Hierarchical grid visualization -->

To optimize rendering, frustum culling was implemented to skip drawing objects outside the camera's view. Each object's
axis-aligned bounding box (AABB) is tested against the view frustum. If any corner of the bounding box lies within the
frustum, the object is rendered; otherwise it's culled, reducing draw calls.

The impact of spatial acceleration was dramatic. A stress test with 100 colliding spheres exploding outwards—a scenario
that was completely unplayable before—now maintained perfect frame rates with no drops. This validated the effectiveness
of combining BVH for static geometry with hierarchical grids for dynamic objects.

Hierarchical grids proved surprisingly difficult to visualize and debug in 3D. While 1D and 2D examples were
straightforward to reason about, extending the concept to three dimensions with multiple resolution levels required
careful spatial reasoning. Visualizing which objects belonged to which grid cells, and ensuring correct multi-level
queries, took considerable debugging effort.

### Project 4: Pathfinding and AI

This milestone brought the engine's AI capabilities to life, implementing intelligent navigation and decision-making
systems that would enable the PNG chaser to hunt the player through complex environments.

Navigation meshes are automatically generated from OBJ files, with each triangle in the mesh becoming a navigable
surface. This approach allows for flexible level design—artists can export navigation geometry directly from their 3D
modeling tools, and the engine automatically processes it into a pathfinding-ready structure.

<!-- Image: Navigation mesh visualization -->

The pathfinding system uses the A* algorithm to find optimal paths across the navigation mesh. The mesh triangles form a
graph, with adjacent triangles connected as neighbors. A* efficiently searches this graph using Manhattan distance as a
heuristic, finding the shortest path from the AI's current position to its target.

While A* finds a valid path through the navigation mesh, it often produces paths that zigzag from triangle center to
triangle center. The funnel algorithm (also known as string pulling) refines these paths by taking the sequence of
triangles from A* and finding the shortest direct path through them. It "pulls a string" through the corridor formed by
the triangles, finding the straightest possible route. This results in much more natural, direct movement that looks
intelligent rather than robotic.

<!-- Image: Before/after string pulling comparison -->

Simple decision trees control AI behavior, determining target destinations based on the current game state. These trees
allow for flexible AI logic that can be easily extended with new behaviors.

The pathfinding system integrates seamlessly with the ECS architecture. The Pathfinding Component stores reference to
the navigation mesh and the current path. The Decision Tree System updates target destinations based on AI logic. The
Navigation System queries the pathfinding component, runs A* and the funnel algorithm, then updates entity velocities to
follow the computed path. This separation of concerns allows multiple AI entities to share the same navigation mesh
while maintaining independent paths and behaviors.

<!-- Image: AI pathfinding in action -->

Integrating pathfinding with the data-oriented ECS required careful consideration of how to store and update path data
efficiently. Since paths can vary in length and need frequent updates, finding a cache-friendly representation that
still worked within the structure-of-arrays paradigm required creative solutions.

### Project 5: Final Project

The final project milestone brought together all the engine's systems into a cohesive game experience, integrating
procedural generation, spatial audio, and gameplay polish to create PNG Chaser.

The backrooms environment is procedurally generated using a modified version of Wilson's algorithm, a maze generation
technique that creates unbiased, uniform spanning trees. The algorithm was paired with a modular asset system for
automatic level construction. Walls, floors, and ceilings are designed as modular pieces, and by providing just a few
core assets, the system automatically generates a complete backrooms-themed maze. The generated environments capture the
liminal, unsettling atmosphere of the backrooms concept, with each playthrough producing a completely different maze
layout.

<!-- Image: Procedurally generated maze -->

The audio system was implemented using RAudio, providing immersive 3D sound that heightens the horror experience. Stereo
panning shifts the audio between left and right channels based on the chaser's position relative to the player. Volume
decreases with distance, creating tension as the chaser approaches. The chaser's sound alerts the player to danger,
forcing them to navigate by sound as much as sight. The spatial audio transforms the gameplay from simple avoidance into
a tense cat-and-mouse experience where players must constantly monitor audio cues to survive.

<!-- Image: Audio visualization -->

The final game includes core mechanics to create a complete horror experience. A minimalist UI doesn't distract from the
immersion. Direct contact with the PNG chaser ends the game. Carefully crafted lighting, textures, and audio create a
moody, unsettling atmosphere fitting for the survival horror genre.

<!-- Image: Final gameplay screenshot -->

The primary challenge during the final project was time management. With only a limited timeframe to integrate all
systems, polish the game, and fix bugs, prioritization became critical. The focus shifted to creating a core experience
that showcased the engine's capabilities while maintaining a cohesive, playable game.

## Conclusion

PNG Chaser represents the culmination of a semester's worth of engine development, from the foundational renderer to
complex systems like collision detection, spatial acceleration, and AI pathfinding. Building a 3D game engine from
scratch provided deep insights into performance-critical programming, where data-oriented design and spatial
acceleration structures dramatically improved performance. Implementing GJK/EPA and navigation algorithms required
strong computational geometry knowledge and careful mathematical reasoning. Combining multiple complex systems—physics,
rendering, AI, and audio—into a cohesive whole demanded careful architecture and system integration. Creating atmosphere
and tension through careful design of visuals, audio, and gameplay mechanics highlighted the importance of polish and
game feel.

The most rewarding aspect was watching all the systems come together in the final project—seeing the PNG chaser
intelligently navigate the procedurally generated maze while the player frantically tries to escape, guided only by the
terrifying spatial audio cues. What started as a simple OpenGL renderer evolved into a fully-featured game engine
capable of creating compelling gameplay experiences.

The project validated the power of data-oriented design and modern C++ techniques for game development, while also
highlighting the importance of careful algorithm selection and optimization. Every challenge overcome—from
floating-point precision errors in collision detection to visualizing 3D hierarchical grids—contributed to a deeper
understanding of game engine architecture and real-time graphics programming.
