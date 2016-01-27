//
//  CreateFolderInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 14/05/15.
//
//

#import "CreateFolderInvocation.h"

@interface CreateFolderInvocation (private)

-(NSString*)body;

@end
@implementation CreateFolderInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"folderCreatebackpack" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(CreateFolderInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate CreateFolderInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(CreateFolderInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate CreateFolderInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"CreateFolderInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
