//
//  GetStatusInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "GetStatusInvocation.h"

@interface GetStatusInvocation (private)

-(NSString*)body;

@end


@implementation GetStatusInvocation
@synthesize user_id;

-(void)invoke
{
    [self post:@"get_status_list" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.user_id forKey:@"user_id"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(getStatusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getStatusInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(getStatusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getStatusInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"getStatusInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
