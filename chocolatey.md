# Chocolatey

## Files

```
C:\ProgramData\chocolatey\logs\chocolatey.log
```

## choco
```
choco --version
choco source
choco list
choco outdated
choco pin list
# info
choco info <package-name> -v
Select-String -Path "C:\ProgramData\chocolatey\lib\<package-name>\*.nuspec" -Pattern "dependency"
# install
choco install <pkg> [<pkg2> <pkgn>] [-y] [--ignore-dependencies (=ignore dependency versions)] [-v|--verbose] [-d|--debug]
# reinstall
## reinstall with uninstall and install
choco uninstall <pkg> [<pkg2> <pkgn>] [-y] [--force] [--skip-autounclean]
choco install <pkg> [<pkg2> <pkgn>] [-y] [--force-dependencies] [-v|--verbose] [-d|--debug]
## reinstall with install -f
choco install <pkg> [<pkg2> <pkgn>] [-y] -f|--force [--force-dependencies] [-v|--verbose] [-d|--debug]
choco install VisualStudio2022Professional CppBuildtools -y -f -v -d
# upgrade
choco upgrade <pkg [<pkg2> <pkgn>] | all> [--except="'pkg3,pkg4'"] [-y] [-v|--verbose] [-d|--debug]
```
