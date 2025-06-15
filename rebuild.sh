#!/usr/bin/env bash
# exit on error
set -o errexit
cd /home/shawn/dtn
git checkout .
git pull


mix deps.get
MIX_ENV=prod mix compile

mix phx.digest

MIX_ENV=prod mix release --overwrite

sudo service dtn restart