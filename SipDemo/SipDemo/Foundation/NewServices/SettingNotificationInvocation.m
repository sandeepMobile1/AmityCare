//
//  SettingNotificationInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 05/03/15.
//
//

#import "SettingNotificationInvocation.h"

@interface SettingNotificationInvocation (private)

-(NSString*)body;

@end

@implementation SettingNotificationInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"notification_setting" body:[self body]];
    
}

-(NSString*)body
{
    return [dict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(SettingNotificationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SettingNotificationInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(SettingNotificationInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SettingNotificationInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllUserListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
