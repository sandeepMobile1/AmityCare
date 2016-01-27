//
//  UpdateAppPinVC.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 19/09/14.
//
//

#import <UIKit/UIKit.h>
#import "UpdateAppPinInvocation.h"

@interface UpdateAppPinVC : UIViewController<UpdateAppPinInvocationDelegate>

@property (nonatomic, strong) IBOutlet UITextField *pinNewTxtFld;
-(IBAction)btnBackAction:(id)sender;

@end
