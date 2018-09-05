//
//  getAllProductTypeModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface getAllProductTypeModel : BaseModel

@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* catetype;
@property (nonatomic,strong)NSString* isleaf;
@property (nonatomic,strong)NSString* ismenu;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* parentid;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* folder;

/*
 catetype = protype;
 folder = protypefolder;
 id = 65;
 isleaf = 1;
 ismenu = 0;
 isvalid = 1;
 name = "\U4f11\U95f2\U98df\U54c11";
 parentid = 53;
 picname = "1474513788688532011111614473078125001746.jpg";
 */

@end
