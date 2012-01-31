//
//  IDLoginViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24/08/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "IDViewController.h"

#define kFileName @"archive"
#define kDataName @"Data"

@interface IDLoginViewController : IDViewController <UITextFieldDelegate> {
    UITextField *nick;
    UITextField *pass;
    UIButton *login;
    UISwitch *remember;
    UILabel *rememberme;
}

@property (nonatomic, retain) IBOutlet UITextField *nick;
@property (nonatomic, retain) IBOutlet UITextField *pass;
@property (nonatomic, retain) IBOutlet UISwitch *remember;
@property (nonatomic, retain) IBOutlet UILabel *rememberme;
-(IBAction)login:(id)sender;
-(IBAction)backgroundtap:(id)sender;
-(NSString *)dataFilePath;
-(void)nextTextField;

@end
