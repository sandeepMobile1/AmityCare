//
//  DeleteOcrInvocation.m
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "DeleteOcrInvocation.h"

@interface DeleteOcrInvocation (private)

-(NSString*)body;

@end

@implementation DeleteOcrInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"delete_ocr" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteOcrInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteOcrInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteOcrInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteOcrInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteOcrInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
