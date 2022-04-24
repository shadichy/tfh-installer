@echo off

REM generated by online generation tool, and it sucks
set edition=java bedrock
SET java=false
SET bedrock=false
CALL :main "%@%"
echo "{\"java\":%java%,\"bedrock\":%bedrock%}"

EXIT /B %ERRORLEVEL%

:ck
[[ "%~1" == java ]] && echo "%isjava%"
[[ "%~1" == bedrock ]] && echo "%isbedrock%"
EXIT /B 0

:wr
[[ "%~1" == java ]] && echo "%javaWorlds%"
[[ "%~1" == bedrock ]] && echo "%bedrockWorlds%"
EXIT /B 0

:main
FOR %%i IN (%edition%) do (
    SET link="https:/\teamfuho.net\download\hpvn-%i%%CD%tar.gz"
  SET filename="\tmp\hpvn-%i%%CD%tar.gz"
  IF $(ck "${i}") (
    IF [[ ! -f "%filename%" ]] (
      [[ %ja% == s ]] && wget -O "%filename%" -o \dev\null "%link%" || curl -sLo "%filename%" "%link%"
    )
    IF [[ ! -z "%javaFolder%" && "${i}" == java ]] (
      IF [[ "%JLauncher%" == multimc ]] (
        IF [[ -z %undefined% ]] (
          mkdir -p "%javaFolder%\instances\1.14.4\%CD%minecraft\saves"
          cat REM UNKNOWN: {"text":"<<","type":"dless"} REM UNKNOWN: {"type":"Redirect","op":{"text":">","type":"great"},"file":{"text":"\"${javaFolder}/instances/1.14.4/mmc-pack.json\"","expansion":[{"loc":{"start":1,"end":13},"parameter":"javaFolder","type":"ParameterExpansion"}],"type":"Word"}}
          text
          EOF
          cat REM UNKNOWN: {"text":"<<","type":"dless"} REM UNKNOWN: {"type":"Redirect","op":{"text":">","type":"great"},"file":{"text":"\"${javaFolder}/instances/1.14.4/instance.cfg\"","expansion":[{"loc":{"start":1,"end":13},"parameter":"javaFolder","type":"ParameterExpansion"}],"type":"Word"}}
          text
          EOF
          COPY  pack.png "%javaFolder%\instances\1.14.4\"
        )
      ) ELSE (
        IF [[ "%JLauncher%" == tl ]] (
          IF [[ -z %undefined% ]] (
            mkdir -p "%javaFolder%\home\1.14\saves"
          )
        )
        IF [[ -z %undefined% ]] (
          mkdir -p "%javaFolder%\versions\Happy Vietnam 1.14.4"
          cat REM UNKNOWN: {"text":"<<","type":"dless"} REM UNKNOWN: {"type":"Redirect","op":{"text":">","type":"great"},"file":{"text":"\"${javaFolder}/versions/Happy Vietnam 1.14.4/Happy Vietnam 1.14.4.json\"","expansion":[{"loc":{"start":1,"end":13},"parameter":"javaFolder","type":"ParameterExpansion"}],"type":"Word"}}
          text
          EOF
        )
      )
    )
    tar -xzf "%filename%" -C %undefined%
    IF %?% -eq 0 (
      DEL  "%filename%"
      [[ "%i%" == java ]] && SET java=true
      [[ "%i%" == bedrock ]] && SET bedrock=true
    )
  )
)
EXIT /B 0