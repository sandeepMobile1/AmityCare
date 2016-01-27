//
//  FolderListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 14/05/15.
//
//

#import "FolderListInvocation.h"

@interface FolderListInvocation (private)

-(NSString*)body;

@end

@implementation FolderListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"backpack_folderlist" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(FolderListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate FolderListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(FolderListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate FolderListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"FolderListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
