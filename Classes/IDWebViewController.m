//
//  IDWebViewController.m
//  iDeviant
//
//  Created by Adam Horacek on 08.03.12.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "IDWebViewController.h"

@implementation IDWebViewController

@synthesize request;

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	[webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[webView loadRequest:request];
	[request release];
	[self.view addSubview:webView];
	[webView release];
	[self.navigationItem setHidesBackButton:YES];
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
	[self.navigationItem setLeftBarButtonItem:button];
	[button release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)popToRoot {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
	
}

@end
