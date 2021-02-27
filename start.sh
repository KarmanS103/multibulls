#!/bin/bash
# Attribution: Nat Tuck's Lecture 8 
# export MIX_ENV=prod
# export PORT=4801

CFGD=$(readlink -f ~/.config/multibulls)

# if [ ! -e "$CFGD/base" ]; then
#     echo "Need to deploy first"
#     exit 1
# fi

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

# _build/prod/rel/bulls/bin/bulls start


#!/bin/bash

# if [[ "x$PROD" == "x" ]]; then 
# 	echo "This script is for starting in production."
# 	echo "Use"
# 	echo "   mix phx.server"
# 	exit
# fi

# TODO: Enable this script by removing the above.

# export SECRET_KEY_BASE=W68eso5YQOlbtvSNUR50N/HDWj6IaEhAwMR3LtzuBEQAefwYVbX84bvoTA7XtiGi
export MIX_ENV=prod
export PORT=4802

echo "Stopping old copy of app, if any..."

_build/prod/rel/multibulls/bin/multibulls stop || true

echo "Starting app..."

_build/prod/rel/multibulls/bin/mutltibulls start

# TODO: Add a systemd service file
#       to start your app on system boot.
