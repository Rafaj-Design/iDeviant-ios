//
//  IDSettingsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDSettingsViewController.h"
#import "IDLoginController.h"

@implementation IDSettingsViewController
@synthesize nick, pass, remember;

#pragma mark View delegate methods

- (void)viewDidLoad {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [super viewDidLoad];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:kFileName];
}

-(IBAction)login:(id)sender{
    NSString *filePath = [self dataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    IDLoginController *webView = [[IDLoginController  alloc] initWithNibName:@"IDLoginController" bundle:nil];
    webView.nick = nick.text;
    webView.passwd = pass.text;
    [self.navigationController pushViewController:webView animated:YES];
    [webView release]; 
    
    if (remember.on) {
        //save login
        NSArray *arr = [NSArray arrayWithObjects:nick.text, pass.text, nil];
        [arr writeToFile:[self dataFilePath] atomically:NO];
    }

}

//hide keyboard
-(IBAction) backgroundtap:(id)sender{
    [nick resignFirstResponder];
    [pass resignFirstResponder];
}

@end
