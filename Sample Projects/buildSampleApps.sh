#!/bin/bash

MASTER_SCHEME="VWMasterApplication"
SWIFT_SCHEME="VWAdSwiftExample"
SDK="iphoneos"
CERTIFICATE=

WORKSPACE="VWAdSuite.xcworkspace"

SYMROOT="/Users/christinalong/Desktop/sym.root"
APPROOT="/Users/christinalong/Desktop/sym.root/Release-iphoneos/VWMasterApplication.app"
DESTINATION=
CFLAGS="-objc -all_load"


#Switch to Xcode 6.4 build tools
sudo xcode-select -s /Applications/Xcode\ 6.4.app/Contents/Developer
xcode-select -p

#XCode 6 Build
echo "Cleaning Xcode 6 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${MASTER_SCHEME} -sdk iphoneos clean

#echo "Building XCode 6 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${MASTER_SCHEME} -configuration Release SYMROOT=${SYMROOT}
xcrun -sdk iphoneos PackageApplication -v ${APPROOT} -o "/Users/christinalong/Desktop/VWMasterApplication_Xcode6.ipa" --sign "iPhone Distribution: Verve Wireless, Inc."


#Switch to Xcode 7 build tools
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcode-select -p

#XCode 7 Build
echo "Cleaning Xcode 7 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${MASTER_SCHEME} -sdk iphoneos clean

#echo "Building XCode 7 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${MASTER_SCHEME} -configuration Release SYMROOT=${SYMROOT}
xcrun -sdk iphoneos PackageApplication -v ${APPROOT} -o "/Users/christinalong/Desktop/VWMasterApplication_Xcode7_Exempt.ipa" --sign "iPhone Distribution: Verve Wireless, Inc."

#XCode 7 Build
echo "Cleaning Xcode 7 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${SWIFT_SCHEME} -sdk iphoneos clean

#echo "Building XCode 7 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${SWIFT_SCHEME} -configuration Release SYMROOT=${SYMROOT}
xcrun -sdk iphoneos PackageApplication -v ${APPROOT} -o "/Users/christinalong/Desktop/VWSwiftApplication_Xcode7_Exempt.ipa" --sign "iPhone Distribution: Verve Wireless, Inc."


#XCode 7 Build - EXEMPT

#Use PList buddy to add the exemption keys
echo "Adding NSAppTransportSecurity"
/usr/libexec/PlistBuddy -c "Add :NSAppTransportSecurity dict" /Users/christinalong/Documents/iOS_Ad/Test\ Projects/VWAdSuite/VWMasterApplication/VWMasterApplication/Info.plist

echo "Adding NSAppTransportSecurity:NSAllowsArbitraryLoads"
/usr/libexec/PlistBuddy -c "Add :NSAppTransportSecurity:NSAllowsArbitraryLoads bool true" /Users/christinalong/Documents/iOS_Ad/Test\ Projects/VWAdSuite/VWMasterApplication/VWMasterApplication/Info.plist


#echo "Building XCode 7 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${MASTER_SCHEME} -configuration Release SYMROOT=${SYMROOT}
xcrun -sdk iphoneos PackageApplication -v ${APPROOT} -o "/Users/christinalong/Desktop/VWMasterApplication_Xcode7.ipa" --sign "iPhone Distribution: Verve Wireless, Inc."

#XCode 7 Build
echo "Cleaning Xcode 7 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${SWIFT_SCHEME} -sdk iphoneos clean

#echo "Building XCode 7 Build..."
xcodebuild -workspace ${WORKSPACE} -scheme ${SWIFT_SCHEME} -configuration Release SYMROOT=${SYMROOT}
xcrun -sdk iphoneos PackageApplication -v ${APPROOT} -o "/Users/christinalong/Desktop/VWSwiftApplication_Xcode7.ipa" --sign "iPhone Distribution: Verve Wireless, Inc."


#Cleanup by removing the exemption keys
echo "Removing NSAppTransportSecurity"
/usr/libexec/PlistBuddy -c "Delete :NSAppTransportSecurity dict" /Users/christinalong/Documents/iOS_Ad/Test\ Projects/VWAdSuite/VWMasterApplication/VWMasterApplication/Info.plist
