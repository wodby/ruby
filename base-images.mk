# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.12-alpine := sha256:ac11166d133f476b0c3b4ae6fa6c6301cfc9a6f4e03c0761c482f00808c96cad
BASE_IMAGE_DIGEST_3.4.11-alpine := sha256:aa205a3ebbf558c304cd135c197af8e80cf6c26193ec4b5862763562f1c38426
BASE_IMAGE_DIGEST_4.0.9-alpine := sha256:d0c5befc0864d31c6219321c8d79de2941d1bc31c41505d9c9289c6192c36d60

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
