//
//  BuyCarTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/13.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BuyCarTableViewCell.h"

@implementation BuyCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _selectBtn.layer.masksToBounds = YES;
//    _selectBtn.layer.cornerRadius = _selectBtn.bounds.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
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
    _typeLab.text = [NSString stringWithFormat:@"%@",_model.type];
    if ([[NSString stringWithFormat:@"%@",_model.type] isEqualToString:@"<null>"]) {
        _typeLab.text = @"";
    }
    _countLabel.text = [NSString stringWithFormat:@"%@",_model.count];
//    if ([self.model.isgolds integerValue] == 1) {
//        _priceLabel.text = [NSString stringWithFormat:@"金币 %.2f/%@",[_model.saleprice doubleValue],_model.prounitname];
//    }else{
//        _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f/%@",[_model.saleprice doubleValue],_model.prounitname];
//    }
    //相当于没有没有单价。
//    double prosummony = [_model.totalprice doubleValue];
//    _moneyLabel.text = [NSString stringWithFormat:@"小计:%.2f",prosummony];
    if ([self.model.isgolds integerValue] == 1) {
        _priceLabel.text = [NSString stringWithFormat:@"金币 %.2f",[_model.totalprice doubleValue]];
    }else{
        _model.totalprice = [NSString stringWithFormat:@"%@",_model.totalprice];
        _priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[_model.totalprice doubleValue]];
    }
    NSInteger select = [_model.select integerValue];
    if (select == 1) {
        [_selectBtn setImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"weixuanzhong.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)selectBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(selectAction:)]) {
        [_delegate selectAction:sender];
    }
}
- (IBAction)delClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(del:)]) {
        [_delegate del:sender];
    }
}


- (IBAction)reduceClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(reduceClick:)]) {
        [_delegate reduceClick:sender];
    }
}
- (IBAction)addClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(addClick:)]) {
        [_delegate addClick:sender];
    }
}
@end
