# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.12-alpine := sha256:e9a716347e21361a3ba30bec15e15b89540b64b6ad2121e23220985f2b5bc72a
BASE_IMAGE_DIGEST_3.4.11-alpine := sha256:964cc9931ae515b7b4e0822f6d88e0c5e33a92033a024b242f52a0c08dd1c4cb
BASE_IMAGE_DIGEST_4.0.7-alpine := sha256:280685cbe09c904c386a77ea0b5097eddcf0121504340243f01dadaf51d00801

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
