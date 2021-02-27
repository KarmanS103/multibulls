#!/bin/bash
# This is deploy.sh
# Attribution: Nat Tuck's Lecture 8

# export MIX_ENV=prod
# export PORT=4801
export SECRET_KEY_BASE=insecure

# mix deps.get --only prod
# mix compile

CFGD=$(readlink -f ~/.config/multibulls)

if [ ! -d "$CFGD" ]; then
    mkdir -p $CFGD
fi

if [ ! -e "$CFGD/base" ]; then
    mix phx.gen.secret > "$CFGD/base"
fi

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

# npm install --prefix ./assets
# npm run deploy --prefix ./assets
# mix phx.digest

# mix release

# PROD=t ./start.sh

export MIX_ENV=prod
export PORT=4802
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

echo "Generating release..."
mix release

#echo "Stopping old copy of app, if any..."
#_build/prod/rel/practice/bin/practice stop || true

echo "Starting app..."

PROD=t ./start.sh