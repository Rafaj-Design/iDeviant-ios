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
#import "FlurryAPI.h"
#import "Appirater.h"
#import "IGABuildChecks.h"
#import "ASIDownloadCache.h"
#import "JCO.h"


@implementation iDeviantAppDelegate

@synthesize window;
@synthesize facebook;


#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Build checks
	if (kDebug) {
		[IGABuildChecks perform];
	}
	
	// starting Flurry tracking
	if (kSystemTrackingFlurryEnableTracking) {
		if (kDebug && [kSystemTrackingFlurryAPICode isEqualToString:@"app-code-here"]) NSLog(@"Configuration error: Please check Flurry API code!"); 
		[FlurryAPI startSession:kSystemTrackingFlurryAPICode];
		
		// Track information about language
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
		NSString *currentLanguage = [languages objectAtIndex:0];
		
		[FlurryAPI logEvent:[NSString stringWithFormat:@"Locale id: %@", [[NSLocale currentLocale] localeIdentifier]]];
		[FlurryAPI logEvent:[NSString stringWithFormat:@"Current language: : %@", currentLanguage]];
	}
	
	// Starting AppiRater
	if (kSystemApiRaterDebug || kSystemApiRaterEnabled) {
		[Appirater appLaunched];
	}
	
	facebook = [[Facebook alloc] initWithAppId:@"118349561582677"];
	
    // Override point for customization after application launch you bloody maggots.
	IDHomeController *c = [[IDHomeController alloc] init];
	navigationController = [[FTNavigationViewController alloc] initWithRootViewController:c];
	[c release];
    
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	
	// Jira bug tracking system
	[[JCO instance] configureJiraConnect:@"http://jira.fuerteint.com:8080" customDataSource:nil];
	
	// Clear cache
	[[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {	
    return [facebook handleOpenURL:url]; 
}

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
	[FTLang printLanguageDebug];
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
	[FTLang printLanguageDebug];
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


@end

