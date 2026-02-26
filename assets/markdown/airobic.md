# AiRobic

## Brief

AiRobic is a web application that generates personalised workout plans tailored to a user's fitness goals. It was
built as a final project for CS0320: Software Engineering in Spring 2023 at Brown University. My work focused on the
Java backend and User profile management and authentication through Firebase and Google oAuth.

- **Project Type**: Team (Colin Baker, Marcus Winter, Gordan Milovac, Adam von Bismarck)

- **My Contributions**: User profile management, authentication, Java backend API

- **Skills**: Java, React, Firebase, Google OAuth, Hidden Markov Models


![home.png](/assets/assets/images/projects/airobic/home.png)


GitHub Repository: [https://github.com/gmilovac/AiRobic](https://github.com/gmilovac/AiRobic)

## Overview

AiRobic lets users create a computer-generated training plan based on their fitness goals. The user signs in with
Google, enters their weekly training hours, training mode (goal, variable, or linear), and a start and end date. The
app then generates a personalised schedule and saves it so the user can view their workouts on a calendar at any point
after logging in. In its current state the application generates indoor rowing workouts, but the design is intended to
be expandable to other sports in the future.

The team brought 20+ years of combined rowing experience to the project, which helped make sure the generated plans
were actually useful rather than just technically correct.

The front end is built with React and handles authentication through Google OAuth. The back end is written in Java and
manages API requests from the front end, stores user data in Firebase Realtime Database, and runs the workout
generation logic.

![plan.png](/assets/assets/images/projects/airobic/plan.jpg)

### Workout Generation

The workout generation is built around a Hidden Markov Model (HMM). The model has a set of hidden states, a transition
matrix, and an emission distribution for each state. The `MarkovModel` class runs through the model—starting in a state
and transitioning and emitting repeatedly—and loads the resulting list of workouts into whatever format is needed via
an `EmissionFormatter` interface.

![workout_generator.png](/assets/assets/images/projects/airobic/workout_generator.jpg)

### Data Management

User data is stored in Firebase Realtime Database. I built a class that generates the appropriate Firebase terminal
commands for each action—reading, writing, and updating user records formatted as JSON. Each API call from the front
end is handled by a dedicated class that translates the query into the corresponding database commands. The most complex
of these is `CreatePlan()`, which runs the HMM generation and then stores the resulting schedule in the database.

### Account Management

Authentication is handled through Google OAuth, which kept things secure without needing to store any sensitive
information like passwords on our end. After authenticating, the user's unique Google ID is used to store and retrieve
all their data in Firebase.
