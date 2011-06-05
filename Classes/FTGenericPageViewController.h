//
//  FTGenericPageViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"
#import "FTDynamicContentView.h"


@interface FTGenericPageViewController : FTViewController {
    
	FTDynamicContentView *contentView;
	
}

@property (nonatomic, retain) FTDynamicContentView *contentView;


@end
