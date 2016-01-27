//
//  AllHappyFacePostsInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 19/03/15.
//
//

#import "AllHappyFacePostsInvocation.h"

@interface AllHappyFacePostsInvocation (private)

-(NSString*)body;

@end

@implementation AllHappyFacePostsInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_smile_post" body:[self body]];
    
}

-(NSString*)body
{
    return [dict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(AllHappyFacePostsInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllHappyFacePostsInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllHappyFacePostsInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllHappyFacePostsInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllHappyFacePostsInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
