//
//  LoginInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "LoginInvocation.h"
#import "ConfigManager.h"
#import "AppDelegate.h"

@interface LoginInvocation (private)

-(NSString*)body;

@end


@implementation LoginInvocation
@synthesize email;
@synthesize password;
@synthesize token;

-(void)invoke
{
    [self post:@"login" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.email forKey:@"email"];
    [bodyD setObject:self.password forKey:@"password"];
    [bodyD setObject:self.token forKey:@"device_token"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];

    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"Login Response %@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(loginInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate loginInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    NSLog(@"Login Response Error Code %ld",(long)code);
    
    if([self.delegate respondsToSelector:@selector(loginInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate loginInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"loginInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed.Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
