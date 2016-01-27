//
//  UploadBackgroundRecordingInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 31/03/15.
//
//

#import "UploadBackgroundRecordingInvocation.h"

@interface UploadBackgroundRecordingInvocation (private)

-(NSString*)body;

@end

@implementation UploadBackgroundRecordingInvocation

@synthesize mdata;
@synthesize dict;

-(void)invoke
{
    [self executeBinary:@"POST" withDictData:dict attachment:mdata];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    
    NSLog(@"%@",bodyD);
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];
    
    NSLog(@"UploadDocInvocation =%@",resultsd);
    if([self.delegate respondsToSelector:@selector(UploadBackgroundRecordingInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UploadBackgroundRecordingInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UploadBackgroundRecordingInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UploadBackgroundRecordingInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UploadBackgroundRecordingInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
