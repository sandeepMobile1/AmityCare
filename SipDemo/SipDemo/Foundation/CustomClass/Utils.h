//
//  Utils.h
//  FogoChannel1
//
//  Created by I phone octal on 02/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utils : NSObject {

}

+ (void) showAlertMessage:(NSString *)title Message:(NSString *)msg;
+(UIImage*) resizeImage:(UIImage*) image size:(CGSize) size;

//DeviceTokenDetails 
+(void)setDeviceDetails:(NSString *)deviceDtls;
+(NSString *)getDeviceDetails;

//UserDetails 
+(void)setUserDetails:(NSMutableDictionary *)userDetails;
+(NSMutableDictionary *)getUserDetails;

//String validation
+(BOOL)stringContainsEmoji:(NSString*)string;
+(BOOL)stringContainsSpecialCharacters:(NSString*)string;
@end
