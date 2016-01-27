//
//  GetProfileInvocation.m
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "GetProfileInvocation.h"

@interface GetProfileInvocation (private)

-(NSString*)body;

@end


@implementation GetProfileInvocation
@synthesize user_id,resultString,resultsd,delegate;

-(void)invoke
{
    [self post:@"get_profile" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bDict = [[NSMutableDictionary alloc] init];
    [bDict setObject:self.user_id forKey:@"user_id"];
    return [bDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    self.resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    self.resultsd = (NSDictionary*)[resultString  JSONValue];
   // NSLog(@"%@",self.resultString);

   // NSLog(@"%@",[self.resultString  JSONValue]);

    
    if([self.delegate respondsToSelector:@selector(getProfileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getProfileInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(getProfileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getProfileInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"getProfileInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
