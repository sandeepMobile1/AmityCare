//
//  EditTagIntroInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/10/14.
//
//

#import "EditTagIntroInvocation.h"
#import "ConfigManager.h"

@interface EditTagIntroInvocation (private)

-(NSString*)body;

@end

@implementation EditTagIntroInvocation

@synthesize userId,tagId,intro;

-(void)invoke
{
    [self post:@"updateUserTagIntro" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    [bodyD setObject:self.tagId forKey:@"tag_id"];
    [bodyD setObject:self.intro forKey:@"intro"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];

    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(EditTagIntroInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate EditTagIntroInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(EditTagIntroInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate EditTagIntroInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"userListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
