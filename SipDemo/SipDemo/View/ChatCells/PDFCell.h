//
//  PDFCell.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 29/09/14.
//
//

#import <UIKit/UIKit.h>

@interface PDFCell : UITableViewCell
{

}

@property (nonatomic,strong) IBOutlet UILabel* lblUsername;
@property (nonatomic,strong) IBOutlet UILabel* lblTime;
@property (retain, nonatomic) IBOutlet UIButton *pdfBtn;

@end
