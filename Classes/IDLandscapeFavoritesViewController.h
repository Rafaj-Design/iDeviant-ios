//
//  IDLandscapeFavoritesViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"
#import "FTPagesScrollView.h"


@interface IDLandscapeFavoritesViewController : FTViewController <FTPagesScrollViewDelegate, FTPagesScrollViewDataSource> {
    
	FTPagesScrollView *galleryScrollView;
	
}

@end
