//
//  UserCompletedFormListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import "UserCompletedFormListInvocation.h"

@interface UserCompletedFormListInvocation (private)

-(NSString*)body;

@end

@implementation UserCompletedFormListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_user_list_complete_form" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(UserCompletedFormListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserCompletedFormListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UserCompletedFormListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserCompletedFormListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UserCompletedFormListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
