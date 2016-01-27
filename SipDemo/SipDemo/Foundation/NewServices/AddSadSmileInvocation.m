//
//  AddSadSmileInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import "AddSadSmileInvocation.h"
#import "AppDelegate.h"

@interface AddSadSmileInvocation (private)

-(NSString*)body;

@end

@implementation AddSadSmileInvocation

@synthesize user_id,tag_id,feed_id,status;

-(void)invoke
{
    [self post:@"make_smile_post" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    [bodyD setObject:sharedAppDelegate.userObj.userId forKey:@"manager_id"];
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:tag_id forKey:@"tag_id"];
    [bodyD setObject:feed_id forKey:@"post_id"];
    [bodyD setObject:status forKey:@"status"];

    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(AddSadSmileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddSadSmileInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AddSadSmileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddSadSmileInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AddSadSmileInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}



@end
