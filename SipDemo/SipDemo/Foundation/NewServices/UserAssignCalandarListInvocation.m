//
//  UserAssignCalandarListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 30/12/14.
//
//

#import "UserAssignCalandarListInvocation.h"
#import "AppDelegate.h"

@interface UserAssignCalandarListInvocation (private)

-(NSString*)body;

@end

@implementation UserAssignCalandarListInvocation

@synthesize userId;

-(void)invoke
{
    [self post:@"assign_task" body:[self body]];
    
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    [bodyD setObject:sharedAppDelegate.userObj.role forKey:@"role"];

    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(UserAssignCalandarListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserAssignCalandarListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UserAssignCalandarListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserAssignCalandarListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UserAssignCalandarListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
