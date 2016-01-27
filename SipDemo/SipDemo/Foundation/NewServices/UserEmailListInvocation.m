//
//  UserEmailListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "UserEmailListInvocation.h"

@interface UserEmailListInvocation (private)

-(NSString*)body;

@end

@implementation UserEmailListInvocation

@synthesize user_id;

-(void)invoke
{
    [self post:@"user_inbox" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:user_id forKey:@"user_id"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(UserEmailListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserEmailListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UserEmailListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserEmailListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UserEmailListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
