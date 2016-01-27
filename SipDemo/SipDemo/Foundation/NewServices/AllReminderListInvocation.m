//
//  AllReminderListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "AllReminderListInvocation.h"

@interface AllReminderListInvocation (private)

-(NSString*)body;

@end
@implementation AllReminderListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"backpack_reminder_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AllReminderListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllReminderListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllReminderListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllReminderListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllReminderListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
