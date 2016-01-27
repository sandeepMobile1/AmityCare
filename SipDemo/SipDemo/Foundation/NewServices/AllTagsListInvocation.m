//
//  AllTagsListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import "AllTagsListInvocation.h"

@interface AllTagsListInvocation (private)

-(NSString*)body;

@end

@implementation AllTagsListInvocation

@synthesize userId;

-(void)invoke
{
    [self post:@"all_tags" body:[self body]];
    
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(AllTagsListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllTagsListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllTagsListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllTagsListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllTagsListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
