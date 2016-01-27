//
//  AddPicInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddPicInvocation;

@protocol AddPicInvocationDelegate

-(void)AddPicInvocationDidFinish:(AddPicInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AddPicInvocation : SAServiceAsyncInvocation{
    
}


@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;


@end
