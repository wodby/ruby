# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.13-alpine := sha256:fee49593bed1f98411e8dd556b72fbf4320c46101665ceeeac172417d4981bb1
BASE_IMAGE_DIGEST_3.4.12-alpine := sha256:6e0f1d1f4ea9cf824b7af56bd9bc838fac9333fb258492c7aa3e3df8959ec64c
BASE_IMAGE_DIGEST_4.0.9-alpine := sha256:f1e530793cc09e1093417a4c9956069407155e1883d02beb30bda35ae54a47a3

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
