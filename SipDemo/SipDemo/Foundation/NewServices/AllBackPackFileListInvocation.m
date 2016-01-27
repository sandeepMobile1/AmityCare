//
//  AllBackPackFileListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import "AllBackPackFileListInvocation.h"

@interface AllBackPackFileListInvocation (private)

-(NSString*)body;

@end

@implementation AllBackPackFileListInvocation

@synthesize dict;

-(void)invoke
{
    [self post:@"backpack_media_list" body:[self body]];
    
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
    
    if([self.delegate respondsToSelector:@selector(AllBackPackFileListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllBackPackFileListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(AllBackPackFileListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate AllBackPackFileListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"AllBackPackFileListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}


@end
