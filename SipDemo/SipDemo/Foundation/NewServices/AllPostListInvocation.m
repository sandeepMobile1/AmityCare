//
//  AllPostListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 25/03/15.
//
//

#import "AllPostListInvocation.h"

@interface AllPostListInvocation (private)

-(NSString*)body;

@end

@implementation AllPostListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_notes_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AllPostListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllPostListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllPostListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllPostListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllPostListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
