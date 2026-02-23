# Pac-Man

## Brief

My first ever computer science final project, built in Java as part of Brown University's CSCI 0150 -
"Introduction to Computer Science" course. A faithful recreation of the classic arcade game, complete with ghost AI,
a custom UI, and a procedural board generation system — all in my first semester of coding.

- **Project Type**: Solo

- **Skills**: Java, JavaFX, Object-Oriented Design, BFS, Procedural Generation

<!-- Image: Pac-Man screenshot -->

## Overview

The goal was to recreate Pac-Man as a final project for my intro CS course. The course walked through the fundamentals
of programming and object-oriented design through a series of classic game projects — Fruit Ninja, Doodle Jump, Tetris
— and Pac-Man was the capstone. It's the project I look back on most fondly from that semester, and honestly one of
the reasons I got hooked on game development.

The game is a faithful recreation of the original — pellets, power pellets, lives, score, and ghost behaviour all
included — with some quality-of-life improvements like a sharper UI and updated colours.

### Ghost AI

Ghosts navigate the board using a BFS (Breadth-First Search) algorithm to find the shortest path to Pac-Man at each
step. This keeps the ghosts feeling threatening without being unfair, and was a good introduction to graph traversal
early in my CS journey.

### Procedural Board Generation

The feature I'm most proud of from this project. Rather than hardcoding the board layout, I built a system that could
construct the maze automatically from a small set of tile pieces — corners, straight segments, and junctions. Each
tile would detect its neighbours and automatically rotate and connect itself to form a coherent, seamless board.

Getting the logic right for every possible neighbour configuration was tricky, but seeing it snap together correctly
for the first time was one of those moments that made me realise how much I enjoyed problem solving through code.

<!-- Image: Board generation / in-game screenshot -->
