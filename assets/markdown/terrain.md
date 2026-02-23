# Terrain Painter

## Brief

A final project for Brown University's CSCI 1230 - "Introduction to Computer Graphics" course in Fall 2023. An
interactive OpenGL application that lets users paint a biome map and procedurally generate a 3D terrain from it,
complete with realistic height mapping, noise functions, and a toon shading mode.

- **Project Type**: Team Project (Marcus Winter, Gordan Milovac)

- **Skills**: C++, OpenGL, Procedural Generation, Noise Maps, Height Maps, GLSL Shaders

<video src="terrain_demo.mp4"> </video>

## Overview

The idea was to give users a canvas to paint with biomes — water, mountains, grasslands, forest, desert — and then
generate a fully realised 3D terrain from whatever they drew. My work focused on the terrain generation itself: taking
the painted canvas and turning it into a height and noise map that drove the 3D output.

![finishedDrawing.png](/assets/assets/images/projects/terrain/finishedDrawing.png)

![topIsland.png](/assets/assets/images/projects/terrain/topIsland.png)

The project builds on concepts covered throughout the CS1230 course, combining rasterisation, terrain generation, and
shader work into a single interactive tool.

### Terrain Generation

My main contribution was the terrain generation pipeline. When the user hits "Generate Terrain", the painted canvas
is read and a height map and noise map are produced for each pixel, both of which are biome-dependent. The actual
3D position (height) of each point on the mesh is then derived from a combination of these two maps using Perlin
noise.

Since Perlin noise is expensive to compute, the height map is precomputed and cached — meaning the terrain renders
in under a second rather than recalculating on every frame.

### Biome Transitions

Each biome has its own height range and noise profile, which made transitions between them look jarring at first.
To smooth things out, I applied a blur pass over the biome boundaries, making the transitions feel natural. A few
extra rules were layered on top for polish: shallow areas above water level become sand, overly tall grassland
patches get reclassified as mountain terrain, and high enough peaks get snow regardless of their painted biome.

### Toon Shading

Gordan handled the toon shader and user interface. The toon shader gives the terrain a flat, cel-shaded look
inspired by traditional cartoon animation, toggled at any time with the T key.
Also thank you to Gordan for creating the awesome demo video.

![toonIsland.png](/assets/assets/images/projects/terrain/toonIsland.png)



