#!/usr/bin/sh
export NDK_PATH=/home/sphericalkat/Android/Sdk/ndk/27.0.11902837
export TARGET=aarch64-linux-android
export API=21

export CC=$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/bin/$TARGET$API-clang
export STRIP=$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip
export CXX=$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/bin/$TARGET$API-clang++
export CGO_CFLAGS="-I$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include"
export CGO_CPPFLAGS="-I$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include"
export CGO_CXXFLAGS="-I$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include"
export CGO_LDFLAGS="-L$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib"

CGO_ENABLED=1 GOOS=android GOARCH=arm64 go build -o target/android-arm64/libreadability.so -buildmode=c-shared main.go
$STRIP target/android-arm64/libreadability.so