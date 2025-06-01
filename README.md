# zig-sandbox

This repository serves as a personal "sandbox" for learning the Zig programming language.

## Goals

* To learn the syntax and core concepts of Zig.
* To practice writing code in Zig: from small snippets to mini-projects.
* To master Zig's build system (`build.zig`).
* To explore Zig's standard library.
* To experiment with comptime, error handling, concurrency, and other advanced features.

## Repository Structure

The repository is organized as follows:

* **`build.zig`**: The root Zig build system file.
* **`projects/`**: For small standalone projects and applications written in Zig.
* **`snippets/`**: A place for very small code fragments, quick tests, or useful one-off utilities.

## Building and Running

All examples and projects in this repository are compiled using the root `build.zig` file.

### Build

* **Build all artifacts**:
    ```bash
    zig build
    ```
    or
    ```bash
    zig build default
    ```
    Compiled executables will be placed in the `zig-out/bin/` directory.

