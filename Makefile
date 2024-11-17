.PHONY : build
build:
	docker build -t ros-dev-container .

.PHONY : run
run:
	xhost +
	docker run -it --rm --name ros-dev-container\
		--network host \
		--env="DISPLAY" --env="QT_X11_NO_MITSHM=1" \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--mount type=bind,source=$(CURDIR)/workspace,target=/workspace \
		ros-dev-container

.PHONY : attach
attach:
	docker exec -it ros-dev-container /bin/bash

.PHONY : stop
stop:
	docker stop ros-dev-container && docker rm ros-dev-container
