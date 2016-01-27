//
//  AddTaskInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 02/05/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "AddTaskInvocation.h"

@interface AddTaskInvocation (private)

-(NSString*)body;

@end


@implementation AddTaskInvocation
@synthesize taskDict;

-(void)invoke
{
    [self post:@"add_task" body:[self body]];
}

-(NSString*)body
{
    /*
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

    if([self.delegate respondsToSelector:@selector(addTaskInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate addTaskInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(addTaskInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate addTaskInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"addTaskInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
