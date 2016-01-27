//
//  DeleteAllTagNotificationInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/12/14.
//
//

#import "DeleteAllTagNotificationInvocation.h"

@interface DeleteAllTagNotificationInvocation (private)

-(NSString*)body;

@end

@implementation DeleteAllTagNotificationInvocation

@synthesize userId,tagId;

-(void)invoke
{
    
    [self post:@"tag_notification_deleteAll" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:userId forKey:@"user_id"];
    [bodyD setObject:tagId forKey:@"tag_id"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
    
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Respone string %@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(DeleteAllTagNotificationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteAllTagNotificationInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteAllTagNotificationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteAllTagNotificationInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteAllTagNotificationInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
