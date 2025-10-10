# conan

```
cd $HOME/dev
python3 -m venv conan
source conan/bin/activate
pip install conan

#
python3 -m pip install pip-system-certs
```

## Files

- $HOME/.conan2/global.conf
- $HOME/.conan2/remotes.json

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
```

## install
conan install . -of build.debug -o tests=True -b missing -r artifactory -pr:a 29

## Profiles
```
cat $HOME/.conan2/profiles/29

[settings]
arch=x86_64
build_type=Debug
compiler=gcc
compiler.cppstd=gnu20
compiler.libcxx=libstdc++11
compiler.version=13
os=Linux
```
