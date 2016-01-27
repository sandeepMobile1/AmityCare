//
//  GroupChatDetailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 04/02/15.
//
//

#import "GroupChatDetailInvocation.h"
#import "ConfigManager.h"
#import "AppDelegate.h"

@implementation GroupChatDetailInvocation

@synthesize user_id,tag_id;

-(void)invoke
{
    [self post:@"groupchat_detail" body:[self body]];
    
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:tag_id forKey:@"tagId"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    [bodyD setObject:sharedAppDelegate.checkSpecialGroupChat forKey:@"special"];

    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(GroupChatDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate GroupChatDetailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(GroupChatDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate GroupChatDetailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"GroupChatDetailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
