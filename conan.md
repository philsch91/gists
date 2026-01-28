# conan

```
cd $HOME/dev
python3 -m venv conan
source conan/bin/activate
pip install conan
pip show conan
# Windows
C:\dev\conan\bin\Activate.ps1
where conan
C:\Users\<user>\AppData\Roaming\Python\Python313\Scripts\conan.exe
python3 -m pip install pip-system-certs
```

## Files

- $HOME/.conan2/global.conf
- $HOME/.conan2/remotes.json

## version
```
conan version
```

## config
```
conan config list
```

```
cat $HOME/.conan2/global.conf

# Core configuration (type 'conan config list' to list possible values)
# e.g, for CI systems, to raise if user input would block
# core:non_interactive = True
# some tools.xxx config also possible, though generally better in profiles
# tools.android:ndk_path = my/path/to/android/ndk
# Linux
core.net.http:cacert_path=/etc/ssl/certs/ca-certificates.crt
# Windows
core.net.http:cacert_path={{conan_home_folder}}\cacert.pem
```

## remote
```
conan remote list
conan remote add artifactory https://<artifactory-base-url>/artifactory/api/conan/artifactory
conan remote login artifactory <username> -p <password>
conan remote update <remote-name> --url="<remote-url>"
```

## install
```
conan install . -of build.debug -pr:a 29 -o tests=True -b missing -r artifactory
```

## build
```
conan build . -of build.win.math.debug -pr:a vs17-cpp20-dbg -o tests=True -r artifactory [-c tools.cmake.cmaketoolchain:generator="Ninja"] [--lockfile .\conan.lock]
```

## Profiles
```
cat $HOME/.conan2/profiles/29

[settings]
os=Linux
arch=x86_64
compiler=gcc
compiler.version=13
compiler.cppstd=gnu20
compiler.libcxx=libstdc++11
build_type=Debug
```

```
cat $HOME/.conan2/profiles/vs17-cpp20-dbg

[settings]
os=Windows
arch=x86_64
compiler=msvc
compiler.version=194
compiler.update=2
compiler.cppstd=20
compiler.runtime=static
compiler.runtime_type=Debug
build_type=Debug
[options]
```
