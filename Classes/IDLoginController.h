//
//  IDWebView.h
//  iDeviant
//
//  Created by Filip Kralik on 10/19/11.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//



@interface IDLoginController : UIViewController<UIWebViewDelegate> {
    UIWebView *webView;
    UIActivityIndicatorView *activInd;
    
    NSString *nick;
    NSString *passwd;
}


@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *nick;
@property (nonatomic, retain) NSString *passwd;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activInd;

@end
