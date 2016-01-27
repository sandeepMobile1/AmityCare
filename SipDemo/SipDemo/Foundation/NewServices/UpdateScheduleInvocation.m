//
//  UpdateScheduleInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 13/03/15.
//
//

#import "UpdateScheduleInvocation.h"

@interface UpdateScheduleInvocation (private)

-(NSString*)body;

@end

@implementation UpdateScheduleInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"updateSchedule" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(UpdateScheduleInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UpdateScheduleInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UpdateScheduleInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UpdateScheduleInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UpdateScheduleInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
