//
//  ShareBackpackInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 04/05/15.
//
//

#import "ShareBackpackInvocation.h"

@interface ShareBackpackInvocation (private)

-(NSString*)body;

@end

@implementation ShareBackpackInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"share_backpack" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(ShareBackpackInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ShareBackpackInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ShareBackpackInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ShareBackpackInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ShareBackpackInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
