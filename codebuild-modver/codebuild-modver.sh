#!/bin/bash

# modver
#
# Copyright 2019 Brendon Matheson, All rights reserved.
#
# Offered for use under the terms of the MIT license.  See LICENSE for details

if [[ -z ${VERSION_MAJOR} ]]; then
        echo "VERSION_MAJOR is not set"
        exit 1
fi

if [[ -z ${VERSION_MINOR} ]]; then
        echo "VERSION_MINOR is not set"
        exit 1
fi

if [[ -z ${VERSION_BUILDNUMBER_PARAM} ]]; then
        echo "VERSION_BUILDNUMBER_PARAM is not set"
        exit 1
fi

VERSION_REVISION=$(git rev-list HEAD --count)

# Get and increment the build number
echo "Retrieving current build number from SSM parameter ${VERSION_BUILDNUMBER_PARAM}"
VERSION_BUILDNUMBER=$(aws ssm get-parameter --name "${VERSION_BUILDNUMBER_PARAM}" | jq -r ".Parameter.Value")

aws ssm put-parameter \
        --name "${VERSION_BUILDNUMBER_PARAM}" \
        --value "$((VERSION_BUILDNUMBER+1))" \
        --type "String" \
        --overwrite > /dev/null

# Construct full version
VERSION_FULL="$VERSION_MAJOR.$VERSION_MINOR.$VERSION_REVISION.$VERSION_BUILDNUMBER"

echo VERSION_MAJOR: ${VERSION_MAJOR}
echo VERSION_MINOR: ${VERSION_MINOR}
echo VERSION_REVISION: ${VERSION_MINOR}
echo VERSION_BUILDNUMBER: ${VERSION_BUILDNUMBER}
echo VERSION_FULL: ${VERSION_FULL}

