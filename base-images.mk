# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.14-alpine := sha256:89283c9290e3df03fb6f2e78687635a892bf8f0bff474bb1026408078df5a279
BASE_IMAGE_DIGEST_3.4.13-alpine := sha256:9010b7942739e483ab8e359eae1190ea10af21cf7476daa41ece6f896dc8e02a
BASE_IMAGE_DIGEST_4.0.10-alpine := sha256:da0116fbea65c7c2f0c9d1c2d4e1e6932df1e9282683d9c4d7123f29323a2c67

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
