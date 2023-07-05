# openasarctl
## a simple bash script to manage your openasar installation

### usage
```
$ openasar.sh -h
usage: /home/kenzie/.local/bin/openasar <action> <branch>
actions:
	install   - install openasar for given branch
	uninstall - uninstall openasar for given branch
	status	  - check if openasar is installed for given branch
	basedir   - print a given branch's base directory

branches: release, ptb, canary
```

### deps
you probably already have them all
- bash
- curl
- sudo

### installation
```bash
$ git clone https://github.com/aquakenzie/openasarctl --depth 1
$ cd openasarctl
$ mv openasar.sh ~/.local/bin/openasar
```
