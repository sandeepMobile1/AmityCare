//
//  DeleteUserEmailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/12/14.
//
//

#import "DeleteUserEmailInvocation.h"

@interface DeleteUserEmailInvocation (private)

-(NSString*)body;

@end

@implementation DeleteUserEmailInvocation

@synthesize user_id;
@synthesize mail_id;

-(void)invoke
{
    [self post:@"deleteUserEmail" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bDict = [[NSMutableDictionary alloc] init];
    [bDict setObject:self.user_id forKey:@"user_id"];
    [bDict setObject:self.mail_id forKey:@"mail_id"];
    
    return [bDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(DeleteUserEmailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteUserEmailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteUserEmailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteUserEmailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteUserEmailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
