//
//  NativeBridge.h
//  NativeBridge
//
//  Created by Henrique Gogó on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NativeBridge : NSObject
+ (void)alert:(NSString *)message withTitle:(NSString *)title;
+ (void)alert:(NSString *)message;
+ (void)log;

@end
