//
//  GetFromNameInvacation.m
//  Amity-Care
//
//  Created by Dharmbir Singh on 03/09/14.
//
//

#import "GetFormNameInvacation.h"
#import "ConfigManager.h"
#import "AppDelegate.h"

@interface GetFormNameInvacation (private)

-(NSString*)body;

@end


@implementation GetFormNameInvacation

@synthesize tagId;

-(void)invoke
{
    [self post:@"tag_form" body:[self body]];

}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
   [bodyD setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];

   [bodyD setObject:self.tagId forKey:@"tag_id"];
   [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    NSLog(@"Response Str %@",resultsd);
    
    if([self.delegate respondsToSelector:@selector(getFormNameInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getFormNameInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(getFormNameInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate getFormNameInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end

