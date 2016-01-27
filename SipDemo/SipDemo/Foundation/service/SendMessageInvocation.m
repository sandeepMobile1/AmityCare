//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "SendMessageInvocation.h"

@interface SendMessageInvocation (private)

-(NSString*)body;

@end


@implementation SendMessageInvocation
@synthesize msdDict;

-(void)invoke
{
    [self post:@"send_chat_data" body:[self body]];
}

-(NSString*)body
{
    return [msdDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(sendMessageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate sendMessageInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(sendMessageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate sendMessageInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"sendMessageInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
