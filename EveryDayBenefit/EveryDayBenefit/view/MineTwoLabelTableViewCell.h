//
//  MineTwoLabelTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTwoLabelTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;


@end
