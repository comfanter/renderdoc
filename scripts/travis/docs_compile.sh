#!/bin/sh

# ignore "error" codes in the env script below
set +e

. /opt/qt56/bin/qt56-env.sh

set -ev

mkdir build
pushd build

# Do a minimal build with as little as possible to get the python modules
CC=gcc-6 CXX=g++-6 cmake -DCMAKE_BUILD_TYPE=Debug -DENABLE_GL=OFF -DENABLE_VULKAN=OFF -DENABLE_RENDERDOCCMD=OFF -DENABLE_QRENDERDOC=OFF ..
make -j2

wc -l qrenderdoc/renderdoc_python.cxx
wc -l qrenderdoc/qrenderdoc_python.cxx

cd bin

echo "run" > gdb.cmd
echo "bt" >> gdb.cmd
echo "info proc mappings" >> gdb.cmd
echo "p &PyType_Type" >> gdb.cmd
echo "p PyType_Type" >> gdb.cmd
echo "p PyType_Type.tp_basicsize" >> gdb.cmd
echo "disassemble /s" >> gdb.cmd

echo -e "import renderdoc\nprint(dir(renderdoc))" > test.py
gdb --batch --command=gdb.cmd --args /usr/bin/python3 test.py

echo -e "import qrenderdoc\nprint(dir(qrenderdoc))" > test.py
gdb --batch --command=gdb.cmd --args /usr/bin/python3 test.py

popd

cd docs/
make html SPHINXOPTS=-W
