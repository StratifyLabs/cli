# cli

This is a command Line Tool Template Project. It includes Stratify Labs API libraries for basic tasks:

- SysAPI
- FsAPI
- InetAPI
- JsonAPI

To build:

```
git clone https://github.com/StratifyLabs/cli
cmake -P bootstrap.cmake
source profile.sh
cd cmake_link
cmake .. -GNinja
ninja install
```

To Run:

```
cli
cli --json
```
