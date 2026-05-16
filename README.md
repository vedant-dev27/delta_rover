# Delta Rover

A modular Flutter-based remote control application for a Raspberry Pi powered rover.

This project focuses on building a maintainable, scalable robotics control interface with clean architecture and reusable UI components.

---

# Features

## Device Management

* Add rover devices using IP address
* Persistent device storage using SharedPreferences
* Device list rendering
* Device selection and navigation

### Camera View

* PiCam integration
* Future on-device face recognition support

### Drive Controls

* Reusable directional buttons
* Future movement command integration

### Servo Controls

* Independent camera orientation controls
* Compact precision-oriented D-pad
* Future servo communication integration

### Sensor Panel

Placeholder telemetry dashboard for:

* DHT11 temperature/humidity
* Ultrasonic sensors
* PIR sensors
* MPU6050 accelerometer/gyro

---

# Project Structure

```text
lib/
├── models/
├── screens/
├── services/
└── widgets/
    ├── control/
    │   ├── camera/
    │   ├── drive/
    │   ├── sensors/
    │   └── servo/
    └── device/
```

---

# Architecture Philosophy

This project intentionally prioritizes:

* maintainability
* modularity
* separation of concerns
* incremental development

Instead of placing all logic inside a single screen file, every major control system is separated into reusable widgets and isolated responsibilities.

Example:

* UI widgets handle rendering and interaction
* services handle communication and storage
* models handle data structures

This structure makes debugging, scaling, and future feature additions significantly easier.

---

# Current Status

## Completed

* Device persistence
* Modular control screen
* Camera placeholder
* Drive controls UI
* Servo controls UI
* Sensor dashboard UI
* Navigation flow

## Planned

* FastAPI integration
* WebSocket communication
* Live camera streaming
* Real-time sensor updates
* Servo control logic
* Rover drive commands
* Face recognition pipeline
* Alert/buzzer system

---

# Tech Stack

* Flutter
* Dart
* SharedPreferences
* Raspberry Pi
* FastAPI
* PiCam
* TensorFlow Lite (planned)

---

# Goals

The goal of Delta Rover is not just to control a robot, but to build a scalable robotics control system with clean software architecture.

The project is being developed incrementally:

1. UI structure
2. Interaction flow
3. Persistence
4. Modularization
5. Networking
6. Real-time systems
7. ML integration

---

# License

This project is currently personal/experimental.
