#!/bin/bash

# warnings
export WARN_IMAGES_FILE="WARN: The images file is not found."

# errors
export ERR_INVALID_PARAMS="ERR: Invalid parameters number."
export ERR_BAD_OPTION="ERR: Bad option"
export ERR_DOCKER="ERR: Docker is required."
export ERR_K8S_VERSION="ERR: The Kubernetes version is unsupprt."
export ERR_MIRROR_FILE="ERR: The mirrors file is not found."

# help
export INFO_HELP="Load Kubernetes images
Usage: ./load_images.sh [core|dashboard|-d|-h]

Options:
-d: Debug mode (echo commands).
-h: Print help information.
core: Load the images of Kubernetes core components.
dashboard: Load the images of Kubernetes dashboard.

Path variable:
GCR_MIRROR: The mirror url of gcr.io
QUAY_MIRROR: The mirror url of quay.io"
