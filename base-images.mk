# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.13-alpine := sha256:ce78bd5ecc05aac0046e46d33d321b0a71f73f1e6b07345669f8bad21d4313a8
BASE_IMAGE_DIGEST_3.4.12-alpine := sha256:292b1978a036d8e608b3e4075f2f056188fb692345eb0472721c0663bfff6265
BASE_IMAGE_DIGEST_4.0.9-alpine := sha256:de35e3da5f149b2eb01f54a67f70061da1f25b66c8d3db176fde2d18f34da5a7

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
