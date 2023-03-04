REGISTRY ?= laravel
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
		--cache-from "$(REGISTRY)/octane:$(IMAGE_TAG)" \
		--tag "$(REGISTRY)/octane:$(IMAGE_TAG)" \
		--target=base \
		--file=Dockerfile.octane \
		.
	
	@docker tag "$(REGISTRY)/octane:$(IMAGE_TAG)" "$(REGISTRY)/octane:latest"

build-octane-dev:
	@docker build \
		--cache-from "$(REGISTRY)/octane/dev:$(IMAGE_TAG)" \
		--tag "$(REGISTRY)/octane/dev:$(IMAGE_TAG)" \
		--target=dev \
		--file=Dockerfile.octane \
		.

	@docker tag "$(REGISTRY)/octane/dev:$(IMAGE_TAG)" "$(REGISTRY)/octane/dev:latest"

build-octane-composer:
	@docker build \
		--cache-from "$(REGISTRY)/octane/composer:$(IMAGE_TAG)" \
		--tag "$(REGISTRY)/octane/composer:$(IMAGE_TAG)" \
		--target=composer \
		--file=Dockerfile.octane \
		.

	@docker tag "$(REGISTRY)/octane/composer:$(IMAGE_TAG)" "$(REGISTRY)/octane/composer:latest"

build-nginx-fpm:
	@docker build \
		--cache-from "$(REGISTRY)/nginx-fpm:$(IMAGE_TAG)" \
		--tag "$(REGISTRY)/nginx-fpm:$(IMAGE_TAG)" \
		--target=base \
		--file=Dockerfile.nginx-fpm \
		.

	@docker tag "$(REGISTRY)/nginx-fpm:$(IMAGE_TAG)" "$(REGISTRY)/nginx-fpm:latest"

build-nginx-fpm-dev:
	@docker build \
		--cache-from "$(REGISTRY)/nginx-fpm/dev:$(IMAGE_TAG)" \
		--tag "$(REGISTRY)/nginx-fpm/dev:$(IMAGE_TAG)" \
		--target=dev \
		--file=Dockerfile.nginx-fpm \
		.

	@docker tag "$(REGISTRY)/nginx-fpm/dev:$(IMAGE_TAG)" "$(REGISTRY)/nginx-fpm/dev:latest"

build-nginx-fpm-composer:
	@docker build \
		--cache-from "$(REGISTRY)/nginx-fpm/composer:$(IMAGE_TAG)" \
		--tag "$(REGISTRY)/nginx-fpm/composer:$(IMAGE_TAG)" \
		--target=composer \
		--file=Dockerfile.nginx-fpm \
		.

	@docker tag "$(REGISTRY)/nginx-fpm/composer:$(IMAGE_TAG)" "$(REGISTRY)/nginx-fpm/composer:latest"

push:
	docker push "$(REGISTRY)/octane:$(IMAGE_TAG)"
	docker push "$(REGISTRY)/octane/dev:$(IMAGE_TAG)"
	docker push "$(REGISTRY)/octane/composer:$(IMAGE_TAG)"
	docker push "$(REGISTRY)/nginx-fpm:$(IMAGE_TAG)"
	docker push "$(REGISTRY)/nginx-fpm/dev:$(IMAGE_TAG)"
	docker push "$(REGISTRY)/nginx-fpm/composer:$(IMAGE_TAG)"

	docker push "$(REGISTRY)/octane:latest"
	docker push "$(REGISTRY)/octane/dev:latest"
	docker push "$(REGISTRY)/octane/composer:latest"
	docker push "$(REGISTRY)/nginx-fpm:latest"
	docker push "$(REGISTRY)/nginx-fpm/dev:latest"
	docker push "$(REGISTRY)/nginx-fpm/composer:latest"

