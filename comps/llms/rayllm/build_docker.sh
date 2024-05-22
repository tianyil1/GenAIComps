#!/bin/bash

# Copyright (c) 2024 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set default values
default_hw_mode="hpu"

# Assign arguments to variables
hw_mode=${1:-$default_hw_mode}

# check if hw_mode is provided
if [ "$#" -lt 0 ] || [ "$#" -gt 1 ]; then
    echo "Usage: $0 [hw_mode]"
    echo "Please customize the arguments you want to use.
    - hw_mode: The hardware mode for the Ray Gaudi endpoint, with the default being "hpu", and the optional selection can be 'cpu' and 'hpu'."
    exit 1
fi

cd docker

# Build the Docker image for Ray based on the hardware mode
if [ "$hw_mode" == "hpu" ]; then
    docker build \
        -f Dockerfile.habana ../../ \
        -t rayllm:habana \
        --network=host \
        --build-arg http_proxy=${http_proxy} \
        --build-arg https_proxy=${https_proxy} \
        --build-arg no_proxy=${no_proxy}
else
    docker build \
        -f Dockerfile.cpu ../../ \
        -t rayllm:cpu \
        --network=host \
        --build-arg http_proxy=${http_proxy} \
        --build-arg https_proxy=${https_proxy} \
        --build-arg no_proxy=${no_proxy}
fi
