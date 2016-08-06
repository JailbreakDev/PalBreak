include theos/makefiles/common.mk

TWEAK_NAME = PalBreakSB
PalBreakSB_FILES = Tweak.xm
PalBreakSB_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
