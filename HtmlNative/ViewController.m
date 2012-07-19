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

UIWebView *webView;
UINavigationBar *navigationBar;
UINavigationItem *navigationItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navigationBar = [[UINavigationBar alloc] init];
    navigationItem = [[UINavigationItem alloc] init];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
     "window.nativebridge = function(method) {"
     "  var args = [];"
     "  for (var i = 1; i < arguments.length; i++) {"
     "      var item = encodeURI(arguments[i]);"
     "      args.push(item);"
     "  }"
     "  location.href = method + ':' + args.join(':');"
     "};"
     
     "window.alert = function (message, title) {"
     "  title = title || 'Alert';"
     "  nativebridge('alert', title, message);"
     "};"
     
     "window.showTitle = function () {"
     "  nativebridge('showtitle');"
     "};"
     
     "window.hideTitle = function () {"
     "  nativebridge('hidetitle');"
     "};"
     
     "window.setTitle = function (title) {"
     "  nativebridge('title', title);"
     "};"
     ];
    
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
        NSLog(@"Alertou");
        NSString *title = [[components objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *message = [[components objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        
        [alert show];
    }
    
    else if ([method isEqual:@"title"]) {
        NSLog(@"Setou o título");
        NSString *title = [[components objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        webView.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        navigationItem.title = title;
    }
    
    else if ([method isEqual:@"showtitle"]) {       
        NSLog(@"Mostrou o título");
        webView.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    }
    
    else if ([method isEqual:@"hidetitle"]) {
        NSLog(@"Escondeu o título");
        webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    }
}

@end
