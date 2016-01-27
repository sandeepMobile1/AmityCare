//
//  LogoutInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "LogoutInvocation.h"
#import "ConfigManager.h"

@interface LogoutInvocation (private)

-(NSString*)body;

@end


@implementation LogoutInvocation
@synthesize userId;

-(void)invoke
{
    [self post:@"logout" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:userId forKey:@"user_id"];
    [bodyD setObject:gDeviceToke forKey:@"device_token"];

    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(logoutInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate logoutInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(logoutInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate logoutInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"logoutInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
