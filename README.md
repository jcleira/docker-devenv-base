# Dockerized Base development environment
![Docker logo](https://www.docker.com/sites/default/files/horizontal_large.png)

This repository contains a base docker development environment, It is customized using my dotfiles.

Usage:

```bash
docker run -t -i -v /home/<user>/.ssh:/home/dev/.ssh -v /home/<user>/.ssh:/home/dev/.ssh -v /home/<user>/Code:/home/dev/Code --net=host jcorral/docker-devenv-base
```
