-include env_make

RUBY_VER ?= 3.4.7
RUBY_VER_MINOR := $(shell v='$(RUBY_VER)'; echo "$${v%.*}")

REPO = wodby/ruby
NAME = ruby-$(RUBY_VER_MINOR)

PLATFORM ?= linux/arm64

ifeq ($(WODBY_USER_ID),)
    WODBY_USER_ID := 1000
endif

ifeq ($(WODBY_GROUP_ID),)
    WODBY_GROUP_ID := 1000
endif

ifeq ($(TAG),)
	ifneq ($(RUBY_DEV),)
		ifeq ($(WODBY_USER_ID),501)
			TAG := $(RUBY_VER_MINOR)-dev-macos
			NAME := $(NAME)-dev-macos
		else
			TAG := $(RUBY_VER_MINOR)-dev
			NAME := $(NAME)-dev
		endif
	else
		TAG := $(RUBY_VER_MINOR)
	endif
endif

IMAGETOOLS_TAG ?= $(TAG)

ifneq ($(ARCH),)
	override TAG := $(TAG)-$(ARCH)
endif

.PHONY: build buildx-build buildx-push test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg RUBY_VER=$(RUBY_VER) \
		--build-arg RUBY_DEV=$(RUBY_DEV) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
		--build-arg RUBY_VER=$(RUBY_VER) \
		--build-arg RUBY_DEV=$(RUBY_DEV) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		--load \
		./

buildx-push:
	docker buildx build --platform $(PLATFORM) --push -t $(REPO):$(TAG) \
		--build-arg RUBY_VER=$(RUBY_VER) \
		--build-arg RUBY_DEV=$(RUBY_DEV) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		./

buildx-imagetools-create:
	docker buildx imagetools create -t $(REPO):$(IMAGETOOLS_TAG) \
				  $(REPO):$(TAG)-amd64 \
				  $(REPO):$(TAG)-arm64
.PHONY: buildx-imagetools-create 

test:
ifneq ($(RUBY_DEV),)
	cd ./tests && RUBY_IMAGE=$(REPO):$(TAG) ./run.sh
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
ifneq ($(RUBY_DEV),)
	cd ./tests && RUBY_IMAGE=$(REPO):$(TAG) docker compose down -v
endif
	-docker rm -f $(NAME)

release: build push
