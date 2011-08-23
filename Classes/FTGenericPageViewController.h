//
//  FTGenericPageViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDViewController.h"
#import "FTDynamicContentView.h"


@interface FTGenericPageViewController : IDViewController {
    
	FTDynamicContentView *contentView;
	
}

@property (nonatomic, retain) FTDynamicContentView *contentView;


@end
