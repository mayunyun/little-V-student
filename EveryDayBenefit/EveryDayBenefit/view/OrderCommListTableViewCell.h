//
//  OrderCommListTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

@protocol OrderCommListTableViewCellDelegate <NSObject>

- (void)cancelClick:(UIButton*)sender;
- (void)commantClick:(UIButton*)sender;

@end

#import <UIKit/UIKit.h>

@interface OrderCommListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *salecountLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *commantsBtn;
- (IBAction)cancelClick:(id)sender;
- (IBAction)commantClick:(id)sender;
@property (weak, nonatomic)id<OrderCommListTableViewCellDelegate> delegate;

@end
