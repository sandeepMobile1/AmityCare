//
//  ReimembursementListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 19/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ReimembursementListInvocation;

@protocol ReimembursementListInvocationDelegate

-(void)ReimembursementListInvocationDidFinish:(ReimembursementListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface ReimembursementListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* tagId;
@property(nonatomic,strong)NSString* startDate;
@property(nonatomic,strong)NSString* endDate;
@property(nonatomic,strong)NSString* userName;
@property(nonatomic,strong)NSString* tagName;

@end
