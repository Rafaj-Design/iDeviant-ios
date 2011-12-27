//
//  IDWebView.m
//  iDeviant
//
//  Created by Filip Kralik on 10/19/11.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "IDLoginController.h"

@implementation IDLoginController
@synthesize webView, nick, passwd, activInd;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activInd stopAnimating];  
}

- (void)webViewDidStartLoad:(UIWebView *)webView {   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [activInd startAnimating];     
}

-(void)viewDidAppear:(BOOL)animated{
    //show page https://www.deviantart.com/users/login in web view
    
    NSString *urlAddress = @"https://www.deviantart.com/users/login";
    NSString *body = [NSString stringWithFormat: @"username=%@&password=%@", nick,passwd];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding: NSUTF8StringEncoding]];
    
    
    
    //Load the request in the UIWebView.
    [webView loadRequest:request];
}

@end
