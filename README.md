# StratifySDK
CMake Project to Pull (or clone) and build the Stratify SDK (Stratify OS, Stratify API and supporting libraries). This project can only be used
to update an SDK that is already installed. It cannot be used
to bootstrap an installation on a machine that doesn't have the SDK installed.

On Mac:

```
git clone https://github.com/StratifyLabs/StratifySDK.git
cd StratifySDK
mkdir build
cd build
cmake ..
```

On Windows:

```
git clone https://github.com/StratifyLabs/StratifySDK.git
cd StratifySDK
mkdir build
cd build
cmake .. -G "MinGW Makefiles"
```

## Options

Clone and build demo applications

```
cmake ... -DINCLUDE_APP=1
``
