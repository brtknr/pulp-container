pio:
	docker run --detach \
	           --publish 8080:80 \
	           --name pulp \
		   --rm \
	           --volume "$(shell pwd)/settings":/etc/pulp \
	           --volume "$(shell pwd)/pulp_storage":/var/lib/pulp \
	           --volume "$(shell pwd)/pgsql":/var/lib/pgsql \
	           --volume "$(shell pwd)/containers":/var/lib/containers \
	           --device /dev/fuse \
	           pulp/pulp

password:
	docker exec -it pulp bash -c 'pulpcore-manager reset-admin-password'

init:
	virtualenv venv
	. venv/bin/activate
	pip install -r requirements.txt
	pulp config create
