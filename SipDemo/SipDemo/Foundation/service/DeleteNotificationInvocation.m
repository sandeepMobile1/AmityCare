//
//  GetProfileInvocation.m
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "DeleteNotificationInvocation.h"

@interface DeleteNotificationInvocation (private)

-(NSString*)body;

@end


@implementation DeleteNotificationInvocation
@synthesize user_id;
@synthesize n_id;

-(void)invoke
{
    [self post:@"notification_delete" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bDict = [[NSMutableDictionary alloc] init];
    [bDict setObject:self.user_id forKey:@"user_id"];
    [bDict setObject:self.n_id forKey:@"notification_id"];
    return [bDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(deleteNotificationDidFinish:withResults:withError:)])
    {
        [self.delegate deleteNotificationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(deleteNotificationDidFinish:withResults:withError:)])
    {
        [self.delegate deleteNotificationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"deleteNotificationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
