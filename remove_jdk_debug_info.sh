#!/bin/bash
set -e

if [[ "$TARGET_JDK" == "arm" ]]; then
  export TARGET_JDK=aarch32
fi

imagespath=openjdk/build/${JVM_PLATFORM}-${TARGET_JDK}-normal-${JVM_VARIANTS}-${JDK_DEBUG_LEVEL}/images

rm -rf dizout jreout jdkout
mkdir dizout

cp -r $imagespath/j2re-image jreout
cp -r $imagespath/j2sdk-image jdkout

if [[ "$TARGET_JDK" == "x86" ]]; then
  export TARGET_JDK=i386
fi

mv jdkout/jre/lib/${TARGET_JDK}/libfreetype.so.6 jdkout/lib/${TARGET_JDK}/libfreetype.so || echo "Move exit $?"
mv jdkout/jre/lib/libfreetype.dylib.6 jdkout/jre/lib/libfreetype.dylib || echo "Move exit $?"
mv jreout/lib/${TARGET_JDK}/libfreetype.so.6 jreout/lib/${TARGET_JDK}/libfreetype.so || echo "Move exit $?"
mv jreout/lib/libfreetype.dylib.6 jreout/lib/libfreetype.dylib || echo "Move exit $?"

# Recent jdk8u tags no longer install the external freetype into the image,
# while libfontmanager's DT_NEEDED still references libfreetype.so. Restore
# it from the freetype build output when the image does not carry the library.
export FREETYPE_DIR=$PWD/freetype-$BUILD_FREETYPE_VERSION/build_android-$TARGET_SHORT
if [[ ! -f jreout/lib/${TARGET_JDK}/libfreetype.so ]]; then
  cp $FREETYPE_DIR/lib/libfreetype.so jreout/lib/${TARGET_JDK}/libfreetype.so
fi

find jreout -name "*.diz" -delete
find jdkout -name "*.diz" -exec mv {} dizout/ \;
