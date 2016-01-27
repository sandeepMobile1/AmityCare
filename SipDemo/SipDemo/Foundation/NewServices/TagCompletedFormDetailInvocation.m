//
//  TagCompletedFormDetailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import "TagCompletedFormDetailInvocation.h"

@interface TagCompletedFormDetailInvocation (private)

-(NSString*)body;

@end
@implementation TagCompletedFormDetailInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_tag_form" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(TagCompletedFormDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagCompletedFormDetailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(TagCompletedFormDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagCompletedFormDetailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"TagCompletedFormDetailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
