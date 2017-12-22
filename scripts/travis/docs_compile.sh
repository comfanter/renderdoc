#!/bin/sh

# ignore "error" codes in the env script below
set +e

. /opt/qt56/bin/qt56-env.sh

set -ev

mkdir build
pushd build

which python3
ls -l $(which python3)
file $(which python3)

cat $(which python3)

echo "print('foo')" > t est.py
echo -e "run\nbt" > gdb.cmd
gdb --batch --command=gdb.cmd --args python3 test.py

# Do a minimal build with as little as possible to get the python modules
CC=gcc-6 CXX=g++-6 cmake -DCMAKE_BUILD_TYPE=Debug -DENABLE_GL=OFF -DENABLE_VULKAN=OFF -DENABLE_RENDERDOCCMD=OFF -DENABLE_QRENDERDOC=OFF ..
make -j2

wc -l qrenderdoc/renderdoc_python.cxx
wc -l qrenderdoc/qrenderdoc_python.cxx

cd bin

echo -e "import renderdoc\nprint(dir(renderdoc))" > test.py
echo -e "run\nbt" > gdb.cmd
gdb --batch --command=gdb.cmd --args python3 test.py

echo -e "import qrenderdoc\nprint(dir(qrenderdoc))" > test.py
echo -e "run\nbt" > gdb.cmd
gdb --batch --command=gdb.cmd --args python3 test.py

popd

cd docs/
make html SPHINXOPTS=-W
