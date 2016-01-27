//
//  SortUserFeedsDateWiseInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/12/14.
//
//

#import "SortUserFeedsDateWiseInvocation.h"

@interface SortUserFeedsDateWiseInvocation (private)

-(NSString*)body;

@end

@implementation SortUserFeedsDateWiseInvocation

@synthesize dict;

-(void)invoke
{
    
    [self post:@"users_post" body:[self body]];
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
    
    if([self.delegate respondsToSelector:@selector(SortUserFeedsDateWiseInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SortUserFeedsDateWiseInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(SortUserFeedsDateWiseInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SortUserFeedsDateWiseInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"sortFeedsDateWiseInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
