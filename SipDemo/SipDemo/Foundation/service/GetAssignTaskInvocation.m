//
//  GetTaskListInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 02/05/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "GetAssignTaskInvocation.h"

@interface GetAssignTaskInvocation (private)

-(NSString*)body;

@end


@implementation GetAssignTaskInvocation
@synthesize user_id,role;

-(void)invoke
{
    [self post:@"assign_task" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.user_id forKey:@"user_id"];
    [bodyD setObject:self.role forKey:@"role"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(getAssignTaskInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getAssignTaskInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(getAssignTaskInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getAssignTaskInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"GetTaskListInvocation" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
