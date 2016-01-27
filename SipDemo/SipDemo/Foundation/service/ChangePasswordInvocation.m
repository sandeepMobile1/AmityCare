//
//  ChangePasswordInvocation.m
//  Amity-Care
//
//  Created by Om Prakash on 12/26/13.
//  Copyright (c) 2013 Vinod Shau. All rights reserved.
//

#import "ChangePasswordInvocation.h"

@interface ChangePasswordInvocation (private)

-(NSString*)body;

@end


@implementation ChangePasswordInvocation
@synthesize userInfo;

-(void)invoke
{
    [self post:@"change_password" body:[self body]];
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

    if([self.delegate respondsToSelector:@selector(changePasswordInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate changePasswordInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(changePasswordInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate changePasswordInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ChangePasswordInvocation" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
