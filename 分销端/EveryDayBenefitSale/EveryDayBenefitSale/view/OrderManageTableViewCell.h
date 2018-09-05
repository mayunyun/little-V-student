//
//  OrderManageTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderManageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
//@property (strong, nonatomic) IBOutlet UIImageView *statusimgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UIButton *reviewBtn;
- (IBAction)reviewBtnClick:(id)sender;
@property (nonatomic, copy) void (^transVaule)(UIButton* sender);

@end
