//
//  UploadSignatureInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 12/01/15.
//
//

#import "UploadSignatureInvocation.h"

@interface UploadSignatureInvocation (private)

-(NSString*)body;

@end

@implementation UploadSignatureInvocation

@synthesize mdata;
@synthesize dict;

-(void)invoke
{
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
    
    NSLog(@"UploadDocInvocation =%@",resultsd);
    if([self.delegate respondsToSelector:@selector(UploadSignatureInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UploadSignatureInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(UploadSignatureInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate UploadSignatureInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"UploadSignatureInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
