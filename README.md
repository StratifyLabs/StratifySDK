# StratifySDK

The SDK must be at v3.6.0 for this to work correctly. If your
SDK is not at v3.6.0, you can install the latest version
from https://stratifylabs.co/download.

CMake Project to Pull (or clone) and build the Stratify SDK (Stratify OS, Stratify API and supporting libraries). This project can only be used
to update an SDK that is already installed. It cannot be used
to bootstrap an installation on a machine that doesn't have the SDK installed.

```
git clone https://github.com/StratifyLabs/StratifySDK.git
cd StratifySDK
cmake -P StratifySDK.cmake
```

## Options

Clone and build demo applications with SDK:

```
cmake -DINCLUDE_APP=ON -P StratifySDK.cmake
```

Clone and build demo BSPs with SDK:

```
cmake -DINCLUDE_BSP=ON -P StratifySDK.cmake
```

### Windows

Build the libraries for execution in a desktop environment for Windows:

```
cmake -DINCLUDE_LINK=ON -DINCLUDE_ARM=OFF -DSOS_SDK_TOOLCHAIN_DIR=<mingw-path> -DSOS_SDK_TOOLCHAIN_HOST=<mingw-prefix> -P StratifySDK.cmake
```

And here is an example of the above command with values populated.

```
cmake -DINCLUDE_LINK=ON -DINCLUDE_ARM=OFF -DSOS_SDK_TOOLCHAIN_DIR=C:/Qt-5.9/Tools/mingw530_32 -DSOS_SDK_TOOLCHAIN_HOST=i686-w64-mingw32 -P StratifySDK.cmake
```

### Mac OS X

Build the libraries for execution in a desktop environment for Mac:

```
cmake -DINCLUDE_LINK=ON -DINCLUDE_ARM=OFF -P StratifySDK.cmake
```
