//
//  AddRouteCommentInvocation.m
//  SipDemo
//
//  Created by Octal on 14/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "AddRouteCommentInvocation.h"

@interface AddRouteCommentInvocation (private)

-(NSString*)body;

@end

@implementation AddRouteCommentInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"add_comment_root" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AddRouteCommentInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddRouteCommentInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AddRouteCommentInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddRouteCommentInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AddRouteCommentInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
