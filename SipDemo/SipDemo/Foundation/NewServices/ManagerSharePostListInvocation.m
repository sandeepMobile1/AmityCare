//
//  ManagerSharePostListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import "ManagerSharePostListInvocation.h"

@interface ManagerSharePostListInvocation (private)

-(NSString*)body;

@end

@implementation ManagerSharePostListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"manager_share_post" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ManagerSharePostListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ManagerSharePostListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ManagerSharePostListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ManagerSharePostListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ManagerSharePostListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
