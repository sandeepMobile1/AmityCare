//
//  ScheduleStatusListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import "ScheduleStatusListInvocation.h"

@interface ScheduleStatusListInvocation (private)

-(NSString*)body;

@end

@implementation ScheduleStatusListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_status_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ScheduleStatusListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ScheduleStatusListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ScheduleStatusListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ScheduleStatusListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ScheduleStatusListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
