//
//  OCRReceiptListViewController.h
//  SipDemo
//
//  Created by Shweta Sharma on 30/07/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OcrListInvocation.h"
#import "DeleteOcrInvocation.h"
#import "OcrTableViewCell.h"

@class OCRReaderViewController;

@interface OCRReceiptListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,OcrListInvocationDelegate,DeleteOcrInvocationDelegate,OcrTableViewCellDelegate>
{
    OcrTableViewCell *ocrCell;
    IBOutlet UITableView *tblView;
}
@property(nonatomic,strong)OCRReaderViewController *objOCRReaderViewController;
@property(nonatomic,strong)NSMutableArray *arrOcrRecieptList;
@property (nonatomic, assign)unsigned long int selectedIndxpath;

-(IBAction)btnOcrReaderAction:(id)sender;
@end
