//
//  DeletebackpackMessageInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import "DeletebackpackMessageInvocation.h"

@interface DeletebackpackMessageInvocation (private)

-(NSString*)body;

@end

@implementation DeletebackpackMessageInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"delete_backpack_message" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeletebackpackMessageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeletebackpackMessageInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeletebackpackMessageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeletebackpackMessageInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeletebackpackMessageInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
