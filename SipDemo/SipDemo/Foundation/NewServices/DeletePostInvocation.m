//
//  DeletePostInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 25/03/15.
//
//

#import "DeletePostInvocation.h"

@interface DeletePostInvocation (private)

-(NSString*)body;

@end

@implementation DeletePostInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"delete_post" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeletePostInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeletePostInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeletePostInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeletePostInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeletePostInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
