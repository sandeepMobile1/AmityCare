//
//  FormListViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <UIKit/UIKit.h>
#import "GetFormListInvocation.h"
#import "GetFormNameInvacation.h"

@class FormListVC;
@class Form;

@interface FormListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,GetFormNameInvacationDelegate>
{
    IBOutlet UITableView* tblView;

}
@property (strong, nonatomic) FormListVC *flvc;

@property (strong, nonatomic) NSMutableArray *formsArr;
@property (strong, nonatomic) NSMutableArray *formNameArr;
@property (strong, nonatomic) NSMutableArray *arrTotalFormList;
@property (strong, nonatomic) NSString *folderName;

@property(nonatomic,strong)NSString *tagId;
-(IBAction)btnBackAction:(id)sender;

-(void)requestForGetFormList;

@end
