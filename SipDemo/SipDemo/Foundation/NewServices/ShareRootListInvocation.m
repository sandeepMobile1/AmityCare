//
//  ShareRootListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 30/04/15.
//
//

#import "ShareRootListInvocation.h"

@interface ShareRootListInvocation (private)

-(NSString*)body;

@end

@implementation ShareRootListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"shareRoot" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ShareRootListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ShareRootListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ShareRootListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ShareRootListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ShareRootListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
