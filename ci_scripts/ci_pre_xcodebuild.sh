#!/bin/sh

set -ex

if [ "$CI_PRODUCT_PLATFORM" = 'macOS' ] && [ "$CI_XCODEBUILD_ACTION" = 'build-for-testing' ]; then
	sed -i'~' 's/ENABLE_HARDENED_RUNTIME = YES;/ENABLE_HARDENED_RUNTIME = NO;/g' \
		"$CI_PRIMARY_REPOSITORY_PATH/$CI_XCODE_PROJECT/project.pbxproj"
fi
