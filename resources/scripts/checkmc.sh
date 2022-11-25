#!/bin/bash

# Default variables
java=false
bedrock=false

if [[ "$2" ]]; then
	javaFolder="$2"
	bedrockFolder="$2"
else
	case "$1" in
		"Darwin")
			javaFolder=~/"Library/Application Support/minecraft"
			bedrockFolder=~/"Library/Application Support/mcpelauncher/games/com.mojang"
			;;
		*)
			javaFolder=~/".minecraft"
			bedrockFolder=~/".var/app/io.mrarm.mcpelauncher/data/mcpelauncher/games/com.mojang"
			[ -d "${bedrockFolder}" ] || bedrockFolder=~/".local/share/mcpelauncher/games/com.mojang"
			;;
	esac
fi

javafind(){
	# array of possible multimc.cfg paths
	declare -a paths
	case "$1" in
		"Darwin")
			paths=( "/Applications" ~/"Library/Application Support" ~/"Downloads" ~ )
			;;
		*)
			paths=( ~/"Downloads" ~/".local/share" ~ )
			;;
	esac
	for path in "${paths[@]}"; do
		[ -d "$path" ] || continue
		local dir="$(find "$path" -type d \( -iname "multimc" -o -iname "ultimmc" -o -iname "polymc" -o -iname "manymc" -o -iname "prismlauncher" -o -iname "minecraft" -o -iname ".minecraft" \) 2>/dev/null)"
		for d in ${dir}; do
			filepath="$(find "$d" -type f \( -iname "multimc.cfg" -o -iname "ultimmc.cfg" -o -iname "polymc.cfg" -o -iname "ultimmc.cfg" -o -iname "manymc.cfg" -o -iname "prismlauncher.cfg" -o -iname "launcher_profiles.json" \) -print -quit 2>/dev/null)"
			[ "${filepath}" ] || continue
			local mcdir="${filepath%/*}"
			break
		done
		[ "${mcdir}" ] && break
	done
	javaFolder="${mcdir}"
	dircheck "$1"
}

bedfind(){
	beddir="$(find ~ -type d -iname "com.mojang" -print -quit 2>/dev/null)"
	[ "${beddir}" ] || return
	bedrock=true
	bedrockFolder="${beddir}"
	bedrockWorlds="${bedrockFolder}/minecraftWorlds"
}

dircheck(){
	local dir
	[ "${javaFolder}" ] || return
	[ "${bedrockFolder}" ] || return
	if [[ -d "${javaFolder}" ]]; then
		if [[ -d "${javaFolder}/home" ]]; then
			JLauncher="tl"
			dir="$(ls -d "${javaFolder}"/home/*1.14* 2>/dev/null | head -1)"
			[ "${dir}" ] || dir="${javaFolder}/home/HappyVietnam_1.14"
		elif [[ -d "${javaFolder}/instances" ]];then
			JLauncher="multimc"
			dir="$(ls -d "${javaFolder}"/instances/*1.14* 2>/dev/null | head -1)"
			[ "${dir}" ] || dir="${javaFolder}/instances/HappyVietnam_1.14/.minecraft"
		else
			JLauncher="default"
			dir="${javaFolder}"
		fi
		javaWorlds="${dir}/saves"
		[ "${javaWorlds}" ] || mkdir -p "${javaWorlds}"
		java=true
	else
		javaFolder=""
		[ "$2" ] || javafind "$1"
	fi

	if [[ -d "${bedrockFolder}" ]]; then
		bedrockWorlds="${bedrockFolder}/minecraftWorlds"
		[ -d "${bedrockWorlds}" ] || mkdir -p "${bedrockWorlds}"
		bedrock=true
	else
		bedrockFolder=""
		[ "$2" ] || bedfind "$1"
	fi
}

dircheck "$@"

echo "{\"java\":${java},\"bedrock\":${bedrock},\"javaFolder\":\"${javaFolder}\",\"bedrockFolder\":\"${bedrockFolder}\",\"javaWorlds\":\"${javaWorlds}\",\"bedrockWorlds\":\"${bedrockWorlds}\",\"JLauncher\":\"${JLauncher}\"}"
