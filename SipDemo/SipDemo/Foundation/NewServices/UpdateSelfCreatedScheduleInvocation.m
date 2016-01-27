//
//  UpdateSelfCreatedScheduleInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 16/03/15.
//
//

#import "UpdateSelfCreatedScheduleInvocation.h"

@interface UpdateSelfCreatedScheduleInvocation (private)

-(NSString*)body;

@end

@implementation UpdateSelfCreatedScheduleInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"edit_schedule" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(UpdateSelfCreatedScheduleInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UpdateSelfCreatedScheduleInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UpdateSelfCreatedScheduleInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UpdateSelfCreatedScheduleInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UpdateSelfCreatedScheduleInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}
@end
