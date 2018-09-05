//
//  LeadScrollView.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/27.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FristLaunch @"FristLaunch"

typedef void (^BeginBlock)();

//#define LeadPictures @[@"guide1",@"guide2",@"guide3",@"guide4"]
//#define LeadPictures4 @[@"guide1-4s",@"guide2-4s",@"guide3-4s",@"guide4-4s"]

//#define LeadPictures @[@"guidenew1",@"guidenew2",@"guidenew3"]
//#define LeadPictures4 @[@"guidenew1",@"guidenew2",@"guidenew3"]


@interface LeadScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic , copy) BeginBlock beginBlock;

- (id)initWithFrame:(CGRect)frame;

- (void)createPageContrl;

+ (BOOL)launchFirst;
@property (nonatomic,strong)NSArray* imageUrlArray;

@property (nonatomic,copy)void(^transValue)(NSArray* array);

@end
