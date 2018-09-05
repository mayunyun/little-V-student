//
//  ReceiveAddrPickerView.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressPickerViewModel.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
#define SERVICECENTER_COMPONENT 3
#define VILLAGE_COMPONENT 4

@interface ReceiveAddrPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate>
{
    UIPickerView *picker;
    UITextView *_detailAddressTView;
    UIButton *button;
    UIButton *closeBtn;
    
    NSMutableArray *province;
    NSMutableArray *city;
    NSMutableArray *district;
    NSMutableArray *sevicecenter;
    NSMutableArray *village;
    
    NSString* _selectProvinceStr;
}

@property (nonatomic,assign)AddressPickerViewModel* addmodel;

- (void) buttobClicked: (id)sender;
//block声明
@property (nonatomic, copy) void (^transVaule)(AddressPickerViewModel* addmodel,NSString* address,BOOL istrue);


@end
