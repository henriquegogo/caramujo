//
//  ViewController.m
//  HtmlNative
//
//  Created by Henrique Gogó on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navigationBar = [[UINavigationBar alloc] init];
    navigationItem = [[UINavigationItem alloc] init];
    navigationBar.items = [NSArray arrayWithObject:navigationItem];
    [self.view addSubview:navigationBar];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
    NSURL *url = [NSURL fileURLWithPath:indexPath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    [webView stringByEvaluatingJavaScriptFromString:@""
     "window.alert = function (message, title) {"
     "  title = title || 'Alert';"
     "  location.href = 'alert:' + title + ':' + encodeURI(message);"
     "};"

     "window.setTitle = function (title) {"
     "  location.href = 'title:' + encodeURI(title);"
     "};"];
    
    [webView stringByEvaluatingJavaScriptFromString:@""
     "window.onload = function() {"
     "  if (document.title) {"
     "    setTitle(document.title);"
     "  }"
     "};"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)webView:(UIWebView *)webViewRequest shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *method = [url scheme];
    NSArray *components = [[url absoluteString] componentsSeparatedByString:@":"];
    
    if ([method isEqual:@"alert"]) {        
        NSString *title = [[components objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *message = [[components objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        
        [alert show];
    }
    
    else if ([method isEqual:@"title"]) {
        NSString *title = [[components objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         
        webView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        navigationItem.title = title;
        
        if ([title isEqual:@""]) {
            webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        }
    }
}

@end
