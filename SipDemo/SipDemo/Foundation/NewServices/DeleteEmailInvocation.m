//
//  DeleteEmailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 25/03/15.
//
//

#import "DeleteEmailInvocation.h"

@interface DeleteEmailInvocation (private)

-(NSString*)body;

@end
@implementation DeleteEmailInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"delete_email" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteEmailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteEmailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteEmailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteEmailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteEmailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
