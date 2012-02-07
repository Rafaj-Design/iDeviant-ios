//
//  IDDocumentDetailViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 30/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDViewController.h"


@interface IDDocumentDetailViewController : IDViewController <UIWebViewDelegate> {
	NSString *content; 
	UIWebView *webView;
}

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) UIWebView *webView;

@end
