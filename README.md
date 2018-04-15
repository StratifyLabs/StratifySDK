# StratifySDK

The SDK must be at v3.6.0 for this to work correctly. If your
SDK is not at v3.6.0, you can install the latest version
from https://stratifylabs.co/download.

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

On Windows (This hasn't been tested in windows yet):

```
git clone https://github.com/StratifyLabs/StratifySDK.git
cd StratifySDK
mkdir build
cd build
cmake .. -G "MinGW Makefiles"
```

## Options

Clone and build demo applications with SDK:

```
cmake .. -DINCLUDE_APP=1
```

Clone and build demo BSPs with SDK:

```
cmake .. -DINCLUDE_BSP=1
```
