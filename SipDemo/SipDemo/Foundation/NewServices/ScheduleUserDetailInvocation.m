//
//  ScheduleUserDetailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 02/03/15.
//
//

#import "ScheduleUserDetailInvocation.h"

@interface ScheduleUserDetailInvocation (private)

-(NSString*)body;

@end

@implementation ScheduleUserDetailInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"schedule_user_detail" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ScheduleUserDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ScheduleUserDetailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ScheduleUserDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ScheduleUserDetailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ScheduleUserDetailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
