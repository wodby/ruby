# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.13-alpine := sha256:d33a40da6163631d03b560c797e44fa242b8727eb4a4062d8a645f2cdd69e659
BASE_IMAGE_DIGEST_3.4.12-alpine := sha256:53dd359160ceeb7963f8e9efea8a2bbbb65278276e024bb0f058261152b5610d
BASE_IMAGE_DIGEST_4.0.9-alpine := sha256:d0c5befc0864d31c6219321c8d79de2941d1bc31c41505d9c9289c6192c36d60

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
