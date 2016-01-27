//
//  LoginInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "ForgotPasswordInvocation.h"

@interface ForgotPasswordInvocation (private)

-(NSString*)body;

@end


@implementation ForgotPasswordInvocation
@synthesize email;

-(void)invoke
{
    [self post:@"forgot_password" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:email forKey:@"email"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(forgotPasswordInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate forgotPasswordInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(forgotPasswordInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate forgotPasswordInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"forgotPasswordInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
