//
//  SearchEvaluateModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/13.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface SearchEvaluateModel : BaseModel

@property (nonatomic,strong)NSString* comments;
@property (nonatomic,strong)NSString* creator;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* creatorid;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* orderno;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* score;
@property (nonatomic,strong)NSString* sendscore;
@property (nonatomic,strong)NSString* picsrc;
@property (nonatomic,strong)NSString* picname;


/*
[{"comments":"ii","createtime":1476351424000,"creator":"云云","creatorid":61,"id":93,"orderno":"dd201610100009","proid":35,"proname":"饼干","score":4,"sendscore":4}]
 */
@end
