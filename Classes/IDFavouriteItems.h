//
//  IDFavouriteItems.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 29/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedItem.h"

@interface IDFavouriteItems : NSObject {
    
}

+ (BOOL)isFavouriteItem:(MWFeedItem *)item;

+ (void)toggleIsFavouriteItem:(MWFeedItem *)item;

//+ (NSMutableDictionary *)dictionaryDataForFavorites;

+ (NSArray *)dataForFavorites;


@end
