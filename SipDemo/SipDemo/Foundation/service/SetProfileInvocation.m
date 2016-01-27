//
//  SetProfileInvocation.m
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "SetProfileInvocation.h"

@interface SetProfileInvocation (private)

-(NSString*)body;

@end


@implementation SetProfileInvocation
@synthesize userInfo;
@synthesize imageData;


-(void)invoke
{
    //[self post:@"set_profile" body:[self body]];
    [self executeBinary:@"POST" withDictData:userInfo attachment:imageData];
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

    if([self.delegate respondsToSelector:@selector(setProfileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate setProfileInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(setProfileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate setProfileInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"setProfileInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
