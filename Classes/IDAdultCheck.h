//
//  IDAdultCheck.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 17/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IDAdultCheck : NSObject {
    
}

+ (void)checkForUnlock:(NSString *)unlockString;

+ (BOOL)canAccessAdultStuff;


@end
