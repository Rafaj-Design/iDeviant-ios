//
//  IDDocumentDetailViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 30/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"


@interface IDDocumentDetailViewController : FTViewController <UIWebViewDelegate> {
    
	UIWebView *wv;
	
	NSString *content;
	
}

- (void)setContent:(NSString *)text;

@end
