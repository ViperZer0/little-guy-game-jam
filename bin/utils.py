import os
from pathlib import Path

def resolve_path(*destination):
	script_dir = os.path.dirname(os.path.realpath(__file__))
	return os.path.realpath(os.path.join(script_dir, *destination))

def get_builds():
	builds = []
	for build in os.getenv("BUILD_TARGETS").split(','):
		builds.append(build.strip())

	return builds

# Thrown when no valid executable for GODOT_EXE was found
class NoExecutableFound(Exception):
	pass

def get_godot_exe() -> Path:
	return get_file_from_env("GODOT_EXE")

def get_godot_console_exe() -> Path:
	return get_file_from_env("GODOT_CONSOLE_EXE")

def get_file_from_env(env_key: str) -> Path:
	# Opted to use ; as that's how Linux's PATH variable is parsed
	locations = os.getenv(env_key)
	assert locations != None

	for location in locations.split(";"):
		# pathlib recommends using forward slashes with all types of paths,
		# i.e c:/Windows, but it should work either way?
		# Expand user allows me to use ~ for home directory, dunno if it does anything
		# in windows.
		path = Path(location).expanduser()
		if path.is_file():
			return path

	raise NoExecutableFound()


