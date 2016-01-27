//
//  DeleteBackpackReminderInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import "DeleteBackpackReminderInvocation.h"

@interface DeleteBackpackReminderInvocation (private)

-(NSString*)body;

@end
@implementation DeleteBackpackReminderInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"delete_backpack_reminder" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteBackpackReminderInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteBackpackReminderInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteBackpackReminderInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteBackpackReminderInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteBackpackReminderInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
