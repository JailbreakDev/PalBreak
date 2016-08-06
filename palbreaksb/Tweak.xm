@interface FBBundleInfo : NSObject
@property (nonatomic,copy) NSString * displayName;
@property (nonatomic,copy) NSString * bundleIdentifier;
@end

@interface FBApplicationInfo : FBBundleInfo
@end

static NSString *libPath = @"/usr/lib/PalBreak.dylib";

%hook FBApplicationInfo

- (NSDictionary *)environmentVariables {
	NSMutableDictionary *env = [NSMutableDictionary dictionary];
	[env addEntriesFromDictionary:%orig];
	if ([self.bundleIdentifier isEqualToString:@"com.yourcompany.PPClient"]) {
		NSString *oldDylibs = env[@"DYLD_INSERT_LIBRARIES"];
		NSString *newDylibs = oldDylibs ? [NSString stringWithFormat:@"%@:%@", libPath, oldDylibs] : libPath;
		[env setObject:newDylibs forKey:@"DYLD_INSERT_LIBRARIES"];
		[env setObject:@"1" forKey:@"_MSSafeMode"];
	}
	return env;
}

%end
