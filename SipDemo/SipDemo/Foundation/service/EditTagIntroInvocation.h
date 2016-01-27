//
//  EditTagIntroInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/10/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class EditTagIntroInvocation;

@protocol EditTagIntroInvocationDelegate

-(void)EditTagIntroInvocationDidFinish:(EditTagIntroInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface EditTagIntroInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* tagId;
@property(nonatomic,strong)NSString* intro;

@end