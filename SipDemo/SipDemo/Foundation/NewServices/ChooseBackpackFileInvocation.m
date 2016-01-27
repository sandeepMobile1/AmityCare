//
//  ChooseBackpackFileInvocation.m
//  SipDemo
//
//  Created by Om Prakash on 14/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "ChooseBackpackFileInvocation.h"

@interface ChooseBackpackFileInvocation (private)

-(NSString*)body;

@end

@implementation ChooseBackpackFileInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"get_attachement" body:[self body]];
    
}

-(NSString*)body
{
    return [dict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(ChooseBackpackFileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ChooseBackpackFileInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ChooseBackpackFileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ChooseBackpackFileInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ChooseBackpackFileInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}



@end
