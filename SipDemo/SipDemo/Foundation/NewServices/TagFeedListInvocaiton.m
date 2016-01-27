//
//  TagFeedListInvocaiton.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "TagFeedListInvocaiton.h"

@interface TagFeedListInvocaiton (private)

-(NSString*)body;

@end

@implementation TagFeedListInvocaiton

@synthesize user_id,tag_id;

-(void)invoke
{
    [self post:@"tagFeed_listing" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:tag_id forKey:@"tag_id"];

    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(TagFeedListInvocaitonDidFinish:withResults:withError:)])
    {
        [self.delegate TagFeedListInvocaitonDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(TagFeedListInvocaitonDidFinish:withResults:withError:)])
    {
        [self.delegate TagFeedListInvocaitonDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"TagFeedListInvocaitonDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
