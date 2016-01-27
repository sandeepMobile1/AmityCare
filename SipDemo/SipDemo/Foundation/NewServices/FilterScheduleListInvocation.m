//
//  FilterScheduleListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import "FilterScheduleListInvocation.h"

@interface FilterScheduleListInvocation (private)

-(NSString*)body;

@end

@implementation FilterScheduleListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"schedule_user_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(FilterScheduleListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate FilterScheduleListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(FilterScheduleListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate FilterScheduleListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"FilterScheduleListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
