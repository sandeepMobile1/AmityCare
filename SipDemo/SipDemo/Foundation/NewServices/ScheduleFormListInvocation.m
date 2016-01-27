//
//  ScheduleFormListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import "ScheduleFormListInvocation.h"

@interface ScheduleFormListInvocation (private)

-(NSString*)body;

@end

@implementation ScheduleFormListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_user_from" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ScheduleFormListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ScheduleFormListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ScheduleFormListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ScheduleFormListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ScheduleFormListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
