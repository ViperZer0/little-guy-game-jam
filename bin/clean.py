import argparse
import os
import glob

from dotenv import load_dotenv

from utils import resolve_path, get_builds

def _clean() -> None:
	# Get env
	env_builds = get_builds()

	# Get args
	parser = argparse.ArgumentParser()
	parser.add_argument('build', nargs='+')

	args = parser.parse_args()

	clean_builds = args.build
	if 'all' in clean_builds:
		clean_builds = env_builds

	for clean_build in clean_builds:
		clean(clean_build)


def clean(build: str) -> None:
	# env = get_env()
	builds = get_builds()

	if build not in builds:
		raise Exception(f"Clean operation failed: build '{build}' not recognized")

	clean_dir = resolve_path(os.getenv("EXPORT_DIR"), build)
	if os.path.isdir(clean_dir) == False:
		print(f"Unable to find build directory '{clean_dir}'. Skipping clean operation for build '{build}'...")
		return

	print(f"Removing build files for build '{build}' in dir '{clean_dir}'...")

	clean_files = glob.glob(f"{clean_dir}/*")
	for clean_file in clean_files:
		os.remove(clean_file)

	print(f"Clean operation for build '{build}' complete!")

if __name__ == '__main__':
	load_dotenv()
	_clean()
