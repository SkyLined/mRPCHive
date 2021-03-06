@ECHO OFF
CALL :SET_TITLE "%~dp0"
:START
  CALL npm install
  IF ERRORLEVEL 1 (
    ECHO === Installing dependencies failed!
    GOTO :ERROR
  )
  CALL node test.js
  IF ERRORLEVEL 1 (
    ECHO === Test failed!
    GOTO :ERROR
  )
  ECHO === Updating version number...
  CALL npm version patch -m "Version updated to %%%%s"
  IF ERRORLEVEL 1 (
    ECHO === Cannot update version number!
    GOTO :ERROR
  )
  CALL npm publish
  IF ERRORLEVEL 1 (
    ECHO === Cannot publish package!
    ECHO === Reverting version update commit...
    git reset --hard HEAD~1
    IF ERRORLEVEL 1 (
      ECHO === Cannot revert commit to update version number!
    )
    GOTO :ERROR
  )
  EXIT /B 0

:SET_TITLE
  TITLE Publishing %~n1...
  EXIT /B 0

:ERROR
  ECHO Press CTRL+C to terminate or ENTER to retry...
  PAUSE >nul
  GOTO :START

