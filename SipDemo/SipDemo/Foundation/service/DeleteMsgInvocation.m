//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "DeleteMsgInvocation.h"

@interface DeleteMsgInvocation (private)

-(NSString*)body;

@end


@implementation DeleteMsgInvocation
@synthesize dict;

-(void)invoke
{
    [self post:@"clear_individual_message" body:[self body]];
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

    if([self.delegate respondsToSelector:@selector(deleteMsgInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate deleteMsgInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(deleteMsgInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate deleteMsgInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"deleteMsgInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
