//
//  IDFavouriteCategories.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 29/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IDFavouriteCategories : NSObject {
    
}

+ (BOOL)isFavouriteCategory:(NSString *)stringPath;

+ (void)toggleIsFavouriteCategory:(NSString *)stringPath withCategoryData:(NSDictionary *)data;

+ (NSMutableDictionary *)dictionaryDataForFavorites;

+ (NSArray *)dataForFavorites;

+ (void)cacheAllFavoriteCategories;


@end
