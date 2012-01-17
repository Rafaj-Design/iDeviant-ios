//
//  iDeviantAppDelegate.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import "iDeviantAppDelegate.h"
#import "IDHomeController.h"
#import "Configuration.h"
//#import "FlurryAPI.h"
#import "Appirater.h"
#import "IGABuildChecks.h"
#import "ASIDownloadCache.h"
//#import "JCO.h"

#import "FBConnect.h"

#import <objc/runtime.h> 
#import <objc/message.h>

#import "FTLanguageManager.h"

#import "MWFeedItem.h"

#import "FTDataJson.h"
#import "FTDownload.h"

#import "FTFilesystemIO.h"
#import "FTFilesystemPaths.h"

static NSString* kAppId = @"118349561582677";

@implementation iDeviantAppDelegate

@synthesize window;

@synthesize facebook;
@synthesize fbParams;

@synthesize timestamp, categories;
@synthesize version;

#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Build checks
	if (kDebug) {
		[IGABuildChecks perform];
	}
	
	NSString *path = [FTFilesystemPaths getDocumentsDirectoryPath];
	path = [path stringByAppendingPathComponent:@"timestamp.txt"];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSError *err = nil;
		version = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err] integerValue];
	}
	
	timestamp = [[FTDownload alloc] initWithPath:@"http://staging.fuerteint.com/projects/ideviant/timestamp.php"];
//	[timestamp setDownloadToFilePath:path];
	[timestamp setDelegate:(id<FTDownloadDelegate>)self];
	[timestamp startDownload];
	
	path = [path stringByDeletingLastPathComponent];
	
	path = [path stringByAppendingPathComponent:@"categories.json"];

	categories = [[FTDownload alloc] initWithPath:@"http://staging.fuerteint.com/projects/ideviant/categories.txt"];
	[categories setDownloadToFilePath:path];
	[categories setDelegate:(id<FTDownloadDelegate>)self];
	
	
//	// starting Flurry tracking
//	if (kSystemTrackingFlurryEnableTracking) {
//		if (kDebug && [kSystemTrackingFlurryAPICode isEqualToString:@"app-code-here"]) NSLog(@"Configuration error: Please check Flurry API code!"); 
//		[FlurryAPI startSession:kSystemTrackingFlurryAPICode];
//		
//		// Track information about language
//		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//		NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//		NSString *currentLanguage = [languages objectAtIndex:0];
//		
//		[FlurryAPI logEvent:[NSString stringWithFormat:@"Locale id: %@", [[NSLocale currentLocale] localeIdentifier]]];
//		[FlurryAPI logEvent:[NSString stringWithFormat:@"Current language: : %@", currentLanguage]];
//	}
	
	// Starting AppiRater
	if (kSystemApiRaterDebug || kSystemApiRaterEnabled) {
		[Appirater appLaunched];
	}
		
	facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:(id<FBSessionDelegate>)self];
	fbParams = [[NSMutableDictionary alloc] init];
		
    // Override point for customization after application launch you bloody maggots.
	IDHomeController *c = [[IDHomeController alloc] init];
	navigationController = [[FTNavigationViewController alloc] initWithRootViewController:c];
	[c release];
    
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	
	// Jira bug tracking system
	//[[JCO instance] configureJiraConnect:kSystemJiraErrorReporting customDataSource:nil];
	
	// Clear cache
	[[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];

    return YES;
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {	
//    return [facebook handleOpenURL:url]; 
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	//[FTLang printLanguageDebug];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Clear cache
	[[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	//[FTLang printLanguageDebug];
}

#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

#pragma mark Utility Methods

- (void)showNetworkActivity:(BOOL)visible sender:(id)sender {
    static NSInteger processCount = 0;
    if (visible) {
        processCount++;
	}
	else {
        processCount--;
		if(processCount < 0) {
			processCount = 0;
		}
	}
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(processCount > 0)];
}

#pragma mark - Facebook

#pragma mark FBSessionDelegate

//NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                               @"Share on Facebook",  @"user_message_prompt",
//                               actionLinksStr, @"action_links",
//                               attachmentStr, @"attachment",
//                               message,@"message",
//                               nil];
//
//
//[_facebook dialog:@"feed"
//        andParams:params
//      andDelegate:self];

//- (void)authorize:(NSArray *)permissions
//  urlSchemeSuffix:(NSString *)urlSchemeSuffix {
//	self.urlSchemeSuffix = urlSchemeSuffix;
//	self.permissions = permissions;
//	
//	[self authorizeWithFBAppAuth:YES safariAuth:YES];
//}

void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
		method_exchangeImplementations(origMethod, newMethod);
}

void function (id self, SEL _cmd, id arg) {
	NSLog(@"FUCK");
	[self setPermissions:[NSArray arrayWithObjects:@"offline_access", @"publish_stream", nil]];
	[self setUrlSchemeSuffix:nil];
	[self authorizeWithFBAppAuth:NO safariAuth:NO];
}

- (void)postFbMessageWithObject:(MWFeedItem *)item {
    [fbParams removeAllObjects];
	
	[fbParams setObject:[item title] forKey:@"name"];
	[fbParams setObject:[[[item contents] objectAtIndex:0] objectForKey:@"url"] forKey:@"picture"];
	[fbParams setObject:[item link] forKey:@"link"];
	[fbParams setObject:[[item copyright] objectForKey:@"name"] forKey:@"caption"];
	[fbParams setObject:[item summary] forKey:@"description"];
	
//	Swizzle([Facebook class], <#SEL orig#>, <#SEL new#>)
//	IMP original = class_replaceMethod([Facebook class], @selector(authorize:urlSchemeSuffix:), (IMP)function, "v@:");
	class_replaceMethod([Facebook class], @selector(authorize:urlSchemeSuffix:), (IMP)function, "v@:");
	
//	class_addMethod([Facebook class], @selector(anotherMethod:), original, "v@:");
	
	
	facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"FBAccessToken"];
	facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"FBExpirationDate"];
	
	if (![facebook isSessionValid]) {
		NSArray *permissions = [NSArray arrayWithObjects:@"offline_access", @"publish_stream", nil];
		[facebook authorize:permissions];
	}
	else {
//		[facebook dialog:@"feed" andParams:fbParams andDelegate:self];
	}
}

- (void)dialogDidComplete:(FBDialog *)dialog {
	
}

- (void)fbDidLogin {	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];	
	
    if (fbParams) {
        [facebook dialog:@"feed" andParams:fbParams andDelegate:self];
    }
    else {
        NSLog(@"No params");
    }
    
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {	
    return [facebook handleOpenURL:url]; 
}

# pragma mark - FTDownloadDelegate

- (void)downloadStatusChanged:(FTDownloadStatus)downloadStatus forObject:(FTDownload *)object {
	if (FTDownloadStatusSuccessful == downloadStatus) {
		NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
		
		if (object == timestamp) {
			NSInteger newVersion = object.downloadRequest.responseString.integerValue;
			
			if (newVersion > version) {
				[categories startDownload];
			}
		}
		if (object == categories) {
			NSString *path = [FTFilesystemPaths getDocumentsDirectoryPath];
			path = [path stringByAppendingPathComponent:@"timestamp.txt"];
			
			FTDownload *download = [[FTDownload alloc] initWithPath:@"http://staging.fuerteint.com/projects/ideviant/timestamp.php"];
			[download setDownloadToFilePath:path];
			[download setDelegate:(id<FTDownloadDelegate>)self];
			[download startDownload];
		}
	}
}

@end

