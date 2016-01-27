//
//  Utils.m
//  FogoChannel1
//
//  Created by I phone octal on 02/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void) showAlertMessage:(NSString *)title Message:(NSString *)msg {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

+(UIImage*) resizeImage:(UIImage*) image size:(CGSize) size {
	if (image.size.width != size.width || image.size.height != size.height) {
		UIGraphicsBeginImageContext(size);
		CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
		[image drawInRect:imageRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return image;
}

//DeviceTokenDetails 
static NSString *deviceDtls;
+(void)setDeviceDetails:(NSString *)deviceDetails{
	deviceDtls = [[NSString alloc]init ];
    deviceDtls = [deviceDetails copy];
}

+(NSString *)getDeviceDetails{
	return deviceDtls;
}

static NSMutableDictionary *userDtls;
+(void)setUserDetails:(NSMutableDictionary *)userDetails{
    userDtls = [[NSMutableDictionary alloc]init ];
    userDtls = [userDetails copy];
    
}

+(NSMutableDictionary *)getUserDetails{
    return userDtls;
    
}

+(BOOL)stringContainsEmoji:(NSString*)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}

+(BOOL)stringContainsSpecialCharacters:(NSString*)string
{
    NSString *specialCharacterString = @"~@#$%^*+();:={}[]<>?\\/\"\\";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    
    if ([string.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        return TRUE;
    }
    return FALSE;
}

@end
