//
//  AllTagPostInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 26/02/15.
//
//

#import "AllTagPostInvocation.h"

@interface AllTagPostInvocation (private)

-(NSString*)body;

@end

@implementation AllTagPostInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_tag_post" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AllTagPostInvocationFinish:withResults:withError:)])
    {
        [self.delegate AllTagPostInvocationFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllTagPostInvocationFinish:withResults:withError:)])
    {
        [self.delegate AllTagPostInvocationFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllTagPostInvocationFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
