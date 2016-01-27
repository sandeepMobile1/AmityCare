//
//  UserCompletedFormDetailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import "UserCompletedFormDetailInvocation.h"

@interface UserCompletedFormDetailInvocation (private)

-(NSString*)body;

@end

@implementation UserCompletedFormDetailInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"user_form_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(UserCompletedFormDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserCompletedFormDetailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UserCompletedFormDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UserCompletedFormDetailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UserCompletedFormDetailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end

