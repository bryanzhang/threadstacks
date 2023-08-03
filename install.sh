#! /bin/bash

# errexit
set -e

# Enable tracing mode
set -x

# Define a function to restore the original state
function cleanup {
  # Disable tracing mode
  set +x
}

# Trap the EXIT signal and call the cleanup function
trap cleanup EXIT

echo "Building..."
bazel build //threadstacks/...
bazel build //common/...
echo "Testing..."
#bazel test //...

# Set the installation directory
INSTALL_DIR=${INSTALL_DIR:-/usr/local}
echo "INSTALL_DIR=${INSTALL_DIR}"

# Install the shared library
sudo cp bazel-bin/common/libsysutil.so $INSTALL_DIR/lib/libtssysutil.so
sudo cp bazel-bin/threadstacks/libsignal_handler.so $INSTALL_DIR/lib/libthreadstacks.so

# Install the static library
sudo cp bazel-bin/common/libsysutil.a $INSTALL_DIR/lib/libtssysutil.a
sudo cp bazel-bin/threadstacks/libsignal_handler.a $INSTALL_DIR/lib/libthreadstacks.a

# Install the headers
mkdir -p $INSTALL_DIR/include/threadstacks/
sudo cp -r threadstacks/signal_handler.h $INSTALL_DIR/include/threadstacks/


