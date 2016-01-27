//
//  UserCalenderListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 13/10/14.
//
//

#import "UserCalenderListInvocation.h"

@interface UserCalenderListInvocation (private)

-(NSString*)body;

@end

@implementation UserCalenderListInvocation

@synthesize userId;

-(void)invoke
{
    [self post:@"calendar_user_task" body:[self body]];

}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(UserCalenderListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserCalenderListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UserCalenderListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserCalenderListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
