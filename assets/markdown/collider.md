# Interactive Collider Design for 3D Meshes

## Brief

Interactive Collider Design is a computational design system for creating collision meshes (colliders) for both static
and skeletal 3D assets. The tool was developed as a team project over 6 weeks, providing an intuitive interface for
decomposing meshes and rigging colliders to animated skeletons.

### Project Type: Team (Marcus Winter, Gordan Milovac, Patrick Ortiz)

### My Contributions: Static mesh decomposition interface, skeletal mesh decomposition algorithm and interface, collider export system

### Skills: C++, Mesh Processing, Skinned Meshes, Computational Geometry, Assimp, OpenGL, UI Development


<video src="collider_demo.mp4"> </video>


## Overview

After working on collision detection for my custom game engine (PNG Chaser), I realized that creating collision meshes
was surprisingly difficult and unintuitive. Algorithms like VHACD and CoACD provide mesh decomposition, but they don't
give any visual feedback on what the result looks like or export to usable formats like .obj files. This makes it really
hard to tweak parameters and find the right balance between detail and performance. On top of that, existing tools in
Unreal and Unity can generate colliders for rigged meshes, but the assets aren't exportable or usable in other game
engines.

This project was built as part of Brown University's CSCI 2952Y - "Special Topics in Computational Design and
Fabrication" course. The goal was to create a computational design system that solves a real problem for game
developers, physics simulations, and anyone working with collision physics.

The tool provides an interactive interface for generating collision meshes for both static and skeletal 3D assets. For
static meshes, we integrated CoACD (which promises better quality decomposition since it's not voxel-based) and wrapped
it in a UI that lets you tune parameters and see results in real time. For skeletal meshes, I developed an algorithm
that decomposes the mesh based on bone weights, creating convex parts that align with the skeleton structure—something
that wasn't readily available before. All generated colliders can be exported as .obj or .fbx files that work in any
game engine.

GitHub Repository: [https://github.com/mwinter02/CS2952Y_Final](https://github.com/mwinter02/CS2952Y_Final)

## Development

The project was split into several key components, with my work focusing on the static mesh decomposition interface, the
skeletal mesh decomposition algorithm, and the export system.

### Static Mesh Decomposition Interface

For static meshes, I built the UI wrapper around CoACD to make it actually usable. CoACD is a powerful decomposition
algorithm, but on its own it's just a library with no visual feedback. I implemented sliders and controls to expose the
key parameters—things like decomposition threshold, maximum number of convex hulls, and outset distance. Users can tweak
these in real time and immediately see how it affects the collider quality.

<!-- Image: Static mesh UI -->
> #### Static mesh decomposition UI
> 
> ![static_ui.png](/assets/images/projects/collider/static_ui.png)
> 

The visualization was really important here. I added wireframe overlay modes so you can see both the original mesh and
the generated collider at the same time. This makes it way easier to spot areas where the collider doesn't match well or
has too much/too little detail. I also implemented axis-aligned bounding box (AABB) generation as a simpler alternative
to convex decomposition for cases where performance matters more than accuracy.

The main challenge was getting CoACD integrated smoothly—making sure the parameters were intuitive and that the
processing time didn't freeze the UI. For larger meshes, decomposition can take a while, so giving visual feedback
during the process was important.
>

### Skeletal Mesh Decomposition Algorithm

This was the more novel part of the project. There wasn't a readily available algorithm for decomposing skinned meshes
into convex parts that follow the skeleton structure, so I had to design one from scratch.

The algorithm works by analyzing bone weights and skeleton hierarchy. I implemented two main approaches:

**Importance Heuristic:** This calculates the importance of each bone based on its total children and the volume of
vertices it influences. The idea is that bones controlling more of the mesh should get their own colliders. Each vertex
gets assigned to the bone with the greatest weight influence, then I generate one convex hull per important bone using
all the vertices weighted to it.

**All Bones or Custom Selection:** Users can also choose to generate colliders for all bones, or manually select
specific bones they care about. This is useful when you know exactly which parts need collision (like just the limbs, or
just the torso).

> #### Skeletal mesh decomposition UI
> 
> ![skeletal_ui.png](/assets/images/projects/collider/skeletal_ui.png)
> 

For each selected bone, the algorithm creates one convex hull from all the vertices weighted to it. I also added an AABB
option for cases where a simple bounding box is good enough. The generated colliders are then rigged to the same
skeleton as the input mesh, which means they deform correctly during animation and can be exported as a complete skinned
mesh asset.

The biggest challenge here was learning the skeletal mesh structure and correctly traversing the bone hierarchy.
Skeletal meshes have this tree structure where bones have parents and children, and each vertex can be influenced by
multiple bones with different weights. Getting all of this right—especially making sure the colliders stayed properly
attached to their bones during animation—took a lot of debugging.

> #### Rigged colliders with animation
> 
> ![backflip.gif](/assets/images/projects/collider/backflip.gif)
> 

### Export System

Once colliders are generated, they need to be exported in formats that game engines can actually use. I implemented the
export system using Assimp, which handles both .obj files (for static meshes) and .fbx files (for skeletal meshes with
rigging data).

The tricky part was preserving all the rigging information during export. For skeletal meshes, I had to make sure the
bone hierarchy, vertex weights, and bind poses all got written correctly to the .fbx file. I tested the exports in
Blender to verify that the colliders maintained their rigging and deformed properly with the skeleton.

Static mesh exports were more straightforward—just writing out the convex hull geometry as .obj files. But for both
cases, I made sure the exported files kept the same coordinate system and scale as the original mesh so they'd work
seamlessly in any game engine.

> #### Exported colliders
> 
> ![export.png](/assets/images/projects/collider/export.png)
> 

### Team Contributions

While I focused on the decomposition algorithms and export, my teammates handled other critical parts of the system.
Gordan and Patrick implemented the 3D viewer, performance metrics, animation preview system, and conducted the user
study. The viewer was essential for visualizing results, and the metrics helped quantify the accuracy-performance
tradeoffs of different decomposition strategies.

## Conclusion

This project solved a real problem I'd run into during game development—creating good collision meshes is way harder
than it should be. By wrapping existing algorithms in an intuitive interface and developing a new approach for skeletal
meshes, we made a tool that's actually practical for game developers to use.

The skeletal mesh decomposition algorithm was the most technically interesting part. Figuring out how to decompose a
mesh based on bone hierarchy and weights, then rig the results back to the skeleton, required understanding both the
geometry and the animation side of skinned meshes. Seeing the generated colliders deform correctly with animations and
export as usable .fbx files that work in Blender and game engines was really satisfying.

The user study validated that the tool is usable—people were able to generate colliders and tune parameters without much
trouble, though we identified some areas for improvement like adding progress indicators for long computations. Overall,
the project demonstrated that interactive, visual tools for collision mesh generation can make a big difference in
workflow efficiency compared to just running algorithms from the command line.

Building on my experience with collision detection in PNG Chaser, this project gave me a much deeper understanding of
the content creation side—not just how collision works in an engine, but how you actually create the collision meshes in
the first place. The combination of geometric algorithms, mesh processing, and practical tool design made this a really
valuable learning experience.
