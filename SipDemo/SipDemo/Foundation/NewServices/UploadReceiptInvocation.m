//
//  UploadReceiptInvocation.m
//  SipDemo
//
//  Created by Octal on 03/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "UploadReceiptInvocation.h"

@interface UploadReceiptInvocation (private)

-(NSString*)body;

@end

@implementation UploadReceiptInvocation

@synthesize mdata;
@synthesize dict;

-(void)invoke
{
    [self executeBinary:@"POST" withDictData:dict attachment:mdata];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    NSLog(@"UploadDocInvocation =%@",resultString);
    if([self.delegate respondsToSelector:@selector(UploadReceiptInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UploadReceiptInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UploadReceiptInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UploadReceiptInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"uploadDocInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
