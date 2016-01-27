//
//  DeleteRootInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 21/04/15.
//
//

#import "DeleteRootInvocation.h"

@interface DeleteRootInvocation (private)

-(NSString*)body;

@end

@implementation DeleteRootInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"root_delete" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteRootInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteRootInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteRootInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteRootInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteRootInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
