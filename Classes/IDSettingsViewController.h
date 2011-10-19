//
//  IDSettingsViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSettingsViewController.h"

#define kFileName @"archive"
#define kDataName @"Data"

@interface IDSettingsViewController : UIViewController {
    UITextField *nick;
    UITextField *pass;
    UIButton *login;
    UISwitch *remember;
}

@property (nonatomic, retain) IBOutlet UITextField *nick;
@property (nonatomic, retain) IBOutlet UITextField *pass;
@property (nonatomic, retain) IBOutlet UISwitch *remember;

-(IBAction)login:(id)sender;
-(IBAction)backgroundtap:(id)sender;
-(IBAction)removeLogin:(id)sender;
-(NSString *)dataFilePath;


@end
