//
//  VillageFenquModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface VillageFenquModel : BaseModel
@property (nonatomic,strong)NSString* bankcard;
@property (nonatomic,strong)NSString* fenquid;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* receiverjigou;
@property (nonatomic,strong)NSString* servicecenterid;
@property (nonatomic,strong)NSString* Id;

/*
 bankcard = 2136780741254378043;
 code = "<null>";
 fenquid = 72;
 id = "<null>";
 name = "\U6d4b\U8bd53";
 receiverjigou = "\U793e\U533a\U4e2d\U5fc3";
 servicecenterid = 18;
 type = village;
 */

@end
