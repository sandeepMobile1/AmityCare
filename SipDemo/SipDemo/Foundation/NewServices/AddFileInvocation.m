//
//  AddFileInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "AddFileInvocation.h"

@interface AddFileInvocation (private)

-(NSString*)body;

@end

@implementation AddFileInvocation

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
    if([self.delegate respondsToSelector:@selector(AddFileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddFileInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AddFileInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AddFileInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AddFileInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}




@end
