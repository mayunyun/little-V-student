//
//  BuyCarCell.m
//  lx
//
//  Created by 邱 德政 on 16/1/19.
//  Copyright © 2016年 lx. All rights reserved.
//

#import "BuyCarCell.h"
#import "UIViewExt.h"

#import "UIImageView+WebCache.h"
@implementation BuyCarCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initView{
    
    _selectImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20, 135)];
    _selectImg.contentMode = UIViewContentModeScaleAspectFit;
    _selectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
    [self.contentView addSubview:_selectImg];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 85, 85)];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right + 10, 10, mScreenWidth/2, 20)];
    [self.contentView addSubview:_titleLabel];
    
    _pickupLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right, 10, mScreenWidth - mScreenWidth/2 - 130, 20)];
    _pickupLabel.adjustsFontSizeToFitWidth = YES;
    _pickupLabel.numberOfLines = 0;
    _pickupLabel.textAlignment = NSTextAlignmentRight;
    _pickupLabel.font = [UIFont systemFontOfSize:13];
    _pickupLabel.textColor = GrayTitleColor;
    [self.contentView addSubview:_pickupLabel];
    

    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right + 10, _titleLabel.bottom + 5, mScreenWidth - 135, 20)];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_priceLabel];

    
    _activeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.left + 10, _imgView.bottom + 5, mScreenWidth/2 - 40, 20)];
    _activeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_activeLabel];
    //小记
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(mScreenWidth/2, _imgView.bottom + 5, mScreenWidth/2 - 50, 20)];
    _moneyLabel.font = [UIFont systemFontOfSize:14];
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_moneyLabel];
    
    
    
    
    
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    NSString *urlStr;

     urlStr = [NSString stringWithFormat:@"%@/%@/%@",Image_Path,_model.folder,_model.picname];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    if ([_model.pickupway integerValue] == 1) {
        _pickupLabel.text = @"自取";
    }else {
        _pickupLabel.text = @"配送";
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@",_model.proname];
    _specLabel.text = [NSString stringWithFormat:@"%@",_model.count];
    if ([self.model.isgolds integerValue] == 1) {
       _priceLabel.text = [NSString stringWithFormat:@"金币 %.2f/%@",[_model.saleprice doubleValue],_model.prounitname];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f/%@",[_model.saleprice doubleValue],_model.prounitname];
    }
    //_countLabel.text = [NSString stringWithFormat:@"%@",_model.num];
    double prosummony = [_model.totalprice doubleValue];
    _moneyLabel.text = [NSString stringWithFormat:@"小计:%.2f",prosummony];
    NSInteger select = [_model.select integerValue];
    if (select == 1) {
        _selectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
    }else{
        _selectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
    }
    
    
}


@end
