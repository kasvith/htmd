#!/bin/bash

set -e

echo "Forcing a rebuild of project..."

HTMD_BUILD=true mix compile

echo "Downloading checksum files..."
mix rustler_precompiled.download Htmd.Native --all --print