//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//


#import "AppContactsInvoation.h"

@interface AppContactsInvoation (private)

-(NSString*)body;

@end


@implementation AppContactsInvoation
@synthesize user_id;

-(void)invoke
{
    [self post:@"app_contacts" body:[self body]];
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:user_id forKey:@"user_id"];
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = (NSDictionary*)[resultString  JSONValue];

    if([self.delegate respondsToSelector:@selector(appContactsInvoationDidFinish:withResults:withError:)])
    {
        [self.delegate appContactsInvoationDidFinish:self withResults:resultsd withError:nil];
    }

    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(appContactsInvoationDidFinish:withResults:withError:)])
    {
        [self.delegate appContactsInvoationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"appContactsInvoationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}





@end
