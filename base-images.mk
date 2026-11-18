# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := ruby
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_3.3.13-alpine := sha256:9b88fb6e13745686b2e529f0559e869c303f6b965a94523c04671758dd132d9a
BASE_IMAGE_DIGEST_3.4.12-alpine := sha256:68d60620b4458fc58c1e1d04a79ee26b85564fdd5387f3071ae077e2c56ae766
BASE_IMAGE_DIGEST_4.0.9-alpine := sha256:921ad0cc0f6bf76ed48ed6847a4c55a928e920bc7a2f2697aed498942c50ea00

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
