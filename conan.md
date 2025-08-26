# conan

```
cd $HOME/dev
# python3 -m venv conan
source conan/bin/activate
pip install conan
```

## remote
conan remote add artifactory https://<artifactory-base-url>/artifactory/api/conan/artifactory
conan remote list

## install
conan install . -of build.debug -o tests=True -b missing -r artifactory -pr:a 29

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
