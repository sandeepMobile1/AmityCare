//
//  AllUserListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 27/02/15.
//
//

#import "AllUserListInvocation.h"

@interface AllUserListInvocation (private)

-(NSString*)body;

@end

@implementation AllUserListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_user_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AllUserListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllUserListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllUserListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllUserListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllUserListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
