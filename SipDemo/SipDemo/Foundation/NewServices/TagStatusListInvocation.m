//
//  TagStatusListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "TagStatusListInvocation.h"
#import "ConfigManager.h"

@interface TagStatusListInvocation (private)

-(NSString*)body;

@end

@implementation TagStatusListInvocation

@synthesize userid,tagId;
@synthesize lastIndex,roleId,timeLine;

-(void)invoke
{
    [self post:@"tag_post_moods" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
       
    [bodyD setObject:self.userid forKey:@"user_id"];
    [bodyD setObject:self.tagId forKey:@"tag_id"];
    [bodyD setObject:self.lastIndex forKey:@"index"];
    [bodyD setObject:self.roleId forKey:@"role_id"];
    //[bodyD setObject:self.timeLine forKey:@"time"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    return [bodyD JSONRepresentation];}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(TagStatusListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagStatusListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(TagStatusListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate TagStatusListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"TagStatusListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
