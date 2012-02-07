//
//  IDDocumentDetailViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 30/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDDocumentDetailViewController.h"


@implementation IDDocumentDetailViewController

@synthesize content;
@synthesize webView;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setFrame:[[UIScreen mainScreen] applicationFrame]];

	CGRect frame = self.view.frame;
	frame.origin.y = 0;
	self.view.frame = frame;
	
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	
	webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	[webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[webView setOpaque:NO];
	[webView setBackgroundColor:[UIColor clearColor]];
	[webView setDelegate:(id<UIWebViewDelegate>)self];
	
	for (UIView* subView in [webView subviews])
        if ([subView isKindOfClass:[UIScrollView class]])
            for (UIView* shadowView in [subView subviews])
                if ([shadowView isKindOfClass:[UIImageView class]])
                    [shadowView setHidden:YES];
	
	[self.view addSubview:webView];
	
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_bg-l"]]];
	else
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_bg-p"]]];

}

- (void)viewDidAppear:(BOOL)animated {
	
	NSMutableString *cnt = [[NSMutableString alloc] initWithString:content];
	
	[cnt replaceOccurrencesOfString:@"background-color:white;" withString:@"background-color:transparent;" options:NSLiteralSearch range:NSMakeRange(0, [cnt length])];
	[cnt replaceOccurrencesOfString:@"color:black;" withString:@"color:black;font-family:helvetica;" options:NSLiteralSearch range:NSMakeRange(0, [cnt length])];
	
	[webView loadHTMLString:cnt baseURL:nil];
	
	[cnt release];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_bg-l"]]];
	else
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_bg-p"]]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark Memory management

- (void)dealloc {
	[content release];
	[webView release];
	
    [super dealloc];
}
@end
