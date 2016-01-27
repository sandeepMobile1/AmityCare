//
//  ManagerReimbursementListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import "ManagerReimbursementListInvocation.h"

@interface ManagerReimbursementListInvocation (private)

-(NSString*)body;

@end

@implementation ManagerReimbursementListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"manager_reimbursement" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ManagerReimbursementListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ManagerReimbursementListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ManagerReimbursementListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ManagerReimbursementListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ManagerReimbursementListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
