#!/usr/bin/env bash
# Adds camera permission and sets the version number of the Android project.
set -euo pipefail
cd "$(dirname "$0")"
N="${1:-1}"
M=android/app/src/main/AndroidManifest.xml
grep -q 'android.permission.CAMERA' "$M" || sed -i 's#<uses-permission android:name="android.permission.INTERNET" />#<uses-permission android:name="android.permission.INTERNET" />\n    <uses-permission android:name="android.permission.CAMERA" />\n    <uses-feature android:name="android.hardware.camera" android:required="false" />#' "$M"
grep -q 'android.permission.CAMERA' "$M"
G=android/app/build.gradle
sed -i -E "s/versionCode [0-9]+/versionCode $N/; s/versionName \"[^\"]*\"/versionName \"1.$N\"/" "$G"
grep -E "versionCode|versionName" "$G"
