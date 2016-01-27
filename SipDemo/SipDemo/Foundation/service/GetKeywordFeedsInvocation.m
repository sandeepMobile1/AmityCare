//
//  GetFeedsInvocation.h
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "GetKeywordFeedsInvocation.h"

@interface GetKeywordFeedsInvocation (private)

-(NSString*)body;

@end


@implementation GetKeywordFeedsInvocation
@synthesize userid,tagId;
@synthesize lastIndex;
@synthesize infoDict;

-(void)invoke
{
   
    [self post:@"keyword_post" body:[self body]];
}

-(NSString*)body
{
    return [infoDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(getKeywordFeedsInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getKeywordFeedsInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(getKeywordFeedsInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getKeywordFeedsInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"getKeywordFeedsInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
