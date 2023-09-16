#!/usr/bin/env bash
set -e

DIST_DIR=clangd-portable-dist
rm -rf $DIST_DIR
mkdir -p $DIST_DIR/lib
pushd $DIST_DIR > /dev/null

echo "Building using clangd from $(which clangd)"

cp `which clangd` .
echo "Getting dependencies"
ldd clangd | awk 'NF == 4 { system("cp -v " $3 " ./lib") }'
echo "Fixing ELF interpreter"
patchelf --set-interpreter ./lib/ld-linux-x86-64.so.2 clangd

echo "Creating run-clangd script"
cat << "EOF" > run-clangd
#!/usr/bin/env bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
export LD_LIBRARY_PATH=$SCRIPTPATH/lib
cd $SCRIPTPATH
./clangd $@
EOF

chmod +x run-clangd

popd > /dev/null

echo "Compressing package"
rm -f $DIST_DIR.tar $DIST_DIR.tar.gz
tar cf $DIST_DIR.tar $DIST_DIR
gzip $DIST_DIR.tar

echo "Done! Created $DIST_DIR.tar.gz"
