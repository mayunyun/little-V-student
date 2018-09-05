//
//  ReportFenxiaoModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/16.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface ReportFenxiaoModel : BaseModel

@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* departname;
@property (nonatomic,strong)NSString* money;    //实际金额
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* benyueprofit; //本月预结算
@property (nonatomic,strong)NSString* upprofit; //上月预结算
@property (nonatomic,strong)NSString* Id;


/*
 {"page_number":1,"rows":[{"createtime":1479261762000,"departandaccountid":152,"departname":"分销1","id":226,"money":640,"rn":1,"type":5,"benyueprofit":-260,"upprofit":0}],"total":1}
 */

@end
