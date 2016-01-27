//
//  GetProfileInvocation.m
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "GetNotificationInvocation.h"

@interface GetNotificationInvocation (private)

-(NSString*)body;

@end


@implementation GetNotificationInvocation
@synthesize user_id,page_index;

-(void)invoke
{
    [self post:@"user_notifications" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bDict = [[NSMutableDictionary alloc] init];
    [bDict setObject:self.user_id forKey:@"user_id"];
    [bDict setObject:self.page_index forKey:@"index"];

    return [bDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(getNotificationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getNotificationInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(getNotificationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getNotificationInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"getNotificationInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
