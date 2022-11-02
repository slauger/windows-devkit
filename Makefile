IMAGE_NAME=quay.io/slauger/windows-devkit

all: build push

build:
	docker build -t $(IMAGE_NAME) .

push:
	docker push $(IMAGE_NAME)
