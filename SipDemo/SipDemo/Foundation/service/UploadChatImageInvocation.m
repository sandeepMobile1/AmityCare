//
//  UploadChatImageInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 26/01/15.
//
//

#import "UploadChatImageInvocation.h"

@interface UploadChatImageInvocation (private)

-(NSString*)body;

@end

@implementation UploadChatImageInvocation

@synthesize mdata;
@synthesize dict;

-(void)invoke
{
    //[self post:@"user_tags" body:[self body]];
    [self executeBinary:@"POST" withDictData:dict attachment:mdata];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    NSLog(@"UploadDocInvocation =%@",resultString);
    if([self.delegate respondsToSelector:@selector(UploadChatImageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UploadChatImageInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UploadChatImageInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UploadChatImageInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UploadChatImageInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}
@end
