#!/usr/bin/env bash
set -x

# This file is subject to the terms and conditions defined in file 'LICENSE',
# which is part of this repository.
#
# DO NOT EDIT THIS FILE BY HAND -- FILE IS SYNCHRONIZED REGULARLY

# Available environment variables
#
# BUILD_OPTS
# REPOSITORY
# VERSIONS

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
REPOSITORY=${REPOSITORY:-betacloud/serverspec}

# https://github.com/jenkinsci/docker/blob/master/update-official-library.sh
version-from-dockerfile() {
    grep VERSION: Dockerfile | sed -e 's/.*:-\(.*\)}/\1/'
}

# https://github.com/jenkinsci/docker/blob/master/publish.sh
get-published-versions() {
    local regex="[0-9\.]+[a-z\-]*"
    curl -q -fsSL https://registry.hub.docker.com/v1/repositories/$REPOSITORY/tags | egrep -o "\"name\": \"${regex}\"" | egrep -o "${regex}"
}

if [[ -z $VERSIONS ]]; then
    VERSIONS=$(get-published-versions)
fi

if [[ -z $VERSIONS ]]; then
    VERSIONS=$(version-from-dockerfile)
fi

for version in $VERSIONS; do
    docker build \
        --build-arg "VERSION=$version" \
        --tag "$REPOSITORY:$version" \
        $BUID_OPTS .

    docker push "$REPOSITORY:$version"
    docker rmi "$REPOSITORY:$version"
done
