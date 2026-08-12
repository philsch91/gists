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
## --force-dependencies + --force = force installation of dependent packages
## --ignore-dependencies = ignore dependency versions and do not download packages depending on the package to be installed
choco install <pkg> [<pkg2> <pkgn>] [-y] [-f|--force [-x|--force-dependencies]] [--ignore-dependencies] [-v|--verbose] [-d|--debug]
# uninstall
## --force-dependencies = force uninstallation of dependent packages
## --ignore-dependencies = ignore and do not uninstall packages depending on the package to be uninstalled
## --skip-autounclean = uninstall package only in the Chocolatey database; files will remain on the filesystem
choco uninstall <pkg> [<pkg2> <pkgn>] [-y] [--force] [-x|--force-dependencies] [--ignore-dependencies] [--skip-autounclean] [-v|--verbose] [-d|--debug]
# reinstall
## reinstall with uninstall [--ignore-dependencies] and install
choco uninstall <pkg> [<pkg2> <pkgn>] [-y] [--ignore-dependencies] -v -d
choco install <pkg> [<pkg2> <pkgn>] [-y] -v -d
## reinstall with install --force and --ignore-dependencies
choco install <pkg> [<pkg2> <pkgn>] [-y] -f|--force --ignore-dependencies -v -d
## reinstall with install --force and --force-dependencies
choco install <pkg> [<pkg2> <pkgn>] [-y] -f|--force -x|--force-dependencies -v -d
choco install VisualStudio2022Professional CppBuildtools -y -f -x -v -d
# upgrade
choco upgrade <pkg [<pkg2> <pkgn>] | all> [--except="'pkg3,pkg4'"] [-y] -v -d
```
