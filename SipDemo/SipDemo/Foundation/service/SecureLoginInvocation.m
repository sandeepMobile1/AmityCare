//
//  SecureLoginInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "SecureLoginInvocation.h"
#import "AppDelegate.h"

@interface SecureLoginInvocation (private)

-(NSString*)body;

@end


@implementation SecureLoginInvocation
@synthesize email;
@synthesize password;
@synthesize tagId;

-(void)invoke
{
    [self post:@"secure_login" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:email forKey:@"email"];
    [bodyD setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];
    [bodyD setObject:tagId forKey:@"tag_id"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(secureLoginInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate secureLoginInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(secureLoginInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate secureLoginInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"secureLoginInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
