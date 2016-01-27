//
//  ClockInInvocation.m
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "CallNotifierInvocation.h"

@interface CallNotifierInvocation (private)

-(NSString*)body;

@end


@implementation CallNotifierInvocation
@synthesize userInfo;

-(void)invoke
{
    [self post:@"notification_call_delete" body:[self body]];
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

    if([self.delegate respondsToSelector:@selector(callNotifierInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate callNotifierInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(callNotifierInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate callNotifierInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"callNotifierInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
