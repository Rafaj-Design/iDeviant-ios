//
//  iDeviantAppDelegate.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import "iDeviantAppDelegate.h"
#import "IDHomeController.h"
#import "IDConfig.h"
//#import "FlurryAPI.h"
#import "Appirater.h"
#import "IGABuildChecks.h"
#import "ASIDownloadCache.h"
//#import "JCO.h"

//#import "FBConnect.h"

#import <objc/runtime.h> 
#import <objc/message.h>

#import "MWFeedItem.h"

#import "FTDataJson.h"
#import "FTDownload.h"

#import "FTFilesystemIO.h"
#import "FTFilesystemPaths.h"

#import "IDImageDetailViewController.h"

static NSString* kAppId = @"118349561582677";

@implementation iDeviantAppDelegate

@synthesize window;
@synthesize navigationController;

@synthesize facebook;
@synthesize fbParams;

@synthesize timestamp, categories;
@synthesize version;

#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setBackgroundColor:[UIColor blackColor]];

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
	[timestamp setDelegate:(id<FTDownloadDelegate>)self];
	[timestamp startDownload];
	
	path = [path stringByDeletingLastPathComponent];
	
	path = [path stringByAppendingPathComponent:@"categories.json"];

	categories = [[FTDownload alloc] initWithPath:@"http://staging.fuerteint.com/projects/ideviant/categories.txt"];
	[categories setDownloadToFilePath:path];
	[categories setDelegate:(id<FTDownloadDelegate>)self];
	
	if (kSystemApiRaterDebug || kSystemApiRaterEnabled) {
		[Appirater appLaunched];
	}
		
	facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:(id<FBSessionDelegate>)self];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
	
//	if (![facebook isSessionValid]) {
//		[facebook authorize:nil];
//	}
	
	
	fbParams = [[NSMutableDictionary alloc] init];
		
    // Override point for customization after application launch you bloody maggots.
	IDHomeController *c = [[IDHomeController alloc] init];
	navigationController = [[FTNavigationViewController alloc] initWithRootViewController:c];
	[c release];
	
	
    
    // Add the navigation controller's view to the window and display.

	[window setRootViewController:navigationController];
    [window makeKeyAndVisible];
	
	// Jira bug tracking system
	//[[JCO instance] configureJiraConnect:kSystemJiraErrorReporting customDataSource:nil];
	
	// Clear cache
	[[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
	NSInteger i = [[[self navigationController] viewControllers] count];
	if (i > 0)
		i -= 1;
	
	if ([[[[self navigationController] viewControllers] objectAtIndex:i] class] == [IDImageDetailViewController class]) {
		NSLog(@"hojreka");
		//tuduuuuuuuuu when you return to IDImageDet.. and there is no statusbar it positions navbar to 0.0... instead 0.20..
//		[(IDImageDetailViewController *)[[[self navigationController] viewControllers] objectAtIndex:i] toggleNavigationVisibility]; 
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	//[IDLang printLanguageDebug];
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Clear cache
	[[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
		
	NSInteger i = [[[self navigationController] viewControllers] count];
	if (i > 0)
		i -= 1;
	
	if ([[[[self navigationController] viewControllers] objectAtIndex:i] class] == [IDImageDetailViewController class]) {
		NSLog(@"hojreka");
		//tuduuuuuuuuu when you return to IDImageDet.. and there is no statusbar it positions navbar to 0.0... instead 0.20..
//		[(IDImageDetailViewController *)[[[self navigationController] viewControllers] objectAtIndex:i] toggleNavigationVisibility];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	//[IDLang printLanguageDebug];
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
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

- (NSString *)urlForItem:(MWFeedItem *)item {
	
	NSString *contentUrl = [[item.contents objectAtIndex:0] objectForKey:@"url"];
	NSString *extension = [[contentUrl pathExtension] lowercaseString];
	
	if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpeg"] || [extension isEqualToString:@"jpg"]) {
		return [[item.contents objectAtIndex:0] objectForKey:@"url"];
	} else {
		return [[item.thumbnails objectAtIndex:0] objectForKey:@"url"];
	}
}

- (void)postFbMessageWithObject:(MWFeedItem *)item {
	
	
	
    [fbParams removeAllObjects];
	
	[fbParams setObject:[item title] forKey:@"name"];
	[fbParams setObject:[self urlForItem:item] forKey:@"picture"];
	[fbParams setObject:[item link] forKey:@"link"];
	[fbParams setObject:[[item copyright] objectForKey:@"name"] forKey:@"caption"];
	[fbParams setObject:[item summary] forKey:@"description"];	
	
	if (![facebook isSessionValid]) {
		NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream", nil];
		[facebook authorize:permissions];
		[permissions release];
	} else {
		[facebook dialog:@"stream.publish" andParams:fbParams andDelegate:self];
	}
}

- (void)dialogDidComplete:(FBDialog *)dialog {
	
}

- (void)fbDidLogin {	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
	[facebook dialog:@"stream.publish" andParams:fbParams andDelegate:self];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {	
    return [facebook handleOpenURL:url]; 
}

# pragma mark - FTDownloadDelegate

- (void)downloadStatusChanged:(FTDownloadStatus)downloadStatus forObject:(FTDownload *)object {
	if (FTDownloadStatusSuccessful == downloadStatus) {
//		NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
		
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

