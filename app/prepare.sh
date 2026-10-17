#!/usr/bin/env bash
# Copies everything the app needs into www/ so it works with no internet.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p www/mediapipe/wasm www/fonts www/lib
# Motion Standard is the whole app now: drop the old launcher pages if they are still in the repository
rm -f www/motion.html www/posture.html
cp node_modules/jspdf/dist/jspdf.umd.min.js node_modules/html2canvas/dist/html2canvas.min.js node_modules/exceljs/dist/exceljs.min.js www/lib/
cp node_modules/@mediapipe/tasks-vision/vision_bundle.mjs www/mediapipe/
cp node_modules/@mediapipe/tasks-vision/wasm/* www/mediapipe/wasm/
for f in barlow-condensed/files/barlow-condensed-latin-600-normal barlow-condensed/files/barlow-condensed-latin-700-normal \
         ibm-plex-sans/files/ibm-plex-sans-latin-400-normal ibm-plex-sans/files/ibm-plex-sans-latin-500-normal ibm-plex-sans/files/ibm-plex-sans-latin-600-normal \
         ibm-plex-mono/files/ibm-plex-mono-latin-400-normal ibm-plex-mono/files/ibm-plex-mono-latin-500-normal; do
  cp "node_modules/@fontsource/$f.woff2" www/fonts/
done
if [ "${SKIP_MODEL:-0}" != "1" ]; then
  curl -fsSL -o www/mediapipe/pose_landmarker_lite.task \
    https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_lite/float16/1/pose_landmarker_lite.task
  test "$(stat -c%s www/mediapipe/pose_landmarker_lite.task)" -gt 1000000
fi
echo "Offline files ready:"; du -sh www
