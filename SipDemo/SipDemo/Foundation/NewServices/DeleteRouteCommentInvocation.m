//
//  DeleteRouteCommentInvocation.m
//  SipDemo
//
//  Created by Octal on 20/08/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "DeleteRouteCommentInvocation.h"

@interface DeleteRouteCommentInvocation (private)

-(NSString*)body;

@end

@implementation DeleteRouteCommentInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"rootcomment_delete" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteRouteCommentInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteRouteCommentInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteRouteCommentInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteRouteCommentInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteRouteCommentInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
