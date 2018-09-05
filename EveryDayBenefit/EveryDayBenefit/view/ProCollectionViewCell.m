//
//  ProCollectionViewCell.m
//  lx
//
//  Created by 联祥 on 16/1/25.
//  Copyright © 2016年 lx. All rights reserved.
//

#import "ProCollectionViewCell.h"
#import "UIViewExt.h"

@implementation ProCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self initView];
}
- (void)initView{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    _specLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _specLabel.font = [UIFont systemFontOfSize:12];
    _specLabel.textAlignment = NSTextAlignmentCenter;
    _specLabel.textColor = GrayTitleColor;
    [self.contentView addSubview:_specLabel];
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLabel.font = [UIFont systemFontOfSize:12];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_priceLabel];
       
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat wide = self.contentView.frame.size.width;
    _imgView.frame = CGRectMake(20, 20, wide - 40, wide - 40);
    _titleLabel.frame = CGRectMake(5, _imgView.bottom, (mScreenWidth - 15 - 30)/3, 30);
    _specLabel.frame = CGRectMake(5, _titleLabel.bottom + 2, (mScreenWidth - 15 - 30)/3, 20);
    _priceLabel.frame = CGRectMake(5, _specLabel.bottom + 2, (mScreenWidth - 15 - 30)/3, 30);
    _imgView.image = nil;
    _titleLabel.text = nil;
    _specLabel.text = nil;
    _priceLabel.text = nil;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,self.model.folder,self.model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    _titleLabel.text = _model.proname;
    if (!IsEmptyValue1(_model.prosale)) {
        _specLabel.text = [NSString stringWithFormat:@"销量%@",_model.prosale];
    }else{
        _specLabel.text = [NSString stringWithFormat:@"销量0"];
    }
    if (!IsEmptyValue1(self.model.singleprice)) {
        self.model.singleprice = [NSString stringWithFormat:@"%@",self.model.singleprice];
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.model.singleprice doubleValue]];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"￥0"];
    }
    
    
}



@end
