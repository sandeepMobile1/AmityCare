//
//  TagCalenderListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 11/10/14.
//
//

#import "TagCalenderListInvocation.h"

@interface TagCalenderListInvocation (private)

-(NSString*)body;

@end

@implementation TagCalenderListInvocation

@synthesize userId,tagId;

-(void)invoke
{
    [self post:@"calendar_task" body:[self body]];

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
    
    if([self.delegate respondsToSelector:@selector(TagCalenderListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagCalenderListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(TagCalenderListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagCalenderListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
