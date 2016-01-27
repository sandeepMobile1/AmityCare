//
//  InboxListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import "InboxListInvocation.h"
#import "ConfigManager.h"
#import "AppDelegate.h"

@interface InboxListInvocation (private)

-(NSString*)body;

@end

@implementation InboxListInvocation

@synthesize userId,tagId;

-(void)invoke
{
    [self post:@"tag_inbox" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    [bodyD setObject:self.tagId forKey:@"tag_id"];
    [bodyD setObject:sharedAppDelegate.userObj.role_id forKey:@"role_id"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(InboxListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate InboxListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(InboxListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate InboxListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"InboxListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}
@end
