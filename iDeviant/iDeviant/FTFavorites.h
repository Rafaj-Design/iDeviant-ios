//
//  FTFavorites.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FTFavorites;

@protocol FTFavoritesDelegate <NSObject>

- (void)favorites:(FTFavorites *)favorites didRemoveCategory:(NSDictionary *)categoryData;

@end


@interface FTFavorites : NSObject

@property (nonatomic, weak) id <FTFavoritesDelegate> delegate;

+ (FTFavorites *)sharedFavorites;

+ (NSArray *)favorites;
+ (BOOL)isCategoryInFavorites:(NSDictionary *)category;
+ (void)addCategoryToFavorites:(NSDictionary *)category;
+ (void)removeCategoryFromFavorites:(NSDictionary *)category;


@end
