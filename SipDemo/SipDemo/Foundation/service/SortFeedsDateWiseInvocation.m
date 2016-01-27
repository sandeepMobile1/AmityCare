//
//  SortFeedsDateWiseInvocation.h
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "SortFeedsDateWiseInvocation.h"

@interface SortFeedsDateWiseInvocation (private)

-(NSString*)body;

@end


@implementation SortFeedsDateWiseInvocation
@synthesize dict;

-(void)invoke
{
    
    [self post:@"tag_post" body:[self body]];
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

    if([self.delegate respondsToSelector:@selector(sortFeedsDateWiseInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate sortFeedsDateWiseInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(sortFeedsDateWiseInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate sortFeedsDateWiseInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"sortFeedsDateWiseInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
