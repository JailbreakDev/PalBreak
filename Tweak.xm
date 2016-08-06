#include <stdio.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#include <stdio.h>
#include <substrate.h>

#ifdef DEBUG
#define PPDebugLog(fmt, ...) NSLog((@"%s:%d: "fmt),__FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define PPDebugLog(...)
#endif

static void ppfix_image_added(const struct mach_header *mh, intptr_t slide) {
	Dl_info image_info;
	int result = dladdr(mh, &image_info);
	if (result == 0) {
		return;
	}
	const char *image_name = image_info.dli_fname;
	PPDebugLog(@"[PalBreak] Image Added: %s",image_name);
	if (strstr(image_name,"/Library/MobileSubstrate") != NULL || strcmp(image_name,"/Library/Frameworks/CydiaSubstrate.framework/Libraries/SubstrateLoader.dylib") == 0 || strcmp(image_name,"/usr/lib/libsubstrate.dylib") == 0 || strcmp(image_name,"/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate") == 0) {
		PPDebugLog(@"[PalBreak] Detected Substrate Image: %s",image_name);
		void *handle = dlopen(image_name,RTLD_NOLOAD);
		PPDebugLog(@"[PalBreak] Removing Substrate handle: %p (%s)",handle,image_name);
		if (handle) {
			dlclose(handle);
		}
	}
	setenv("_MSSafeMode", "0", true);
}

__attribute__((constructor)) static void pp_init() {
	PPDebugLog(@"[PalBreak] Init");
	_dyld_register_func_for_add_image(&ppfix_image_added);
}
