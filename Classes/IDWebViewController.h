//
//  IDWebViewController.h
//  iDeviant
//
//  Created by Adam Horacek on 08.03.12.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "IDViewController.h"

@interface IDWebViewController :  IDViewController {
	NSMutableURLRequest *request;
}

@property (nonatomic, retain) NSMutableURLRequest *request;

@end
