//
//  UIColor+HexColor.m
//  SimpleAddiction
//
//  Created by Vijay Kumar on 03/01/14.
//  Copyright (c) 2014 Vinod Shau. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)


+ (UIColor *)colorFromHexString:(NSString *)hexString {
   
    NSString *string = @"";
    if([hexString rangeOfString:@"#"].length>0)
        string = hexString;
    else
        string = [NSString stringWithFormat:@"#%@",hexString];
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setScanLocation:1]; 
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

/*
 //NSString *stringColor = @"#AABBCC";
 
 NSUInteger red, green, blue;
 sscanf([@"#D5CFCA" UTF8String], "#%02X%02X%02X", &red, &green, &blue);
 
 UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
 OuterScrollView.backgroundColor = color;
 */

@end
