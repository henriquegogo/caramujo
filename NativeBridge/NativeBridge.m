//
//  NativeBridge.m
//  NativeBridge
//
//  Created by Henrique Gogó on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NativeBridge.h"

@implementation NativeBridge
+ (void)alert:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alert show];
}
+ (void)alert:(NSString *)message
{
    [self alert:message withTitle:@"Alert"];
}
+ (void)log
{
    NSLog(@"logou");
}

@end
