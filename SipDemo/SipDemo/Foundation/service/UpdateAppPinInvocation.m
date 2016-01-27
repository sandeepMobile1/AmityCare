//
//  UpdateAppPinInvocation.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 19/09/14.
//
//

#import "UpdateAppPinInvocation.h"

@interface UpdateAppPinInvocation (private)

-(NSString*)body;

@end


@implementation UpdateAppPinInvocation
@synthesize userId,appPin;

-(void)invoke
{
    [self post:@"updateSecreatPin" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    [bodyD setObject:self.appPin forKey:@"appPin"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(updateAppPinInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate updateAppPinInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(updateAppPinInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate updateAppPinInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
