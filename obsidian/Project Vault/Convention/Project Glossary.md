In this document, we will record the local project nomenclature that will be used to describe the game's concepts and components. This should guide the naming of assets, code references, and other artifacts.
## Artifact
"Artifact" is a generic term in software design and development for an individual object that contributes to the design or function of the game, be it an asset file, a script, or even a note document such as this one. When talking about artifacts, we are usually talking about some kind of file that contributes to the project in some way.
## Component
A Component is generally a collection of Godot nodes, scripts, and assets that work together to represent a single in-game feature, such as the player, an interactable object, or a UI element. It can also refer to a single pure-code system that is defined outside of the Godot editor such as a custom file manager or networking system.

Components work together in collections to create [[#Scene|Scenes]] 
## Resource
A resource is an asset that can be directly used by the Godot engine, either in its native format or as a `.res` or `.tres` import of an external asset.
## Scene
What we call a "scene" at the project level is different than what Godot calls a "scene". Godot simply refers to a collection of nodes as a scene, while we have a more specific definition:

A scene is a collection of [[#Component|Components]] that work together to create a single "screen" of the game which the player interacts with. A Scene should be a complete and independent tool or experience that includes every component it needs to satisfy its purpose.

Most projects will include, at minimum, a `title` scene which includes the main menu, and a `main` scene which contains the main gameplay interface.
