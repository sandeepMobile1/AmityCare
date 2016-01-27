//
//  SmileFeedListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "SmileFeedListInvocation.h"
#import "ConfigManager.h"

@interface SmileFeedListInvocation (private)

-(NSString*)body;

@end

@implementation SmileFeedListInvocation

@synthesize user_id,tag_id,status;

-(void)invoke
{
    [self post:@"get_smile_post" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:tag_id forKey:@"tag_id"];
    [bodyD setObject:status forKey:@"status"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(SmileFeedListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SmileFeedListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(SmileFeedListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate SmileFeedListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"SmileFeedListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
