//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "EditTaskInvocation.h"

@interface EditTaskInvocation (private)

-(NSString*)body;

@end


@implementation EditTaskInvocation
@synthesize taskDict;

-(void)invoke
{
    [self post:@"edit_task" body:[self body]];
}

-(NSString*)body
{
    /*
     task_id
     manager_id
     title
     description
     tags(comma separarted array ) eg.[1,2,2]
     users(comma separarted array) eg.[1,2,3]
     */
    return [self.taskDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(editTaskInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate editTaskInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(editTaskInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate editTaskInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"editTaskInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
