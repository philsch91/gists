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
# install
choco install <pkg> [<pkg2> <pkgn>] [-y] [--ignore-dependencies (=ignore dependency versions)] [-v|--verbose] [-d|--debug]
# reinstall
choco uninstall <pkg> [<pkg2> <pkgn>] [-y] [--force] [--skip-autounclean]
choco install <pkg> [<pkg2> <pkgn>] [-y] [-f|--force] [--force-dependencies] [-v|--verbose] [-d|--debug]
# upgrade
choco upgrade <pkg [<pkg2> <pkgn>] | all> [--except="'pkg3,pkg4'"] [-y] [-v|--verbose] [-d|--debug]
```
