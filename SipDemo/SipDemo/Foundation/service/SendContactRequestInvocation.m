//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "SendContactRequestInvocation.h"

@interface SendContactRequestInvocation (private)

-(NSString*)body;

@end


@implementation SendContactRequestInvocation
@synthesize user_id,member_id;

-(void)invoke
{
    [self post:@"add_contact" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:member_id forKey:@"member_id"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response Str %@",resultString);
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(sendContactRequestInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate sendContactRequestInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(sendContactRequestInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate sendContactRequestInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"sendContactRequestInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
