//
//  FindTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/17.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "FindTableViewCell.h"

@implementation FindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 10.0;
    
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imgView.image = image;
}

- (void)layoutSubviews
{

}


@end
