//
//  ThirdAddressPickerView.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdAddressPickerViewModel.h"

#define HOUSE_COMPONENT 0
#define COMUNITY_COMPONENT 1
#define ROOMNUMBER_COMPONENT 2

@interface ThirdAddressPickerView : UIView

- (void) buttobClicked: (id)sender;
//block声明
@property (nonatomic, copy) void (^transVaule)(ThirdAddressPickerViewModel* addmodel,BOOL istrue);

- (instancetype)initWithFrame:(CGRect)frame Id:(NSString*)villageid;

@end
