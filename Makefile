-include env_make

RUBY_VER ?= 3.0.0
RUBY_VER_MINOR := $(shell v='$(RUBY_VER)'; echo "$${v%.*}")

BASE_IMAGE_TAG = $(RUBY_VER)-alpine

REPO = wodby/ruby
NAME = ruby-$(RUBY_VER_MINOR)

PLATFORM ?= linux/amd64

ifeq ($(WODBY_USER_ID),)
    WODBY_USER_ID := 1000
endif

ifeq ($(WODBY_GROUP_ID),)
    WODBY_GROUP_ID := 1000
endif

ifeq ($(TAG),)
    ifneq ($(RUBY_DEV),)
    	TAG ?= $(RUBY_VER_MINOR)-dev
    else
        TAG ?= $(RUBY_VER_MINOR)
    endif
endif

ifneq ($(RUBY_DEV),)
    NAME := $(NAME)-dev
endif

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build buildx-build buildx-build-amd64 buildx-push test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg RUBY_DEV=$(RUBY_DEV) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		./

# --load doesn't work with multiple platforms https://github.com/docker/buildx/issues/59
# we need to save cache to run tests first.
buildx-build-amd64:
	docker build --platform linux/amd64 -t $(REPO):$(TAG) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg RUBY_DEV=$(RUBY_DEV) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		--cache-from "type=local,src=/tmp/.buildx-cache" \
		--cache-to "type=local,dest=/tmp/.buildx-cache" \
		--load \
		./

buildx-build:
	docker build --platform $(PLATFORM) -t $(REPO):$(TAG) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg RUBY_DEV=$(RUBY_DEV) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		./

buildx-push:
	docker build --platform $(PLATFORM) --push -t $(REPO):$(TAG) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg RUBY_DEV=$(RUBY_DEV) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		./

test:
ifneq ($(RUBY_DEV),)
	cd ./tests && RUBY_TAG=$(TAG) ./run.sh
else
	@echo "We run tests only for DEV images."
endif

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push
