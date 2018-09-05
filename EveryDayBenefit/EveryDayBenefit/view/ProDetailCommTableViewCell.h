//
//  ProDetailCommTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/5.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProDetailCommTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *rateLabel;//好评度比例
@property (strong, nonatomic) IBOutlet UILabel *goodImgView;//好评度
@property (strong, nonatomic) IBOutlet UILabel *badImgView;//差评度
@property (strong, nonatomic) IBOutlet UIView *rateView;//比例条View



@end
