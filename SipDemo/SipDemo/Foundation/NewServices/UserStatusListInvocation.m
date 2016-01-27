//
//  UserStatusListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "UserStatusListInvocation.h"


@interface UserStatusListInvocation (private)

-(NSString*)body;

@end

@implementation UserStatusListInvocation

@synthesize userid,tagId;
@synthesize lastIndex,roleId,timeLine;

-(void)invoke
{
    [self post:@"users_post_moods" body:[self body]];
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
    
    if([self.delegate respondsToSelector:@selector(UserStatusListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserStatusListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UserStatusListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserStatusListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UserStatusListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
