//
//  DeleteEmailListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 25/03/15.
//
//

#import "DeleteEmailListInvocation.h"

@interface DeleteEmailListInvocation (private)

-(NSString*)body;

@end

@implementation DeleteEmailListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"all_tag_email" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteEmailListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteEmailListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteEmailListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteEmailListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteEmailListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
