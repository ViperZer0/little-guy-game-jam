import argparse
import os
import subprocess
from dotenv import load_dotenv

from build import build as do_build

from utils import resolve_path, get_builds

def _publish() -> None:
	# Get env
	env_builds = get_builds()

	# Get args
	parser = argparse.ArgumentParser()
	parser.add_argument('builds', nargs='+')
	parser.add_argument('--rebuild', '-rb', action='store_true')
	parser.add_argument('--dry-run', '-dr', action='store_true')

	args = parser.parse_args()

	do_dry_run = args.dry_run
	do_rebuild = args.rebuild
	do_builds = args.builds

	if 'all' in do_builds:
		do_builds = env_builds

	for build in do_builds:
		if build in env_builds:
			if do_rebuild:
				do_build(build, True)

			print(f"attempting publish for build '{build}'...")
			publish(build, do_dry_run)
		else:
			print(f"Build '{build}' not recognized, skipping...")
			continue


def publish(build_name: str, dry_run = False) -> None:
	channel = f"{os.getenv('ITCH_USER')}/{os.getenv('ITCH_GAME_SLUG')}:{build_name}-stable"
	export_dir = resolve_path(os.getenv("EXPORT_DIR"))
	build_folder = os.path.join(export_dir, build_name)
	version_file = resolve_path(os.getenv("VERSION_FILE"))
	dry_run_arg = '--dry-run' if dry_run else ''

	command = [
		'butler',
		'push',
	]

	if (dry_run):
		command.append(dry_run_arg)

	command += [
		build_folder,
		channel,
		'--userversion-file',
		version_file
	]

	print(' '.join(command))
	subprocess.run(command, capture_output=False)

if __name__ == '__main__':
	load_dotenv()
	_publish()
