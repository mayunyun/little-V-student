//
//  SearchGoldsProModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface SearchGoldsProModel : BaseModel

@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* prosale;
@property (nonatomic,strong)NSString* price;
@property (nonatomic,strong)NSString* Id;


/*
 //{"folder":"tmp/","picname":"147598376197496guoba1.jpg","proname":"锅巴","prosale":6}
 */

@end
