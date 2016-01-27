//
//  AddMessageInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "AddMessageInvocation.h"

@interface AddMessageInvocation (private)

-(NSString*)body;

@end

@implementation AddMessageInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"add_backpack_message" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AddMessageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddMessageInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AddMessageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddMessageInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AddMessageInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
