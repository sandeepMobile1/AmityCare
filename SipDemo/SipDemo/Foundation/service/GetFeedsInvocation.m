//
//  GetFeedsInvocation.h
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "GetFeedsInvocation.h"
#import "AppDelegate.h"
#import "ConfigManager.h"

@interface GetFeedsInvocation (private)

-(NSString*)body;

@end


@implementation GetFeedsInvocation
@synthesize userid,tagId;
@synthesize lastIndex,roleId,timeLine;

-(void)invoke
{
   
    [self post:@"tag_post" body:[self body]];

}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userid forKey:@"user_id"];
    [bodyD setObject:sharedAppDelegate.strSelectedTagId forKey:@"tag_id"];
    [bodyD setObject:self.lastIndex forKey:@"index"];
    [bodyD setObject:self.roleId forKey:@"role_id"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    
   // [bodyD setObject:self.timeLine forKey:@"time"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(getFeedsInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getFeedsInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(getFeedsInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getFeedsInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"getFeedsInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
