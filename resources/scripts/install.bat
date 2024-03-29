@echo off
setlocal enabledelayedexpansion

:: generated by online generation tool, and it sucks
set edition=java bedrock
set java=false
set bedrock=false

for %%i in (%edition%) do (
  setlocal
  set link="https://teamfuho.net/download/hpvn-%i%.tar.gz"
  set filename="/tmp/hpvn-%%i.tar.gz"
  set !local%%i!=false
  if !is%%i!=="" goto :continue
  if %i%=="java" if not "%javaFolder%"=="" (
    if "%JLauncher%"=="multimc" (
      for /D %%D in ("%javaFolder%\instances\*1.14.4*") do (
        set root=%%D
        goto :break
      )

      :break
      copy  "mmc-pack.json" "instance.cfg" "pack.png" "%root%"/
    ) else (
      for /D %%D in ("%javaFolder%\versions\*1.14*") do (
        goto :out
      )
      
      set nver=happy vietnam 1.14.4
      set root="%javaFolder%/versions/%nver%"
      mkdir "%root%"
      copy  "version.json" "%root%/%nver%.json"

      :out
      echo " " > null
    )
  )

  tar.exe "-xzf" "%filename%" "-c" !Worlds%%i! || goto :continue

  del "%filename%"
  endlocal && (
    set !%%i!=!local%%i!
  )

  :continue
  echo " " > null
)

echo "{\"java\":%java%,\"bedrock\":%bedrock%}"
exit /b %errorlevel%g

