//
//  Common.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 22/09/14.
//
//

#ifndef Amity_Care_Common_h
#define Amity_Care_Common_h


inline static UIView *customalertview(NSString *toplbltext, NSString *midlbltxt, id delegate, id target, SEL action)
{
    UIView *alerttext = [[UIView alloc] init];
    if (IS_DEVICE_IPAD) {
        
        [alerttext setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_background.png"]]];
        
    }
    else
    {
        [alerttext setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_background_iphone.png"]]];
        
    }
    UIView *subvuiew = [[UIView alloc] init];
    [subvuiew setBackgroundColor:[UIColor clearColor]];
     [alerttext addSubview:subvuiew];
    
    UILabel *label2 = [[UILabel alloc] init];
     label2.text = midlbltxt;
    label2.textColor = [UIColor darkGrayColor];
    label2.numberOfLines=0;
    [label2 setFont:[UIFont fontWithName:@"Hevetica" size:16]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [subvuiew addSubview:label2];

    UITextField *tf = [[UITextField alloc] init];
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.secureTextEntry = YES;
    tf.delegate=delegate;
    tf.placeholder = @"PIN";
    [subvuiew addSubview:tf];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button .layer.cornerRadius=10;
     button.clipsToBounds = YES;
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [subvuiew addSubview:button];
    
    if (IS_DEVICE_IPAD) {
        
        [alerttext setFrame:CGRectMake(0, 0,768, 1024)];
        
        [subvuiew setFrame:CGRectMake(250, 150,280, 140)];
        
        [label2 setFrame:CGRectMake(10, 0, 260, 50)];
        
        [tf setFrame:CGRectMake(10, CGRectGetMaxY(label2.frame)+10, 260, 30)];
        
        [button setFrame:CGRectMake(40, 100+20, 200, 40)];

    }
    else
    {
        [alerttext setFrame:CGRectMake(0, 0,320, 568)];
        
        [subvuiew setFrame:CGRectMake(20, 30,280, 140)];
        
        [label2 setFrame:CGRectMake(10, 5, 260, 50)];
        
        [tf setFrame:CGRectMake(10, CGRectGetMaxY(label2.frame)+10, 260, 30)];
        
        [button setFrame:CGRectMake(40, 85+25, 200, 40)];

    }
    
   
    
    return alerttext;
}
inline static UIButton *getButtonImage(CGRect frame, NSString *imgName, id target, SEL action)
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
inline static UIView *customalertview1(NSString *midlbltxt, id target, SEL action)
{
    UIView *alerttext = [[UIView alloc] init];
    
    if (IS_DEVICE_IPAD) {
       
        [alerttext setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_background.png"]]];
 
    }
    else
    {
        [alerttext setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_background_iphone.png"]]];

    }

    UIView *subvuiew = [[UIView alloc] init];
    [subvuiew setBackgroundColor:[UIColor whiteColor]];
    subvuiew .layer.cornerRadius=10;
    subvuiew.clipsToBounds = YES;
    [alerttext addSubview:subvuiew];

    UILabel *label2 = [[UILabel alloc] init];
    label2.text = midlbltxt;
    label2.textColor = [UIColor darkGrayColor];
    label2.numberOfLines=0;
    [label2 setFont:[UIFont fontWithName:@"Hevetica" size:16]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [subvuiew addSubview:label2];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    button .layer.cornerRadius=10;
    button.clipsToBounds = YES;
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [subvuiew addSubview:button];
    
    if (IS_DEVICE_IPAD) {

        [alerttext setFrame:CGRectMake(0, 0,768, 1024)];
   
        [subvuiew setFrame:CGRectMake(250, 150,280, 110)];
        
        [label2 setFrame:CGRectMake(10, 0, 260, 50)];
        
        [button setFrame:CGRectMake(40, 70, 200, 40)];
        
    }
    else
    {
        [alerttext setFrame:CGRectMake(0, 0,320, 568)];
        
        [subvuiew setFrame:CGRectMake(20, 30,280, 110)];
        
        [label2 setFrame:CGRectMake(10, 0, 260, 50)];
        
        [button setFrame:CGRectMake(40, 50, 200, 40)];

    }
    
    return alerttext;
}


#endif
