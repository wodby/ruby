-include env_make

RUBY_VER ?= 2.6.4
RUBY_VER_MINOR := $(shell v='$(RUBY_VER)'; echo "$${v%.*}")

BASE_IMAGE_TAG = $(RUBY_VER)-alpine

REPO = wodby/ruby
NAME = ruby-$(RUBY_VER_MINOR)

WODBY_USER_ID ?= 1000
WODBY_GROUP_ID ?= 1000

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

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
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
