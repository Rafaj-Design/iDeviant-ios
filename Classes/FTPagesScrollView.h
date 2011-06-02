//
//  FTPagesScrollView.h
//  FTLibrary
//
//  Created by Tim Storey on 27/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FTPagesScrollView;

@protocol FTPagesScrollViewDelegate <NSObject>

@optional

- (void)galleryScrollView:(FTPagesScrollView *)gallery turnedToPage:(int)index;

@end


@protocol FTPagesScrollViewDataSource <NSObject>

- (UIView *)galleryScrollView:(FTPagesScrollView *)gallery requestsPageAtIndex:(int)index;

- (int)numberOfPagesForGalleryScrollView:(FTPagesScrollView *)gallery;

@end


@interface FTPagesScrollView : UIScrollView <UIScrollViewDelegate> {
    
    int _numberOfPagesToPreloadOnEachSide;
	
    NSMutableArray *galleryCache;
    
    id <FTPagesScrollViewDelegate> galleryDelegate;
    id <FTPagesScrollViewDataSource> galleryDataSource;
    
    int currentPageIndex;
	
	BOOL isDebugMode;
	UILabel *debugLabel;
    
}

@property (nonatomic) int numberOfPagesToPreloadOnEachSide;

@property (nonatomic, assign) id <FTPagesScrollViewDelegate> galleryDelegate;
@property (nonatomic, assign) id <FTPagesScrollViewDataSource> galleryDataSource;

@property (nonatomic, readonly) int currentPageIndex;

@property (nonatomic) BOOL debugMode; 


- (void)goToPage:(int)index animated:(BOOL)animated;

- (void)goToPage:(int)index;

- (void)loadContent;


@end
