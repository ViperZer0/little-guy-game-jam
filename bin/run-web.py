import argparse
import os

from dotenv import load_dotenv
from utils import resolve_path, get_builds
from build import build as do_build
import http.server

def _run_web():
	# Get env
	env_builds = get_builds()

	# Get args
	parser = argparse.ArgumentParser()
	parser.add_argument('--rebuild', '-rb', action='store_true')

	args = parser.parse_args()

	do_rebuild = args.rebuild

	if 'web' not in env_builds:
		raise Exception('Unable to run web build: web build not available')

	if do_rebuild:
		do_build('web', True)

	run_web()


def run_web():
	# env = get_env()

	port = os.getenv('RUN_WEB_PORT')
	assert port != None
	port = int(port)
	web_dir = resolve_path(os.getenv('EXPORT_DIR'), 'web')

	# For some reason this doesn't work for me, it just starts a new Python shell?? Can we do this instead?
	# subprocess.run(command, capture_output=False, shell=True)

	# What the hell. You have to write a custom class just to handle a different directory lmao
	class Handler(http.server.SimpleHTTPRequestHandler):
		def __init__(self, *args, **kwargs):
			super().__init__(*args, **kwargs, directory = web_dir)

	with http.server.ThreadingHTTPServer(('', port), Handler) as server:
		server.serve_forever()

if __name__ == '__main__':
	load_dotenv()
	_run_web()
