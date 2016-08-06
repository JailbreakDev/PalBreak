export TARGET=iphone:clang:latest
export ARCHS=armv7 arm64

DEBUG=0
FINALPACKAGE=1

include theos/makefiles/common.mk

TWEAK_NAME = PalBreak
PalBreak_FILES = Tweak.xm
PalBreak_FRAMEWORKS = UIKit
PalBreak_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PalBreak_INSTALL_PATH = /usr/lib/

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 PayPal SpringBoard"
SUBPROJECTS += palbreaksb
include $(THEOS_MAKE_PATH)/aggregate.mk
