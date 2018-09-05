//
//  ProDetailMessTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/5.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProDetailMessTableViewCell : UITableViewCell<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailLabelWith;
@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailWebViewWidth;

//block声明
@property (nonatomic, copy) void (^transVaule)(CGFloat height);

@end
