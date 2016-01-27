//
//  AllSadFacePostsInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 19/03/15.
//
//

#import "AllSadFacePostsInvocation.h"

@interface AllSadFacePostsInvocation (private)

-(NSString*)body;

@end

@implementation AllSadFacePostsInvocation

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
    
    if([self.delegate respondsToSelector:@selector(AllSadFacePostsInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllSadFacePostsInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllSadFacePostsInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllSadFacePostsInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllSadFacePostsInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
