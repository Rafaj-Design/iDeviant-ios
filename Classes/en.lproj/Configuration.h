//
//  Configuration.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//



// Development
#define kDebug												YES
#define kFakeData											NO

#define kDebugCauseCrash									YES

#define kSystemJiraErrorReporting							@"http://jira-mobile.fuerteint.com:8080"


// System configuration
#define kSystemApplicationId								0
#define kSystemApplicationAppStoreUrl						@"http://itunes.apple.com/gb/app/ideviant/id355122830?mt=8"


#define kSystemApiRaterDebug								NO
#define kSystemApiRaterEnabled								YES
#define kSystemApiRaterDaysUntilPrompt						2
#define kSystemApiRaterSessionsUntilPrompt					2


// Tracking
#define kSystemTrackingFlurryEnableTracking					YES
#define kSystemTrackingFlurryAPICode						@"1267caee8ed3726c1683a6323e9d19d5"


// Database configuration
#define kSystemFavoritesDbName								@"kSystemFavoritesDbName"
#define kSystemHistoryDbName								@"kSystemHistoryDbName"
#define kSystemHomeMenuDbName								@"kSystemHomeMenuDbName"