# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.13-alpine := sha256:2fda53cb7c1c93618593afce7404e311b2b44b0eab35bfeace3981aa0be4ff54
BASE_IMAGE_DIGEST_3.4.12-alpine := sha256:a28982cf8ed78eb0d222e51bc6788335d33ef191bfc6fc39da138577e611741d
BASE_IMAGE_DIGEST_4.0.9-alpine := sha256:8ad6909db16ad53b5dc90bb8cc157e5fdd89ba1172798316b95cfd2a61f14b1e

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
