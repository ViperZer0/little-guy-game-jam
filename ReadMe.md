# SmolHaus Games Template Repository for Godot Projects
This repository contains a Github Template Repository containing all required files for a Godot game project.

## About This Template

### Repository Structure
- **asset***: Contains media asset files that cannot be consumed directly by Godot, such as `.ase` files.
- **bin**: Contains scripts to build, run, and publish the game project
- **export***: Contains the exported game project builds. This folder is excluded from git tracking, but is created by the build scripts and may or may not be present in your local copy of the repository.
- **godot**: Contains the Godot project
- **obsidian**: Contains the Obsidian Vault, which in turn contains design and architecture documentation, including the Game Design Document

\* - these folders are empty by default, and may not be present in the template repository

### Build, Run, and Publish Scripts
This template contains a `bin` directory which holds a number of python scripts to assist in building and publishing the Godot project to itch.io.

To use these scripts, replace the placeholder variables in `bin/.env` with the appropriate values for your system and configuration. Once this file has been configured, the scripts can be used as described in the table below:

|Command|Desription|
|---|---|
|`py bin/build.py [-c --clean] [builds]`|Build and export listed project builds.Exported builds will be placed in `{EXPORT_DIR}/{build}`. Use `-c` or `--clean` flags to clear build directory before exporting a new build. Use `all` for `builds` arg to build all targets in `BUILD_TARGETS`.|
|`py bin/clean.py [builds]`|Clean export directories for listed builds. Use `all` for `builds` arg to clean all export directories for all build targets.|
|`py bin/publish.py [-rb --rebuild] [-dr --dry-run] [builds]`|Publish builds to itch.io. Use `-rb` or `--rebuild` flag to clean and build the target before publishing. Use `-dr` or `--dr` flag to do a dry run. Use `all` for `builds` arg to publish all build targets|
|`py bin/run-web.py [-rb --rebuild]`|Start a local web server and serve the game project at `localhost:{RUN_WEB_PORT}`. Use `-rb` or `--rebuild` flags to clean and build the project before serving. This command only works if your project has a web build target.|

## Using This Template
See [this article](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) to learn how to use this template repository