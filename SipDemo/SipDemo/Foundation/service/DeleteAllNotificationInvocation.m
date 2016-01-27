//
//  DelelteAllNotificationInvocation.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 21/08/14.
//
//

#import "DeleteAllNotificationInvocation.h"

@interface DeleteAllNotificationInvocation (private)

-(NSString*)body;

@end


@implementation DeleteAllNotificationInvocation

@synthesize userId;

-(void)invoke
{
    
    [self post:@"notification_deleteAll" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:userId forKey:@"userId"];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
    
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Respone string %@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(deleteAllInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate deleteAllInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(deleteAllInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate deleteAllInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ClockInStatusInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}
@end

