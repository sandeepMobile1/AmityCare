//
//  AppSetting.h
//  RoboFoto
//
//  Created by Om Prakash on 1/15/14.
//  Copyright (c) 2014 Vijay Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSetting : NSObject
+(void)setLastLoginTime:(NSString*)login;
+(NSString*)getLastLoginTime;

+(void)setPasswordChnageTime:(NSString*)login;
+(NSString*)getLastPasswordChnageTime;

+(void)setTime:(int)time;
+(int)getTime;

+(void)appResetAngle:(int)angle time:(int)time;

+(void)setRateAppStatus;
+(BOOL)getRateAppStatus;

+(void)setRateAppStatusLoopCount:(int)value;
+(int)getRateAppStatusLoopCount;

@end
