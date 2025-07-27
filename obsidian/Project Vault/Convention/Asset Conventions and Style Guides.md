## External Assets
Assets that cannot be directly consumed by Godot are considered "External Assets". Generally, these should be kept in-repository, but not in the Godot project folder.

General convention is to keep these at the project root in an "asset" folder, which is further divided into asset type. Ultimately, the structure of this folder should be whatever works best for the asset designers.

If the asset folder is kept in-repo, ensure that git-lfs is properly configured to support all file types tracked by the repository.

External assets should aim to share a name with their exported internal counterparts, which means they should be named following the [[Godot Project Structure#Project File Naming Convention|standard file naming convention]].
## Internal Assets
Internal Assets are those that can be directly used by Godot. This includes many common image, audio, and plain-text file types. These should be kept in-engine as near as possible to the components that consume them.

These files should be named following the [[Godot Project Structure#Project File Naming Convention|standard file naming convention]].