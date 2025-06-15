#!/usr/bin/env bash
# exit on error
set -o errexit
. /home/shawn/.asdf/asdf.sh
. /home/shawn/.asdf/completions/asdf.bash
cd /home/shawn/dtn
git checkout .
git pull

mix local.hex --force
mix local.rebar --force

mix deps.get
MIX_ENV=prod mix compile

npm install --prefix ./assets
npm run deploy --prefix ./assets
mix phx.digest

MIX_ENV=prod mix release --overwrite

sudo service dtn restart