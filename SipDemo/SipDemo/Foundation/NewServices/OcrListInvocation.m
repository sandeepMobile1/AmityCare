//
//  OcrListInvocation.m
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "OcrListInvocation.h"

@interface OcrListInvocation (private)

-(NSString*)body;

@end

@implementation OcrListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"ocr_list" body:[self body]];
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
    
    if([self.delegate respondsToSelector:@selector(OcrListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate OcrListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(OcrListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate OcrListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"OcrListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
