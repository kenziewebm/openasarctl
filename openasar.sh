#!/usr/bin/env bash

function usage() {
	echo "usage: $(basename $0) <action> <branch>"  # ugly basename because some bash update made it so that $0 is a full path???
	echo "actions:"
	echo "	install   - install openasar for given branch"
	echo "	uninstall - uninstall openasar for given branch"
	echo "	status	  - check if openasar is installed for given branch"
	echo "	basedir   - print a given branch's base directory"
	echo ""
	echo "branches: release, ptb, canary"
	exit $1
}

function version() {
	echo "openasarctl v1.1"
}

function parser() {
	action=$1
	branch=$2
	case $action in
		install)   install      $branch ;;
		uninstall) uninstall    $branch ;;
		status)    checkinstall $branch ;;
		basedir)   findbasedir  $branch && echo $basedir ;;
		*)         usage        2       ;;
	esac
}

function install() {
	findbasedir $branch
	cp $basedir/resources/app.asar $basedir/resources/app.asar.bak 2>/dev/null || sudo cp $basedir/resources/app.asar $basedir/resources/app.asar.bak
	curl -s https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -o $basedir/resources/app.asar -L || sudo curl -s https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -o $basedir/resources/app.asar -L
	echo "openasar for $branch installed successfully :3"
	echo "make sure to fully restart discord by closing it from the system tray"
}

function uninstall() {
	findbasedir $branch
	if [[ -f $basedir/resources/app.asar.bak ]]; then
		cp $basedir/resources/app.asar.bak $basedir/resources/app.asar || sudo cp $basedir/resources/app.asar.bak $basedir/resources/app.asar
	else
		echo "no app.asar backup found, downloading from asar.goose.icu/asar/latest..."
		curl -s https://asar.goose.icu/asar/latest -o $basedir/resources/app.asar 2>/dev/null || sudo curl -s https://asar.goose.icu/asar/latest -o $basedir/resources/app.asar
	fi
	echo "openasar for $branch uninstalled successfully :3"
	echo "make sure to fully restart discord by closing it from the system tray"
}

function checkinstall() {
	findbasedir $branch
	if [[ $(wc -c $basedir/resources/app.asar | awk '{print $1}') -lt 1048576 ]]; then # check if app.asar < 1mb
		echo "openasar seems to be installed for $branch"
	else
		echo "looks like the stock app.asar is installed for $branch"
	fi
}

function findbasedir() {
	if [[ "$branch" == "release" ]]; then
		suffix=""
		binary="Discord"
	elif [[ "$branch" == "ptb" ]]; then
		suffix="-ptb"
		binary="DiscordPTB"
	elif [[ "$branch" == "canary" ]]; then
		suffix="-canary"
		binary="DiscordCanary"
	else
		echo "invalid branch"
		usage 1
	fi

	case "$(uname -s)" in
		"Darwin") export basedir="/Applications/Discord$suffix.app/Contents/" ;;
		"Linux") export basedir="$(realpath $(which discord$suffix 2>/dev/null) 2>/dev/null| sed -e \"s/\/$binary//g\")" ;;
	esac
	if [[ -z "$basedir" ]]; then
		echo "discord $branch isnt installed"
		exit 3
	fi
}

for i in $(echo curl sudo); do
	if [ -z $(which $i) ]; then
		echo "dep not found: $i"
		exit 1
	fi
done

case $1 in
	-h|--help)
		version
		echo ""
		usage 0 ;;
	-v|-V|--version)
		version
		exit 0 ;;
	*) parser $@ ;;
esac
