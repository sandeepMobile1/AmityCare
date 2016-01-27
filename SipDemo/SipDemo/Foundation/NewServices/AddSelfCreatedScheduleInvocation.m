//
//  AddSelfCreatedScheduleInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 16/03/15.
//
//

#import "AddSelfCreatedScheduleInvocation.h"

@interface AddSelfCreatedScheduleInvocation (private)

-(NSString*)body;

@end

@implementation AddSelfCreatedScheduleInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"add_schedule" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AddSelfCreatedScheduleInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddSelfCreatedScheduleInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AddSelfCreatedScheduleInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddSelfCreatedScheduleInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AddSelfCreatedScheduleInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}



@end
