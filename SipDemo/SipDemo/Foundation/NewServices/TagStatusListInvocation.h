//
//  TagStatusListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagStatusListInvocation;

@protocol TagStatusListInvocationDelegate

-(void)TagStatusListInvocationDidFinish:(TagStatusListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface TagStatusListInvocation : SAServiceAsyncInvocation{
    
}
@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *roleId;
@property(nonatomic, strong) NSString *tagId;
@property(nonatomic, strong) NSString* lastIndex;
@property(nonatomic, strong) NSString *timeLine;

@end
