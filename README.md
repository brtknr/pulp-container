# Pulp Container Registry

This repository contains some basic docs on how to operate `pulp container`.

Setup [pulp-in-one-container](https://pulpproject.org/pulp-in-one-container/):

    make aio

Reset admin password inside the container:

    make password

Environment initialisation:

    make init

This should create a config file under `~/.config/pulp/cli.toml` which content similar to this:

    [cli]
    base_url = "http://localhost:8080"
    username = "admin"
    password = "topsecret"
    cert = ""
    key = ""
    verify_ssl = true
    format = "json"
    dry_run = false
    timeout = 0

Set some environment variables to start off:

     URL=https://registry-1.docker.io
     UPSTREAM=library
     NAME=hello-world

Create a remote:

     pulp container remote create --name $NAME --url $URL --upstream-name $UPSTREAM/$NAME

Create a local repository and sync with remote:

     pulp container repository create --name $NAME --remote $NAME
     pulp container repository sync --name $NAME # --remote $NAME (optional if you want to use a non-default remote)

You can inspect the available versions of an image by doing:

     pulp container repository version list --repository $NAME

Now you can grab the tags available for a given version as follows (omit --version parameter to grab the latest version):

     pulp show --href `pulp container repository version show --repository $NAME --version 1 | jq '.content_summary.present."container.tag".href' -r`

This creates a distribution which can be pulled:

     pulp container distribution create --name $NAME --base-path $NAME --repository $NAME

Now you can pull the image:

     docker login localhost:8080 # use your setup credentials
     docker pull localhost:8080/$NAME:latest

Now try an example by setting the following variables:

     URL=https://ghcr.io
     UPSTREAM=stackhpc
     NAME=flannel-cni

Other useful resources:
- [Pulp Container Rest API reference](https://docs.pulpproject.org/pulp_container/restapi.html)
- [Pulp admin client for managing user and access control](https://docs.pulpproject.org/en/2.21/user-guide/admin-client/index.html)
