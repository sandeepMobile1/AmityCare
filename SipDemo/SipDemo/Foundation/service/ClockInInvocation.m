//
//  ClockInInvocation.m
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "ClockInInvocation.h"

@interface ClockInInvocation (private)

-(NSString*)body;

@end

@implementation ClockInInvocation

@synthesize userInfo;

-(void)invoke
{
    [self post:@"clock_in" body:[self body]];
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

    if([self.delegate respondsToSelector:@selector(clockInInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate clockInInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(clockInInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate clockInInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"clockInInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
