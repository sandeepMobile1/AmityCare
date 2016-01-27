//
//  UserAssignedTagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import "UploadDocInvocation.h"

@interface UploadDocInvocation (private)

-(NSString*)body;

@end


@implementation UploadDocInvocation
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
    if([self.delegate respondsToSelector:@selector(uploadDocInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate uploadDocInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(uploadDocInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate uploadDocInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"uploadDocInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
