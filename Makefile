ARCHS = arm64
TARGET = appletv:clang:12.4
FINALPACKAGE = 1
SYSROOT = $(THEOS)/sdks/AppleTVOS12.4.sdk
INSTALL_TARGET_PROCESSES = TVSystemMenuService 

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ScreenRecordModule

ScreenRecordModule_FILES = ScreenRecordModule.mm
ScreenRecordModule_INSTALL_PATH = /Library/TVSystemMenuModules
ScreenRecordModule_FRAMEWORKS = UIKit ReplayKit AudioToolbox AVFoundation
ScreenRecordModule_PRIVATE_FRAMEWORKS = TVSystemMenuUI PineBoardServices
ScreenRecordModule_CFLAGS = -fobjc-arc  -F. -I.
ScreenRecordModule_LIBRARIES = substrate
ScreenRecordModule_LDFLAGS +=  -F. -I.

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/TVSystemMenuModules$(ECHO_END)

include $(THEOS_MAKE_PATH)/aggregate.mk
