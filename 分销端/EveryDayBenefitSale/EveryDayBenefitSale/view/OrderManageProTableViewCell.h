//
//  OrderManageProTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/19.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderManageListModel.h"

@interface OrderManageProTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ordernoLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addrLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
- (IBAction)delBtnClick:(id)sender;

@property (nonatomic,strong)OrderManageListModel* model;
@property (nonatomic,strong)NSArray* prolistArr;
@property (nonatomic, copy) void (^transVaule)(NSArray* prolistArr);

@end
