//
//  RouteCommentListInvocation.m
//  SipDemo
//
//  Created by Octal on 17/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "RouteCommentListInvocation.h"

@interface RouteCommentListInvocation (private)

-(NSString*)body;

@end

@implementation RouteCommentListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"rootComment" body:[self body]];
    
}

-(NSString*)body
{
    return [dict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(RouteCommentListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate RouteCommentListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(RouteCommentListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate RouteCommentListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"RouteCommentListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
