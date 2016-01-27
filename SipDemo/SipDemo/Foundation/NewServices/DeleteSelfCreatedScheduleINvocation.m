//
//  DeleteSelfCreatedScheduleINvocation.m
//  Amity-Care
//
//  Created by Admin on 18/03/15.
//
//

#import "DeleteSelfCreatedScheduleINvocation.h"

@interface DeleteSelfCreatedScheduleINvocation (private)

-(NSString*)body;

@end


@implementation DeleteSelfCreatedScheduleINvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"delete_schedule" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteSelfCreatedScheduleINvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteSelfCreatedScheduleINvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteSelfCreatedScheduleINvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteSelfCreatedScheduleINvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UpdateSelfCreatedScheduleInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
