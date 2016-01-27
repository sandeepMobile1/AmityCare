//
//  TagNotificationListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "TagNotificationListInvocation.h"
#import "ConfigManager.h"

@interface TagNotificationListInvocation (private)

-(NSString*)body;

@end

@implementation TagNotificationListInvocation

@synthesize user_id,tag_id,page_index;

-(void)invoke
{
    [self post:@"tag_notifications" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:page_index forKey:@"index"];

    [bodyD setObject:tag_id forKey:@"tag_id"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(TagNotificationListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagNotificationListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(TagNotificationListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagNotificationListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"TagNotificationListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end

