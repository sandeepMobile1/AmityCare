//
//  GetFormListInvocation.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 03/09/14.
//
//

#import "GetFormListInvocation.h"

@implementation GetFormListInvocation

@synthesize tagId;

-(void)invoke
{
    [self post:@"contact_action" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:self.tagId forKey:@"tagId"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response Str %@",resultString);
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(getFormListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getFormListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(getFormListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getFormListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end


