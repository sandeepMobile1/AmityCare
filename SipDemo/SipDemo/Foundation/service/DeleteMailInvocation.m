//
//  DeleteMailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import "DeleteMailInvocation.h"

@interface DeleteMailInvocation (private)

-(NSString*)body;

@end


@implementation DeleteMailInvocation

@synthesize user_id;
@synthesize mail_id;
@synthesize tag_id;

-(void)invoke
{
    [self post:@"deleteEmail" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bDict = [[NSMutableDictionary alloc] init];
    [bDict setObject:self.user_id forKey:@"user_id"];
    [bDict setObject:self.mail_id forKey:@"id"];
    [bDict setObject:self.tag_id forKey:@"tag_id"];

    return [bDict JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    if([self.delegate respondsToSelector:@selector(DeleteMailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteMailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteMailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteMailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteMailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}




@end
