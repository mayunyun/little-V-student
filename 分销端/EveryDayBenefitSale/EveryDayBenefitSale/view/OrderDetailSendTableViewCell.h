//
//  OrderDetailSendTableViewCell.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/29.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailSendTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *doteimgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutlet UIView *downView;

@end
