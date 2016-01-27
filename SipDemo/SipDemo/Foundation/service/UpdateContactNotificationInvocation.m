//
//  UpdateContactNotificationInvocation.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 19/09/14.
//
//


#import "UpdateContactNotificationInvocation.h"

@interface UpdateContactNotificationInvocation (private)

-(NSString*)body;

@end


@implementation UpdateContactNotificationInvocation
@synthesize contactId,notificationStatus;

-(void)invoke
{
    [self post:@"updateNotificationStatus" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.contactId forKey:@"contact_id"];
    [bodyD setObject:self.notificationStatus forKey:@"notification_status"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(updateContactNotificationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate updateContactNotificationInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(updateContactNotificationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate updateContactNotificationInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end