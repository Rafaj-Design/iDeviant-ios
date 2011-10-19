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
    [super viewDidLoad];
    //load nick and password to field
	NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:filePath];
        nick.text = [arr objectAtIndex:0];
        pass.text = [arr objectAtIndex:1];
        [arr release];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}



-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:kFileName];
}

-(IBAction)login:(id)sender{
    NSString *filePath = [self dataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = [[NSError alloc] init];
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

-(IBAction)removeLogin:(id)sender{
    nick.text = @"";
    pass.text = @"";
    
    NSString *filePath = [self dataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:NULL];
    
}

//hide keyboard
-(IBAction) backgroundtap:(id)sender{
    [nick resignFirstResponder];
    [pass resignFirstResponder];
}

@end
