//
//  ScheduleEmailListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import "ScheduleEmailListInvocation.h"

@interface ScheduleEmailListInvocation (private)

-(NSString*)body;

@end

@implementation ScheduleEmailListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"allTagEmailList" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ScheduleEmailListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ScheduleEmailListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ScheduleEmailListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ScheduleEmailListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ScheduleFormListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
