REGISTRY ?= myagmarsurensedjav/laravel-docker
IMAGE_TAG ?= latest

build:
	make build-octane
	make build-octane-dev
	make build-octane-composer
	make build-nginx-fpm
	make build-nginx-fpm-dev
	make build-nginx-fpm-composer

build-octane:
	@docker build \
		--cache-from "$(REGISTRY):octane-$(IMAGE_TAG)" \
		--tag "$(REGISTRY):octane-$(IMAGE_TAG)" \
		--target=base \
		--file=Dockerfile.octane \
		.

build-octane-dev:
	@docker build \
		--cache-from "$(REGISTRY):octane-dev-$(IMAGE_TAG)" \
		--tag "$(REGISTRY):octane-dev-$(IMAGE_TAG)" \
		--target=dev \
		--file=Dockerfile.octane \
		.

build-octane-composer:
	@docker build \
		--cache-from "$(REGISTRY):octane-composer-$(IMAGE_TAG)" \
		--tag "$(REGISTRY):octane-composer-$(IMAGE_TAG)" \
		--target=composer \
		--file=Dockerfile.octane \
		.

build-nginx-fpm:
	@docker build \
		--cache-from "$(REGISTRY):nginx-fpm-$(IMAGE_TAG)" \
		--tag "$(REGISTRY):nginx-fpm-$(IMAGE_TAG)" \
		--target=base \
		--file=Dockerfile.nginx-fpm \
		.

build-nginx-fpm-dev:
	@docker build \
		--cache-from "$(REGISTRY):nginx-fpm-dev-$(IMAGE_TAG)" \
		--tag "$(REGISTRY):nginx-fpm-dev-$(IMAGE_TAG)" \
		--target=dev \
		--file=Dockerfile.nginx-fpm \
		.

build-nginx-fpm-composer:
	@docker build \
		--cache-from "$(REGISTRY):nginx-fpm-composer-$(IMAGE_TAG)" \
		--tag "$(REGISTRY):nginx-fpm-composer-$(IMAGE_TAG)" \
		--target=composer \
		--file=Dockerfile.nginx-fpm \
		.

push:
	docker push "$(REGISTRY):octane-$(IMAGE_TAG)"
	docker push "$(REGISTRY):octane-dev-$(IMAGE_TAG)"
	docker push "$(REGISTRY):octane-composer-$(IMAGE_TAG)"
	docker push "$(REGISTRY):nginx-fpm-$(IMAGE_TAG)"
	docker push "$(REGISTRY):nginx-fpm-dev-$(IMAGE_TAG)"
	docker push "$(REGISTRY):nginx-fpm-composer-$(IMAGE_TAG)"

