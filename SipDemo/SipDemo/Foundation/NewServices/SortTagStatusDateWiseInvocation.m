//
//  SortTagStatusDateWiseInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/12/14.
//
//

#import "SortTagStatusDateWiseInvocation.h"

@interface SortTagStatusDateWiseInvocation (private)

-(NSString*)body;

@end

@implementation SortTagStatusDateWiseInvocation


@synthesize dict;

-(void)invoke
{
    
    [self post:@"tag_post_moods" body:[self body]];
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
    
    if([self.delegate respondsToSelector:@selector(SortTagStatusDateWiseInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SortTagStatusDateWiseInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(SortTagStatusDateWiseInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SortTagStatusDateWiseInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"sortFeedsDateWiseInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
