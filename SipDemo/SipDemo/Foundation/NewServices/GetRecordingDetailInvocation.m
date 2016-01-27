//
//  GetRecordingDetailInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 26/03/15.
//
//

#import "GetRecordingDetailInvocation.h"

@interface GetRecordingDetailInvocation (private)

-(NSString*)body;

@end

@implementation GetRecordingDetailInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"recording_variable" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(GetRecordingDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate GetRecordingDetailInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(GetRecordingDetailInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate GetRecordingDetailInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"GetRecordingDetailInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
