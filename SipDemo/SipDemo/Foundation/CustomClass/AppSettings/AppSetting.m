//
//  AppSetting.m
//  RoboFoto
//
//  Created by Om Prakash on 1/15/14.
//  Copyright (c) 2014 Vijay Kumar. All rights reserved.
//

#import "AppSetting.h"

@implementation AppSetting



+(NSString *)plist_dict{
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AppSettings.plist"];
    return  plistPath;
}

+(void)setLastLoginTime:(NSString*)login;
{
   
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    if(plist_dict == nil)
    {
        plist_dict = [[NSMutableDictionary alloc] init];
    }
    
    NSString *str_angle = [NSString stringWithFormat:@"%@",login];
    [plist_dict setObject:str_angle forKey:@"LastLoginTime"];
    [plist_dict writeToFile:path atomically:YES];

    
}

+(NSString*)getLastLoginTime{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSString *str_val = [plist_dict valueForKey:@"LastLoginTime"];
    return str_val ;
}


+(void)setPasswordChnageTime:(NSString*)login;
{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    if(plist_dict == nil)
    {
        plist_dict = [[NSMutableDictionary alloc] init];
    }
    
    NSString *str_angle = [NSString stringWithFormat:@"%@",login];
    [plist_dict setObject:str_angle forKey:@"LastPasswordChangeTime"];
    [plist_dict writeToFile:path atomically:YES];
    
    
}

+(NSString*)getLastPasswordChnageTime{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSString *str_val = [plist_dict valueForKey:@"LastPasswordChangeTime"];
    return str_val ;
}


+(void)setTime:(int)time{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    if(plist_dict == nil)
    {
        plist_dict = [[NSMutableDictionary alloc] init];
    }
    NSString *str_time = [NSString stringWithFormat:@"%d",time];
    [plist_dict setObject:str_time forKey:@"time"];
    [plist_dict writeToFile:path atomically:YES];

}

+(int)getTime{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSString *str_val = [plist_dict valueForKey:@"time"];
    return [str_val intValue];
}
+(void)appResetAngle:(int)angle time:(int)time{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    if(plist_dict == nil)
    {
        plist_dict = [[NSMutableDictionary alloc] init];
    }
    NSString *str_angle = [NSString stringWithFormat:@"%d",angle];
    [plist_dict setObject:str_angle forKey:@"angle"];
    
    NSString *str_time = [NSString stringWithFormat:@"%d",time];
    [plist_dict setObject:str_time forKey:@"time"];
    [plist_dict writeToFile:path atomically:YES];

}

+(void)setRateAppStatus{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    [plist_dict setValue:@"1" forKey:@"isRateApp"];
    [plist_dict writeToFile:path atomically:YES];
}

+(BOOL)getRateAppStatus{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSString *str_val = [plist_dict valueForKey:@"isRateApp"];
    return [str_val boolValue];
}

+(void)setRateAppStatusLoopCount:(int)value{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    [plist_dict setValue:[NSNumber numberWithInt:value] forKey:@"loopCount"];
    [plist_dict writeToFile:path atomically:YES];
}

+(int)getRateAppStatusLoopCount{
    
    NSString *path = [AppSetting plist_dict];
    NSMutableDictionary *plist_dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSString *str_val = [plist_dict valueForKey:@"loopCount"];
    return [str_val intValue];
}

@end
