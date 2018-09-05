//
//  GoodsCollectionCell.m
//  EveryDayBenefit
//
//  Created by 钱龙 on 2018/2/24.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "GoodsCollectionCell.h"

@implementation GoodsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initView];
}
- (void)initView{
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10*MYWIDTH, 10*MYWIDTH, 80*MYWIDTH, 80*MYWIDTH)];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right+ 20*MYWIDTH,10*MYWIDTH,260*MYWIDTH, 25*MYWIDTH)];
    _titleLabel.font = [UIFont systemFontOfSize:13*MYWIDTH];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _saleCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right+ 20*MYWIDTH, _titleLabel.bottom, 100*MYWIDTH, 20*MYWIDTH)];
    _saleCountLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    _saleCountLabel.textColor = GrayTitleColor;
    [self.contentView addSubview:_saleCountLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right + 20*MYWIDTH, _saleCountLabel.bottom+10*MYWIDTH, 60*MYWIDTH, 20*MYWIDTH)];
    _priceLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _priceLabel.textColor = NavBarItemColor;
    [self.contentView addSubview:_priceLabel];
    //减按钮
    _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downBtn.frame = CGRectMake(_saleCountLabel.right+5*MYWIDTH, _titleLabel.bottom+3*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH);
    [_downBtn setImage:[UIImage imageNamed:@"icon-14"] forState:UIControlStateNormal];
    [_downBtn addTarget:self action:@selector(downBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_downBtn];
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(_downBtn.right+3*MYWIDTH, _titleLabel.bottom, 15*MYWIDTH, 20*MYWIDTH)];
    _countLabel.text = @"1";
    _countLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_countLabel];
    _UpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _UpBtn.frame = CGRectMake(_countLabel.right, _titleLabel.bottom+3*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH);
    [_UpBtn setImage:[UIImage imageNamed:@"icon-17"] forState:UIControlStateNormal];
    [_UpBtn addTarget:self action:@selector(upBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_UpBtn];
    
    _rightNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightNowBtn.frame = CGRectMake(_priceLabel.right+15*MYWIDTH, _saleCountLabel.bottom+10*MYWIDTH, 60*MYWIDTH, 20*MYWIDTH);
    _rightNowBtn.titleLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [_rightNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_rightNowBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    _rightNowBtn.layer.cornerRadius = 5.f;
    _rightNowBtn.layer.borderWidth = 1.0f;
    _rightNowBtn.layer.borderColor = NavBarItemColor.CGColor;
    _rightNowBtn.layer.masksToBounds = YES;
    [_rightNowBtn addTarget:self action:@selector(rightNowBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightNowBtn];
    _joinShopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _joinShopCarBtn.frame = CGRectMake(_rightNowBtn.right+10*MYWIDTH, _saleCountLabel.bottom+10*MYWIDTH, 70*MYWIDTH, 20*MYWIDTH);
    _joinShopCarBtn.titleLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    [_joinShopCarBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    _joinShopCarBtn.layer.cornerRadius = 5.f;
    _joinShopCarBtn.layer.borderWidth = 1.0f;
    _joinShopCarBtn.layer.borderColor = NavBarItemColor.CGColor;
    _joinShopCarBtn.layer.masksToBounds = YES;
    [_joinShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_joinShopCarBtn addTarget:self action:@selector(joinShopCarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_joinShopCarBtn];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,_model.folder,_model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",_model.proname];
    
    if (!IsEmptyValue1(_model.prosale)) {
        _saleCountLabel.text = [NSString stringWithFormat:@"销量%@",_model.prosale];//@"销量：200";
    }else{
        _saleCountLabel.text = [NSString stringWithFormat:@"销量0"];//@"销量：200";
    }
    if (!IsEmptyValue1(_model.price)) {
        _model.price = [NSString stringWithFormat:@"%@",_model.price];
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.price doubleValue]];//@"￥256.00";
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"￥0"];//@"￥256.00";
    }
}
-(void)downBtnClicked{
    if (_downBtnBlock) {
        self.downBtnBlock();
    }
}
-(void)upBtnClicked{
    if (_upBtnBlock) {
        self.upBtnBlock();
    }
}
-(void)rightNowBtnClicked{
    if (_rightNowBtn) {
        self.rightNowBtnBlock();
    }
}
-(void)joinShopCarBtnClicked{
    if (_joinShopCarBtnBlock) {
        self.joinShopCarBtnBlock();
    }
}
@end
