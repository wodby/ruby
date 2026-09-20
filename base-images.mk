# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.12-alpine := sha256:c7c6f03932ed67976a1fe4de7d00d8371dee205ea8b954735850fdbeced26576
BASE_IMAGE_DIGEST_3.4.10-alpine := sha256:62e32b2d23d1ebd2acb22ec2f67f9ed2d67499082403d390b14bf83189da419c
BASE_IMAGE_DIGEST_4.0.7-alpine := sha256:79bf10b28c9d98b7b3cffda01aba8190aa1c1c48513d205ec93372a0e2f010e3

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
