#!/bin/bash

declare -a edition
edition=("java" "bedrock") # for (java bedrock)

java=false
bedrock=false

# Getting files 
main () {
  for i in "${edition[@]}"; do
    local link="https://teamfuho.net/download/hpvn-${i}.tar.gz"
    local filename="/tmp/hpvn-${i}.tar.gz"
    local e="is$i"
  	[ "${!e}" ] || continue
    [[ ! -f "${filename}" ]] && (wget -O "${filename}" -o /dev/null "${link}" || curl -sLo "${filename}" "${link}")
    if [[ ! -z "${javaFolder}" && "${i}" == "java" ]]; then
    	case "${JLauncher}" in
    		"multimc" )
        root="$(ls -d "${javaFolder}"/instances/*1.14.4* 2>/dev/null | head -1)"
		    cp mmc-pack.json instance.cfg pack.png "${root}"/
        ;;
        * )
        if [[ -z "$(ls -d "${javaFolder}"/versions/*1.14* 2>/dev/null | head -1)" ]]; then
          nver="Happy Vietnam 1.14.4"
          root="${javaFolder}/versions/${nver}"
        	mkdir -p "${root}"
        	cp version.json "${root}/${nver}.json"
        fi
        ;;
  	  esac
  	fi
    local wr="${i}Worlds"
    tar -xzf "${filename}" -C "${!wr}" || continue
    rm -f "${filename}"
  	${!i}=true
  done
}
main "$@" > /dev/null
echo "{\"java\":${java},\"bedrock\":${bedrock}}"
