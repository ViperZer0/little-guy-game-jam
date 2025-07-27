import argparse
import os
import subprocess

from dotenv import load_dotenv
from utils import get_godot_console_exe, resolve_path, get_builds
from clean import clean

def _build():
	# Get env
	env_builds = get_builds()

	# Get args
	parser = argparse.ArgumentParser()
	parser.add_argument('build', nargs='+')
	parser.add_argument('--clean', '-c', action='store_true')

	args = parser.parse_args()

	arg_builds = args.build
	if 'all' in arg_builds:
		arg_builds = env_builds

	for arg_build in arg_builds:
		build(arg_build, args.clean)


def build(build_name: str, do_clean = False) -> None:
	env_builds = get_builds()

	if build_name not in env_builds:
		raise Exception(f"Build operation failed: build '{build_name}' not recognized")

	if do_clean:
		clean(build_name)

	project_dir = resolve_path(os.getenv("PROJECT_DIR"))
	export_dir = resolve_path(os.getenv("EXPORT_DIR"))
	output_file_name = os.getenv("OUTPUT_FILE")

	if build_name == 'web':
		output_file_name = 'index.html'

	output_dir = os.path.realpath(os.path.join(export_dir, build_name))
	output_file = os.path.realpath(os.path.join(export_dir, build_name, output_file_name))

	if os.path.isdir(output_dir) == False:
		print(f"Creating build directory for build '{build_name}' at {output_dir}")
		os.makedirs(output_dir)

	command = [
		f"{get_godot_console_exe()}",
		"--path",
		project_dir,
		"--headless",
		"--export-release",
		build_name,
		output_file
	]

	print(' '.join(command))
	subprocess.run(command, capture_output=False)

if __name__ == '__main__':
	load_dotenv()
	_build()
	print("Done")
