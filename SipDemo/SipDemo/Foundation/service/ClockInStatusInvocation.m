//
//  ClockInStatusInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 13/08/14.
//
//

#import "ClockInStatusInvocation.h"

@interface ClockInStatusInvocation (private)

-(NSString*)body;

@end


@implementation ClockInStatusInvocation

@synthesize userId;
@synthesize tagId;
@synthesize startDate;
@synthesize endDate;
@synthesize index;

-(void)invoke
{
    
    [self post:@"clock_search" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:userId forKey:@"user_id"];
    [bodyD setObject:tagId forKey:@"tag_id"];
    [bodyD setObject:startDate forKey:@"start_date"];
    [bodyD setObject:endDate forKey:@"end_date"];
    [bodyD setObject:index forKey:@"index"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];

}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(ClockInStatusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ClockInStatusInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ClockInStatusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ClockInStatusInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ClockInStatusInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}
@end
