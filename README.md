# clangd-portable

Simple script to create a portable copy of clangd, to be used on systems with too old of a libc to run it, such as CentOS/RHEL 7.

# Requirements
- A modern Linux distribution to build the package
- clangd and patchelf installed

# Building
run:

```bash
./build.sh
```

# Usage
Copy the output clangd-portable-dist.tar.gz to your old system.

Use the `run-clangd` script as you would clangd. You can symlink it (with a link named `clangd`) to a directory on your path.