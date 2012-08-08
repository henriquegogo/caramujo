//
//  MainViewController.m
//  NativeBridge
//
//  Created by Henrique Gogó on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "NativeBridge.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Start View";

    UIWebView *webView = self.createWebView;
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"Assets"];
    NSURL *url = [NSURL fileURLWithPath:indexPath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    
    [webView loadRequest:requestObj];
    [self.view addSubview:webView];
}

- (UIWebView *)createWebView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    if (self.navigationController.navigationBarHidden)
    {
        navigationBarHeight = 0;
    }
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight)];
    
    return webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // native://method#parameters
    NSURL *url = [request URL];
    NSString *protocol = [url scheme];
    NSString *method = [[NSString alloc] initWithFormat:@"%@:", [url host]];
    NSString *paramsObject = [url.fragment stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    if (![protocol isEqualToString:@"native"]) {
        return YES;
    }
    
    [NativeBridge performSelector:NSSelectorFromString(method) withObject:paramsObject];
    return NO;
}

@end
