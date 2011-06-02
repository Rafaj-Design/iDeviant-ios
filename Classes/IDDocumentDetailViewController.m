//
//  IDDocumentDetailViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 30/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDDocumentDetailViewController.h"


@implementation IDDocumentDetailViewController


#pragma mark Memory management

- (void)dealloc {
	[wv release];
	[content release];
    [super dealloc];
}

#pragma mark Settings

- (void)setContent:(NSString *)text {
	[content release];
	content = text;
	[content retain];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	wv = [[UIWebView alloc] init];
	[self.view addSubview:wv];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[wv loadHTMLString:content baseURL:nil];
}

#pragma mark Layout

- (void)doLayoutSubviews {
	[wv setFrame:[super fullScreenFrame]];
}


@end
