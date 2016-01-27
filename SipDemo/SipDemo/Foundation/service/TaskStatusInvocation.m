//
//  GetTaskListInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 02/05/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "TaskStatusInvocation.h"

@interface TaskStatusInvocation (private)

-(NSString*)body;

@end


@implementation TaskStatusInvocation
@synthesize user_id,task_id;

-(void)invoke
{
    [self post:@"task_status" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.user_id forKey:@"user_id"];
    [bodyD setObject:self.task_id forKey:@"task_id"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(taskStatusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate taskStatusInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(taskStatusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate taskStatusInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"taskStatusInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
