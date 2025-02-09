# P12 - Réaliser une application libre - NextRace

## Description

NextRace is an iOS application for motorsport races. It allows the user to look up the upcoming races in the world for three main championships : 
- Nascar
- Formula
- Monster Trucks

## Screens

<img width="1790" alt="Capture d’écran 2025-02-09 à 14 57 31" src="https://github.com/user-attachments/assets/efad0bee-3337-4ccb-8da5-ae7fe99213f2" />

## Functions

1. Select a championship and search for the next races in the world.
2. Display races in date-ascending order with lazy-loading to load more races.
3. Display a race detail screen with race location, date, price, track, and seatmap
4. Add a race event to your personal iPhone calendar
5. Persist a race in database and add it to your favorite tab.

The application localized in english and french.

## Main tools

SwiftUI is used for UI.

MVVM is the main architecture.

CoreData is used to persist races in data base.

Github Action is used to provide a workflow for building, testing and linting on every merge to main.

Google Firebase Analytics and Crashlytics is used to track events.

KingFisher is is used for image caching.

XCTests is used for Unit Testing.
