//
//  AddCommentInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 03/03/15.
//
//

#import "AddCommentInvocation.h"

@interface AddCommentInvocation (private)

-(NSString*)body;

@end

@implementation AddCommentInvocation

@synthesize commentDict;

-(void)invoke
{
    [self post:@"add_comment" body:[self body]];
}

-(NSString*)body
{
    return [commentDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(AddCommentInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddCommentInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AddCommentInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddCommentInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AddCommentInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
