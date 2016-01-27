//
//  SelfCreatedScheduleListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 16/03/15.
//
//

#import "SelfCreatedScheduleListInvocation.h"

@interface SelfCreatedScheduleListInvocation (private)

-(NSString*)body;

@end

@implementation SelfCreatedScheduleListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"schedule_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(SelfCreatedScheduleListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SelfCreatedScheduleListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(SelfCreatedScheduleListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SelfCreatedScheduleListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"SelfCreatedScheduleListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
