//
//  OptionsPopOverVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 23/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "OptionsPopOverVC.h"

@interface OptionsPopOverVC ()

@end

@implementation OptionsPopOverVC
@synthesize delegate;
@synthesize lblTitle;

-(id)initWithTitleLabel:(UIColor*)backgroundColor textColor:(UIColor*)textColor title:(NSString*)title data:(NSArray*)optionsArr delegate:(id<OptionsPopOverVCDelegate>)del{
    //self = [super initWithNibName:@"OptionsPopOverVC" bundle:nil];
    self = [self initWithNibName:@"OptionsPopOverVC" bundle:nil];
    if(self)
    {
        titleText = title;
        bgColor = backgroundColor;
        txtColor = textColor;
        
        arrOptions = optionsArr;
        self.delegate = del;
        [tblViewOptions reloadData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self.lblTitle setText:titleText];
    self.lblTitle.backgroundColor = bgColor;//backgroundColor;
    self.lblTitle.textColor = txtColor ;// textColor;
    self.lblTitle.font = [UIFont fontWithName:appfontName size:14.0];
    self.lblTitle.adjustsFontSizeToFitWidth = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrOptions count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * popoverCellIdentifier = @"popoverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:popoverCellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:popoverCellIdentifier];
    }
    cell.textLabel.text = [arrOptions objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:appfontName size:13.0f];
    cell.textLabel.textColor = TEXT_COLOR_GREEN;
    return cell;
}
#pragma mark- UITableView 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(popoverOptionDidSelected:)])
    {
        [self.delegate popoverOptionDidSelected:[arrOptions objectAtIndex:indexPath.row]];
    }
}

/*-(void)dealloc
{
    self.lblTitle = nil;
    tblViewOptions = nil;
    arrOptions= nil;
    titleText = nil;
    
    [super dealloc];
}*/

@end
