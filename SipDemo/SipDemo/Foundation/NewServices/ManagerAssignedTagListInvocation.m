//
//  ManagerAssignedTagListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import "ManagerAssignedTagListInvocation.h"

@interface ManagerAssignedTagListInvocation (private)

-(NSString*)body;

@end

@implementation ManagerAssignedTagListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"manager_assigned_tag" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ManagerAssignedTagListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ManagerAssignedTagListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ManagerAssignedTagListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ManagerAssignedTagListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ManagerAssignedTagListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
