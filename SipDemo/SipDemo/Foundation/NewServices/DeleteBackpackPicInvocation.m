//
//  DeleteBackpackPicInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import "DeleteBackpackPicInvocation.h"

@interface DeleteBackpackPicInvocation (private)

-(NSString*)body;

@end

@implementation DeleteBackpackPicInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"delete_backpack_media" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(DeleteBackpackPicInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteBackpackPicInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(DeleteBackpackPicInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate DeleteBackpackPicInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"DeleteBackpackPicInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
