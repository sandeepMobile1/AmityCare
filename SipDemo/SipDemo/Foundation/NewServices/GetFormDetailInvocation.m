//
//  GetFormDetailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 15/01/15.
//
//

#import "GetFormDetailInvocation.h"

@interface GetFormDetailInvocation (private)

-(NSString*)body;

@end

@implementation GetFormDetailInvocation

@synthesize formId;

-(void)invoke
{
    [self post:@"tagFormStructure" body:[self body]];
    
}
-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.formId forKey:@"formId"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(GetFormDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate GetFormDetailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(GetFormDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate GetFormDetailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"GetFormDetailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
