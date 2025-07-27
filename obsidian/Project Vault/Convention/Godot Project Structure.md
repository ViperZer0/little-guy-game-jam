## Structure Summary
### The Goal
The purpose of this project structure is to lean into the idea of "significant proximity", meaning that the artifacts that are most relevant to each other are the nearest together in the project structure. This helps contributors focus on single game components and view them as a whole, rather than as a collection of completely separate assets.
### Project Structure Example (Simple)
```txt
res://
	addon
	component
		auto
			bgm_player
				BGMPlayer.cs
				bgm_player.tscn
		player
			Player.cs
			player.tscn
			player_sprites.png
	data
		weapons.xml
	editor
	resource
		audio
			title.ogg
		font
			font.ttf
		img
			icon.svg
		theme
			default_theme.tres
	scene
		main
			main.tscn
	src
		Extensions.cs
		Enums.cs
```

The above illustrates a simplified project structure. We'll describe the contents of the root `res://` directory here
* `addon`
	* Contains third-party resources that should be tracked within the project structure, but separated from first-party resources
* `component`
	* Contains [[Project Glossary#Component|Components]] that are common to the entire project, meaning they are used in multiple [[Project Glossary#Scene|Scenes]].
	* Component folders can contain their own `component`, `resource`, and `src` sub-folders if they require relevant resources that are unique to them.
	* `component/auto`
		* Contains components that are auto-loaded by Godot and present in every scene.
		* Component sub-folders can contain their own `component`, `resource`, and `src` sub-folders if they require relevant resources that are unique to them.
* `data`
	* Contains plain-text data files that are common to the entire project.
* `editor`
	* Contains assets that are only used by the Godot editor, such as custom node icons
* `resource`
	* Contains [[Project Glossary#Resource|Resources]] that are common to the entire project, meaning they are used in multiple Scenes or Components.
	* Resources are generally divided into sub-folders depending on what type of resource they represent, such as an image or sound.
* `scene`
	* Contains the top-level [[Project Glossary#Scene|Scenes]] of the game, usually at least a `title` scene to contain the front menu, and a `main` scene to contain the main gameplay scene of the game.
	* Scene folders can contain their own `component`, `resource`, and `src` sub-folders if they require relevant resources that are unique to them.
	* Scene folders can also contain sub-scenes in a `scene` sub-folder for sub-scenes that are unique to that scene. One common example of this is a pause menu scene beneath the main scene.
* `src`
	* Contains pure-code files that are common to the entire project. Common items are an `Extensions.cs` file that contains C# extension methods useful for the project, and an `Enums.cs` which contains global enumerator definitions that are used throughout the code of the project.

### A More Complex Example: Player Component Folder
Here we'll explore a more complicated project where the player controls a tank that is made up of a number of sub-components. We'll say the other sub-folders aren't expanded to make the illustration a bit clearer:

```txt
res://
	addon
	component
		auto
		player
			component
				body
					Body.cs
					body.tscn
				tread
					Tread.cs
					tread.tscn
				turret
					Turret.cs
					turret.tscn
			resource
				audio
					pickup.wav
					tank_explode.wav
				img
					tank_sprites.png
			Player.cs
			player.tscn
	data
	editor
	resource
	scene
	src
```

The above example illustrates a component with sub-folders for other components that are unique to that component. It also illustrates a resource folder with some audio files and a single `tank_sprites.png` file which contains images for separate tank bodies, treads, and turrets. Here are the details as to why it is laid out this way:
* The `player` component is made up of three distinct sub-components, a `body`, a `tread`, and a `turret`.
* The `player` component also needs behavior to contain, coordinate, and control these three sub-components simultaneously, so we have a `player.tscn` component to group these sub-components other.
* The `player` component requires its own intelligent behavior to coordinate the sub components in response to player input, so we have a `Player.cs` script directly in the `player` component folder.
* Each of the three sub-components are their own collection of Godot nodes, so we save them as `.tscn` files. They also have their own special behaviors, which we define in their respective `.cs` files.
* Even though the three sub-components are separate, their sprites come from a _common resource_, so we keep that resource in a `resource` folder at the nearest shared parent folder, which in this case is the `player` folder.
* The `pickup.wav` and `tank_explode.wav` audio files are conceptually related to the player as a whole and not a single sub-component, so we keep those in a `resource` folder under the `player` folder.

## Folder-Specific Conventions
* All autoload components should be placed in `/component/auto`
* `/scene` should only contain folders which contain scenes. That is to say, `/scene` should generally not contain `resource`, `component`, or other "shared" folders. Components, resources, data, etc that are shared between Scenes should be located in their top-level counterpart folders.

## Project File Naming Convention
Files and folders within the Godot project directory should be named to the following conventions:
* Folders should be named in snake_case, and folder names should be singular -- e.g. `level` instead of `levels`
* C# code files should be named in PascalCase
* All other files should be named in snake_case
* Resource files should have the type of resource in their name, e.g. `default_theme.tres` for a Theme.
## Advantages
* Keeps relevant assets close to the game components that use them.
	* This makes finding relevant files easy when working on specific game components.
* Keeps individual folders small, and ensures folders contain only content that is relevant to a single component
* Helps separate collaborators across the file system, which can help with source/version control changes.
* Makes filter/search based file navigation more powerful
* Scales well as a project grows in complexity
* Helps encourage good component design by spatially isolating them from unrelated components
## Disadvantages
* Can make finding specific files difficult, especially for files that are shared across a few components, but not globally.
* Increases the individual amount of folders, which can make the entire filesystem appear more dense. I.e., increases the overall "depth" of the filesystem.
	* This can make the filesystem harder to visually navigate, as it makes it take up more horizontal space in typical file explorer views.
* Requires extra thought about asset organization when importing assets into the game.
* May prompt mid-development file reorganization as components begin to borrow resources from one-another