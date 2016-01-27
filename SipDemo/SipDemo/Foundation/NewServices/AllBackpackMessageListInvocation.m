
//
//  AllBackpackMessageListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "AllBackpackMessageListInvocation.h"

@interface AllBackpackMessageListInvocation (private)

-(NSString*)body;

@end

@implementation AllBackpackMessageListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"backpack_message_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AllBackpackMessageListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllBackpackMessageListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllBackpackMessageListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllBackpackMessageListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllBackpackMessageListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
