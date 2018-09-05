//
//  YouLikeCollectionViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/13.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "YouLikeCollectionViewCell.h"

@implementation YouLikeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,self.model.folder,self.model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    _titleLabel.text = _model.proname;
    if (!IsEmptyValue1(_model.prosale)) {
        _countLabel.text = [NSString stringWithFormat:@"销量%@",_model.prosale];
    }else{
        _countLabel.text = [NSString stringWithFormat:@"销量0"];
    }
    if (!IsEmptyValue1(self.model.singleprice)) {
        self.model.singleprice = [NSString stringWithFormat:@"%@",self.model.singleprice];
        _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.model.singleprice doubleValue]];
    }else{
        _moneyLabel.text = [NSString stringWithFormat:@"￥0"];
    }
}

@end
