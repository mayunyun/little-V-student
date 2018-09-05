//
//  OrderDetailNameTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

@protocol OrderDetailNameDelegate <NSObject>

- (void)selectAddBtnClick:(UIButton*)sender;
- (void)pickUpWayClick:(UIButton*)sender;

@end


#import <UIKit/UIKit.h>

@interface OrderDetailNameTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *pickUpWayBtn;
- (IBAction)pickUpWayClick:(id)sender;

@property (weak,nonatomic)id<OrderDetailNameDelegate> delegate;


@end
