//
//  OfflineMessageInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 12/03/15.
//
//

#import "OfflineMessageInvocation.h"

@interface OfflineMessageInvocation (private)

-(NSString*)body;

@end

@implementation OfflineMessageInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"offline_message" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(OfflineMessageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate OfflineMessageInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(OfflineMessageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate OfflineMessageInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"OfflineMessageInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
