//
//  UserFeedListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "UserFeedListInvocation.h"

@interface UserFeedListInvocation (private)

-(NSString*)body;

@end

@implementation UserFeedListInvocation

@synthesize userid,tagId;
@synthesize lastIndex,roleId,timeLine;

-(void)invoke
{
    [self post:@"users_post" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:self.userid forKey:@"user_id"];
    [bodyD setObject:self.lastIndex forKey:@"index"];
    [bodyD setObject:self.roleId forKey:@"role_id"];
    [bodyD setObject:self.timeLine forKey:@"time"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(UserFeedListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserFeedListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UserFeedListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserFeedListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UserFeedListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
