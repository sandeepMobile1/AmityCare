//
//  TagAssignCalendarListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 30/12/14.
//
//

#import "TagAssignCalendarListInvocation.h"

@interface TagAssignCalendarListInvocation (private)

-(NSString*)body;

@end


@implementation TagAssignCalendarListInvocation

@synthesize userId,tagId;

-(void)invoke
{
    [self post:@"get_assign_task_by_tag" body:[self body]];
    
}
-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    [bodyD setObject:self.tagId forKey:@"tag_id"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(TagAssignCalendarListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagAssignCalendarListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(TagAssignCalendarListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagAssignCalendarListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"TagAssignCalendarListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
