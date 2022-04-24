#!/bin/sh

java=false
bedrock=false

ck(){
	[[ "$1" == "java" ]] && echo "${isjava}"
	[[ "$1" == "bedrock" ]] && echo "${isbedrock}"
}
wr(){
	[[ "$1" == "java" ]] && echo "${javaWorlds}"
	[[ "$1" == "bedrock" ]] && echo "${bedrockWorlds}"
}

# Getting files 
main () {
  for i in "${edition[@]}"; do
    link="https://teamfuho.net/download/hpvn-${i}.tar.gz"
    filename="/tmp/hpvn-${i}.tar.gz"
  	if $(ck "${i}"); then
      [[ ! -f "${filename}" ]] && ([[ "$(command -v wget)" ]] && wget -O "${filename}" -o /dev/null "${link}" || curl -sLo "${filename}" "${link}")
      if [[ ! -z "${javaFolder}" && "${i}" == "java" ]]; then
      	case "${JLauncher}" in
      		"multimc" )
      			if [[ -z $(ls -d "${javaFolder}"/instances/*1.14.4* | head -1) ]]; then
      				mkdir -p "${javaFolder}/instances/1.14.4/.minecraft/saves"
  	  				cat <<EOF > "${javaFolder}/instances/1.14.4/mmc-pack.json"
text
EOF
					    cat <<EOF > "${javaFolder}/instances/1.14.4/instance.cfg"
text
EOF
    	    		cp pack.png "${javaFolder}/instances/1.14.4/"
    	    	fi
    	    	;;
    	    * )
            if [[ "${JLauncher}" == "tl" ]]; then
    	      	if [[ -z $(ls -d "${javaFolder}"/home/*1.14* | head -1) ]]; then
    	      		mkdir -p "${javaFolder}/home/1.14/saves"
    	      	fi
            fi
    	    	if [[ -z $(ls -d "${javaFolder}"/versions/*1.14* | head -1) ]]; then
    	    		mkdir -p "${javaFolder}/versions/Happy Vietnam 1.14.4"
    	    		cat <<EOF > "${javaFolder}/versions/Happy Vietnam 1.14.4/Happy Vietnam 1.14.4.json"
text
EOF
    	    	fi
    	    	;;
  	    esac
  	  fi
  	  tar -xzf "${filename}" -C $(wr "${i}")

      if [ $? -eq 0 ]; then
          rm -f "${filename}"
  	    [[ "${i}" == "java" ]] && java=true
  	    [[ "${i}" == "bedrock" ]] && bedrock=true
      fi 
    fi
  done
}
main "$@"
echo "{\"java\":${java},\"bedrock\":${bedrock}}"
