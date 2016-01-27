//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "AssignTagInvocation.h"

@interface AssignTagInvocation (private)

-(NSString*)body;

@end


@implementation AssignTagInvocation
@synthesize user_id,tag_id,users;

-(void)invoke
{
    [self post:@"assign_tag" body:[self body]];
    
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:tag_id forKey:@"tag_id"];
    [bodyD setObject:users forKey:@"users"];

    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);

    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(assignTagInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate assignTagInvocationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(assignTagInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate assignTagInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"tagsInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
