//
//  GetKeywordStatusInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/12/14.
//
//

#import "GetKeywordStatusInvocation.h"

@interface GetKeywordStatusInvocation (private)

-(NSString*)body;

@end

@implementation GetKeywordStatusInvocation

@synthesize userid,tagId;
@synthesize lastIndex;
@synthesize infoDict;

-(void)invoke
{
    
    [self post:@"keyword_post_moods" body:[self body]];
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
    
    if([self.delegate respondsToSelector:@selector(GetKeywordStatusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate GetKeywordStatusInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(GetKeywordStatusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate GetKeywordStatusInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"getKeywordFeedsInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
