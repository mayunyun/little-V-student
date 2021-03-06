//
//  SevenAddressPickerViewModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface SevenAddressPickerViewModel : BaseModel

@property (nonatomic,strong)NSString* province;
@property (nonatomic,strong)NSString* city;
@property (nonatomic,strong)NSString* district;
@property (nonatomic,strong)NSString* sevicecenter;
@property (nonatomic,strong)NSString* village;
@property (nonatomic,strong)NSString* province_id;
@property (nonatomic,strong)NSString* city_id;
@property (nonatomic,strong)NSString* district_id;
@property (nonatomic,strong)NSString* sevicecenter_id;
@property (nonatomic,strong)NSString* village_id;
@property (nonatomic,strong)NSString* comunity;
@property (nonatomic,strong)NSString* comunity_id;
@property (nonatomic,strong)NSString* roomnumber;
@property (nonatomic,strong)NSString* roomnumber_id;

@end
