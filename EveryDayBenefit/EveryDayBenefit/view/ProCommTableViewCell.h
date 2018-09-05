//
//  ProCommTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/17.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProCommTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHight;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;


//@property (nonatomic,copy)void(^transValue)(CGFloat height);

@end
