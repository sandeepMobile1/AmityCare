//
//  CategoryOptionInvocation.m
//  SimpleAddiction
//
//  Created by Om Prakash on 12/26/13.
//  Copyright (c) 2013 Vinod Shau. All rights reserved.
//

#import "RegistrationInvocation.h"

@interface RegistrationInvocation (private)

-(NSString*)body;

@end


@implementation RegistrationInvocation
@synthesize userInfo;

-(void)invoke
{
    [self post:@"register" body:[self body]];
}

-(NSString*)body
{
    return [userInfo JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(registrationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate registrationInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(registrationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate registrationInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"LandingInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
