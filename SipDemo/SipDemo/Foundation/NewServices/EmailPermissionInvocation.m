//
//  EmailPermissionInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 09/03/15.
//
//

#import "EmailPermissionInvocation.h"

@interface EmailPermissionInvocation (private)

-(NSString*)body;

@end

@implementation EmailPermissionInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"tag_emails_permission" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(EmailPermissionInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate EmailPermissionInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(EmailPermissionInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate EmailPermissionInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"EmailPermissionInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
