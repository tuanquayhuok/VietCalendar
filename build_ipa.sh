#!/bin/bash
set -e

echo "🚀 Bắt đầu quá trình build IPA cho VietCalendar..."

# 1. Kiểm tra xcodegen
if ! command -v xcodegen &> /dev/null; then
    echo "📦 Đang cài đặt xcodegen qua Homebrew..."
    brew install xcodegen
fi

# 2. Tạo Xcode Project
echo "🛠️ Tạo VietCalendar.xcodeproj..."
xcodegen generate

# 3. Build & Archive
echo "📦 Build và tạo xcarchive..."
rm -rf build
mkdir -p build

xcodebuild archive \
  -project VietCalendar.xcodeproj \
  -scheme VietCalendar \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/VietCalendar.xcarchive \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

# 4. Đóng gói thành file .ipa
echo "📱 Đóng gói thành file VietCalendar.ipa..."
mkdir -p build/Payload
cp -r build/VietCalendar.xcarchive/Products/Applications/VietCalendar.app build/Payload/
cd build
zip -qr VietCalendar.ipa Payload
cd ..

echo "✅ HOÀN TẤT! File IPA đã được tạo tại: build/VietCalendar.ipa"
