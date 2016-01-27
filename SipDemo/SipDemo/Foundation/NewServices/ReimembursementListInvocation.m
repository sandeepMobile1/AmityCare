//
//  ReimembursementListInvocation.m
//  Amity-Care
//
//  Created by Shweta Sharma on 19/02/15.
//
//

#import "ReimembursementListInvocation.h"
#import "ConfigManager.h"

@interface ReimembursementListInvocation (private)

-(NSString*)body;

@end

@implementation ReimembursementListInvocation

@synthesize userId,tagId,startDate,endDate,userName,tagName;

-(void)invoke
{
    [self post:@"rootTagUserList" body:[self body]];
    
}

-(NSString*)body
{
    NSMutableDictionary* bodyD = [[NSMutableDictionary alloc] init];
    [bodyD setObject:self.userId forKey:@"user_id"];
    [bodyD setObject:self.tagId forKey:@"tag_id"];
    [bodyD setObject:self.startDate forKey:@"start_date"];
    [bodyD setObject:self.endDate forKey:@"end_date"];
    [bodyD setObject:@"" forKey:@"userName"];
    [bodyD setObject:@"" forKey:@"tagName"];

    
    [bodyD setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data
{
    NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",resultString);
    
    NSDictionary* resultsd = [resultString  JSONValue];
    
    NSLog(@"%@",resultsd);

    if([self.delegate respondsToSelector:@selector(ReimembursementListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ReimembursementListInvocationDidFinish:self withResults:resultsd withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code
{
    if([self.delegate respondsToSelector:@selector(ReimembursementListInvocationDidFinish:withResults:withError:)])
    {
        [self.delegate ReimembursementListInvocationDidFinish:self withResults:nil withError:[NSError errorWithDomain:@"ReimembursementListInvocationDidFinish" code:code userInfo:[NSDictionary dictionaryWithObject:@"Failed .Please try again later." forKey:@"error"]]];
    }
    return YES;
}

@end
