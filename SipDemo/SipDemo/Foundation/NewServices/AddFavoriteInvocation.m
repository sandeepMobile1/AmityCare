//
//  AddFavoriteInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "AddFavoriteInvocation.h"

@interface AddFavoriteInvocation (private)

-(NSString*)body;

@end


@implementation AddFavoriteInvocation

@synthesize user_id,tag_id,feed_id;

-(void)invoke
{
    [self post:@"make_favourite_post" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:tag_id forKey:@"tag_id"];
    [bodyD setObject:feed_id forKey:@"post_id"];

    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(AddFavoriteInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddFavoriteInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AddFavoriteInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddFavoriteInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AddFavoriteInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
