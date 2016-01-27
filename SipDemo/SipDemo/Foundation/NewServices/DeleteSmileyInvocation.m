//
//  DeleteSmileyInvocation.m
//  SipDemo
//
//  Created by Shweta Sharma on 16/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "DeleteSmileyInvocation.h"

@interface DeleteSmileyInvocation (private)

-(NSString*)body;

@end

@implementation DeleteSmileyInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"delete_smile_post" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteSmileyInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteSmileyInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteSmileyInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteSmileyInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteSmileyInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
