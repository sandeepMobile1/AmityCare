//
//  InboxDetailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import "InboxDetailInvocation.h"

@interface InboxDetailInvocation (private)

-(NSString*)body;

@end

@implementation InboxDetailInvocation

@synthesize userId,tagId,mailId;

-(void)invoke
{
    [self post:@"inbox_detail" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    [bodyD setObject:self.tagId forKey:@"tag_id"];
    [bodyD setObject:self.mailId forKey:@"mail_id"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(InboxDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate InboxDetailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(InboxDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate InboxDetailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}



@end
