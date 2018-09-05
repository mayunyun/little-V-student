//
//  DetailCollectionViewCell.m
//  lx
//
//  Created by 联祥 on 16/1/7.
//  Copyright © 2016年 lx. All rights reserved.
//

#import "DetailCollectionViewCell.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
@implementation DetailCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"cell中的传入的商品的名%@",_model.proname);
    [super awakeFromNib];
    [self initView];
}
- (void)initView{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.backgroundColor = [UIColor clearColor];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    _specLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _specLabel.backgroundColor = [UIColor clearColor];
    _specLabel.font = [UIFont systemFontOfSize:12];
    _specLabel.textAlignment = NSTextAlignmentCenter;
    _specLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_specLabel];
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceLabel];
    _priceLabel.textColor = [UIColor redColor];
    
    //减按钮
    _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _downBtn.frame = CGRectMake(_saleCountLabel.right+5*MYWIDTH, _titleLabel.bottom+3*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH);
    [_downBtn setImage:[UIImage imageNamed:@"icon-14"] forState:UIControlStateNormal];
    [_downBtn addTarget:self action:@selector(downBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_downBtn];
    _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(_downBtn.right+3*MYWIDTH, _titleLabel.bottom, 15*MYWIDTH, 20*MYWIDTH)];
    _countLabel.text = @"1";
    _countLabel.font = [UIFont systemFontOfSize:12*MYWIDTH];
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_countLabel];
    _UpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _UpBtn.frame = CGRectMake(_countLabel.right, _titleLabel.bottom+3*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH);
    [_UpBtn setImage:[UIImage imageNamed:@"icon-17"] forState:UIControlStateNormal];
    [_UpBtn addTarget:self action:@selector(upBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_UpBtn];
    
    _rightNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _rightNowBtn.frame = CGRectMake(_priceLabel.right+5*MYWIDTH, _saleCountLabel.bottom+2*MYWIDTH, 50*MYWIDTH, 15*MYWIDTH);
    _rightNowBtn.titleLabel.font = [UIFont systemFontOfSize:10*MYWIDTH];
    [_rightNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_rightNowBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    _rightNowBtn.layer.cornerRadius = 5.f;
    _rightNowBtn.layer.borderWidth = 1.0f;
    _rightNowBtn.layer.borderColor = NavBarItemColor.CGColor;
    _rightNowBtn.layer.masksToBounds = YES;
    [_rightNowBtn addTarget:self action:@selector(rightNowBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightNowBtn];
    _joinShopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _joinShopCarBtn.frame = CGRectMake(_rightNowBtn.right+10*MYWIDTH, _saleCountLabel.bottom+2*MYWIDTH, 60*MYWIDTH, 15*MYWIDTH);
    _joinShopCarBtn.titleLabel.font = [UIFont systemFontOfSize:10*MYWIDTH];
    [_joinShopCarBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    _joinShopCarBtn.layer.cornerRadius = 5.f;
    _joinShopCarBtn.layer.borderWidth = 1.0f;
    _joinShopCarBtn.layer.borderColor = NavBarItemColor.CGColor;
    _joinShopCarBtn.layer.masksToBounds = YES;
    [_joinShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_joinShopCarBtn addTarget:self action:@selector(joinShopCarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_joinShopCarBtn];
    
//    _buyCarImg = [[UIButton alloc] initWithFrame:CGRectZero];
//    _buyCarImg = [UIButton buttonWithType:UIButtonTypeCustom];
//    _buyCarImg.backgroundColor = [UIColor clearColor];
//    _buyCarImg.frame = CGRectZero;
//    [_buyCarImg setImage:[UIImage imageNamed:@"icon-4"] forState:UIControlStateNormal];
//    _buyCarImg.contentMode = UIViewContentModeScaleAspectFit;
//    [_buyCarImg addTarget:self action:@selector(buyCarClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_buyCarImg];


}

- (void)buyCarClick:(UIButton*)sender
{
    
    if (_transVaule) {
        _transVaule(sender);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"cell中的传入的商品的名-----%@",_model.proname);
    //CGFloat wide = self.contentView.frame.size.width;
    _imgView.frame = CGRectMake((mScreenWidth/2 - 110*4/3)/2, 10, 110*4/3, 110);
    _titleLabel.frame = CGRectMake(0, _imgView.bottom, mScreenWidth/2, 20);
    _specLabel.frame = CGRectMake(0, _titleLabel.bottom + 2, 80*MYWIDTH, 20);
    _priceLabel.frame = CGRectMake(_specLabel.right, _titleLabel.bottom + 2, 80*MYWIDTH, 20);
//    _buyCarImg.frame = CGRectMake(_priceLabel.right - 40, _specLabel.bottom + 5, 35, 20);
    _downBtn.frame = CGRectMake(5*MYWIDTH, _specLabel.bottom+3*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH);
    _countLabel.frame = CGRectMake(_downBtn.right+3*MYWIDTH, _specLabel.bottom, 15*MYWIDTH, 20*MYWIDTH);
     _UpBtn.frame = CGRectMake(_countLabel.right, _specLabel.bottom+3*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH);
    _rightNowBtn.frame = CGRectMake(_UpBtn.right+5*MYWIDTH, _priceLabel.bottom+3*MYWIDTH, 50*MYWIDTH, 15*MYWIDTH);
    _joinShopCarBtn.frame = CGRectMake(_rightNowBtn.right+10*MYWIDTH, _priceLabel.bottom+3*MYWIDTH, 60*MYWIDTH, 15*MYWIDTH);
    _titleLabel.text = nil;
    _specLabel.text = nil;
    _priceLabel.text = nil;
    _imgView.image = nil;
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",Image_Path,_model.folder,_model.picname];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];

    _titleLabel.text = [NSString stringWithFormat:@"%@",self.model.proname];
    if (!IsEmptyValue1(self.model.prosale)) {
        _specLabel.text = [NSString stringWithFormat:@"销量%@",self.model.prosale];
    }else{
        _specLabel.text = [NSString stringWithFormat:@"销量0"];
    }
    self.model.price = [NSString stringWithFormat:@"%@",self.model.price];
    if (!IsEmptyValue1(self.model.price)) {
        _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[self.model.price doubleValue]];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"¥ 0"];
    }
//    _buyCarImg.image = [UIImage imageNamed:@"icon-4"];
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
