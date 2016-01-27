//
//  StatusInvocation.m
//  Amity Care
//
//  Created by Dharmbir Singh on 25/08/14.
//
//

#import "StatusInvocation.h"

@interface StatusInvocation (private)

-(NSString*)body;

@end

@implementation StatusInvocation

@synthesize statusDic;


-(void)invoke
{
    
    [self post:@"feed_status" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:[self.statusDic objectForKey:@"employee"] forKey:@"employee"];
    [bodyD setObject:[self.statusDic objectForKey:@"manager"] forKey:@"manager"];
    [bodyD setObject:[self.statusDic objectForKey:@"teamleader"] forKey:@"teamleader"];
    [bodyD setObject:[self.statusDic objectForKey:@"family"] forKey:@"family"];
  //  [bodyD setObject:[self.statusDic objectForKey:@"training"] forKey:@"training"];
    [bodyD setObject:[self.statusDic objectForKey:@"BS"] forKey:@"BS"];
    [bodyD setObject:[self.statusDic objectForKey:@"user_id"] forKey:@"user_id"];
    [bodyD setObject:[self.statusDic objectForKey:@"post_id"] forKey:@"post_id"];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(statusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate statusInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(statusInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate statusInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"statusInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end

