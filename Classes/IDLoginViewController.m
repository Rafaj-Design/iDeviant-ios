//
//  IDLoginViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24/08/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "IDLoginViewController.h"

@implementation IDLoginViewController

@synthesize nick, pass, remember, rememberme;

#pragma mark View delegate methods

- (void)viewDidLoad {
	UIColor *color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
	UIImage *img = [UIImage imageNamed:@"DA_topbar.png"];
	[img drawInRect:CGRectMake(0, 0, 10, 10)];
	[self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setTintColor:color];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
	self.navigationItem.leftBarButtonItem = item;
	
    [self.nick setPlaceholder:[IDLang get:@"nickname"]];
    [self.pass setPlaceholder:[IDLang get:@"password"]];
    [self.rememberme setText:[IDLang get:@"rememberme"]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [super viewDidLoad];
    //load nick and password to field
	NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:filePath];
        nick.text = [arr objectAtIndex:0];
        pass.text = [arr objectAtIndex:1];
        [arr release];
    }
    
    [self.nick setDelegate:self];
    [self.nick setReturnKeyType:UIReturnKeyNext];
    [self.nick addTarget:self
                  action:@selector(nextTextField)
        forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.pass setDelegate:self];
    [self.pass setReturnKeyType:UIReturnKeyGo];
    [self.pass addTarget:self
				  action:@selector(login:)
		forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.nick.leftView = paddingView;
	[paddingView release];
    self.nick.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingViewpas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.pass.leftView = paddingViewpas;
	[paddingViewpas release];
    self.pass.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *image = [UIImage imageNamed:@"DD_login_bg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
}

-(void)nextTextField{
    [pass becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return NO;
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:kFileName];
}

-(IBAction)login:(id)sender{
    if ([self.nick.text length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[IDLang get:@"nicknull"] message:nil
                                                       delegate:self cancelButtonTitle:[IDLang get:@"OK"] otherButtonTitles:nil, nil];
        [alert show];
        
        [alert release];
    } else if ([self.pass.text length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[IDLang get:@"passwordnull"] message:nil
                                                       delegate:self cancelButtonTitle:[IDLang get:@"OK"] otherButtonTitles:nil, nil];
        [alert show];
        
        [alert release];
    } else {
		NSString *filePath = [self dataFilePath];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:filePath error:nil];
		
		NSString *urlAddress = @"https://www.deviantart.com/users/login";
		NSString *body = [NSString stringWithFormat: @"username=%@&password=%@", nick.text, pass.text];
		NSURL *url = [NSURL URLWithString:urlAddress];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:url];
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:[body dataUsingEncoding: NSUTF8StringEncoding]];
		
		UIViewController *c = [[UIViewController alloc] init];
		[c setTitle:@"Deviant Art"];
		
//		UIWebView *webView = [[UIWebView alloc] initWithFrame:[super fullScreenFrame]];
		UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
		[webView loadRequest:request];
		[request release];
		
		c.view = webView;
		[webView release];
		
		[self.navigationController pushViewController:c animated:YES];
		
		if (remember.on) {
			//save login
			NSArray *arr = [NSArray arrayWithObjects:nick.text, pass.text, nil];
			[arr writeToFile:[self dataFilePath] atomically:NO];
		}
    }
}

//hide keyboard
-(IBAction) backgroundtap:(id)sender{
    [nick resignFirstResponder];
    [pass resignFirstResponder];
}


- (void)done {
	[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
