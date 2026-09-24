# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.12-alpine := sha256:d9e5298c8c7dad54b40facac94be1baa10f593db7dec7a9afb47bd44a64c15a9
BASE_IMAGE_DIGEST_3.4.11-alpine := sha256:ae2f369670fbf93cc819f299d56af471db6e2223f05268a04fa3fa8b21d8fb65
BASE_IMAGE_DIGEST_4.0.7-alpine := sha256:1ca7cb33e970630d571e0da6140e0bc925faec8f1f8f51f9f2cdf5e5f5eed7c9

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
