"""Use the installed Apple validator, with existing runner-only API credentials."""
from pathlib import Path
import os
import subprocess
import sys

ipas = list(Path(sys.argv[1]).glob('*.ipa'))
if len(ipas) != 1:
    raise ValueError('Expected one ephemeral IPA')
help_result = subprocess.run(['xcrun', 'altool', '--help'], capture_output=True)
help_text = (help_result.stdout + help_result.stderr).decode(errors='replace')
required_options = ['--validate-app', '--apiKey', '--apiIssuer', '--output-format']
if not all(option in help_text for option in required_options):
    print('EBOOK_APPLE_VALIDATOR_OPTIONS_UNAVAILABLE')
    sys.exit(2)
result = subprocess.run([
    'xcrun', 'altool', '--validate-app', '--file', str(ipas[0]), '--type', 'ios',
    '--apiKey', os.environ['APP_STORE_CONNECT_KEY_ID'],
    '--apiIssuer', os.environ['APP_STORE_CONNECT_ISSUER_ID'], '--output-format', 'json',
], capture_output=True)
# This process output is redirected to the private, deleted export log by the bridge.
sys.stdout.buffer.write(result.stdout)
sys.stderr.buffer.write(result.stderr)
sys.exit(result.returncode)
