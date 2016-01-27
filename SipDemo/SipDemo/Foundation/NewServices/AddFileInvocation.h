//
//  AddFileInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddFileInvocation;

@protocol AddFileInvocationDelegate

-(void)AddFileInvocationDidFinish:(AddFileInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AddFileInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
