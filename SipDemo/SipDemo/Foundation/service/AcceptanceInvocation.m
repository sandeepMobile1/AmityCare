//
//  AcceptanceInvocation.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 20/08/14.
//
//

#import "AcceptanceInvocation.h"

@interface AcceptanceInvocation (private)

-(NSString*)body;

@end


@implementation AcceptanceInvocation

@synthesize userID,memberID,status,contactId;

-(void)invoke
{
    [self post:@"contact_action" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:self.userID forKey:@"userId"];
    [bodyD setObject:self.memberID forKey:@"memberId"];
    [bodyD setObject:self.status forKey:@"status"];
    [bodyD setObject:self.contactId forKey:@"contactId"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
   // if([self.delegate respondsToSelector:@selector(userAcceptanceInvocationDidFinish:withResults:withError:)])
    //{
        [self.delegate userAcceptanceInvocationDidFinish:self withResults:resultsd withError:nil];
    //}
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(userAcceptanceInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate userAcceptanceInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
