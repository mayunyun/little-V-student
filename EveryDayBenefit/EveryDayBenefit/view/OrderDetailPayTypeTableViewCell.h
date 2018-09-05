//
//  OrderDetailPayTypeTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailPayTypeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *paytypeBtn;
@property (strong, nonatomic) IBOutlet UILabel *sendDataLabel;
@property (strong, nonatomic) IBOutlet UILabel *receiveDataLabel;
- (IBAction)paytypeBtnClick:(id)sender;

@property (nonatomic, copy) void (^transVaule)(UIButton* sender);

@end
