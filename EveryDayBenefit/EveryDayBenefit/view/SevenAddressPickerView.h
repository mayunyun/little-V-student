//
//  SevenAddressPickerView.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenAddressPickerViewModel.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
#define SERVICECENTER_COMPONENT 3

#define HOUSE_COMPONENT 0
#define COMUNITY_COMPONENT 1
#define ROOMNUMBER_COMPONENT 2

@interface SevenAddressPickerView : UIView


- (void) buttobClicked: (id)sender;
//block声明
@property (nonatomic, copy) void (^transVaule)(SevenAddressPickerViewModel* addmodel,BOOL istrue);

@end
