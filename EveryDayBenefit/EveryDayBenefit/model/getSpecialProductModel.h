//
//  getSpecialProductModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface getSpecialProductModel : BaseModel

@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* picurl;       //专题链接
@property (nonatomic,strong)NSString* specialname;  //专题名

/*
 folder = specialfolder;
 id = 4;
 picname = "147374557491715banner4.jpg";
 picurl = 0;
 specialname = "\U4f11\U95f2\U98df\U54c1";
 */

@end
