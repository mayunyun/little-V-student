//
//  HomeHotCollectionView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/11.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeHotCollectionView.h"
#import "CommonCollectionViewCell.h"
#import "getHotProductModel.h"

@interface HomeHotCollectionView ()
{
    CGFloat _width;
    CGFloat _height;
}
@end

@implementation HomeHotCollectionView

- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0; //列间距
    flowLayout.minimumLineSpacing = 0;//行间距
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        //隐藏滑块
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //设置背景颜色（默认黑色）
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        //注册单元格
        //        [self registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCellID"];
        _width = self.frame.size.width;
        _height = self.frame.size.height;
        //注册单元格
        [self registerNib:[UINib nibWithNibName:@"HomeSelarCell" bundle:nil] forCellWithReuseIdentifier:@"HomeSelarCellID"];
    }
    
    return self;
}

//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    //    CustomCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellID" forIndexPath:indexPath];
    static NSString *HomeSelarCellID = @"CommonCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"CommonCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    CommonCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [self framAdd:cell];
    if (_dataArr.count!=0) {
        getHotProductModel* model = _dataArr[indexPath.row];
        model.proname = [self convertNull:model.proname];
        model.price = [self convertNull:model.price];
        model.prosale = [self convertNull:model.prosale];
        
        cell.titleLabel.text = nil;
        cell.prictLabel.text = nil;
        cell.saleCountLabel.text = nil;
        cell.imgView.image = nil;
        cell.titleLabel.text = model.proname;
        if (!IsEmptyValue1(model.price)) {
            model.price = [NSString stringWithFormat:@"%@",model.price];
            cell.prictLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price doubleValue]];
        }else{
            cell.prictLabel.text = [NSString stringWithFormat:@"￥0"];
        }
        if (!IsEmptyValue1(model.prosale)) {
            cell.saleCountLabel.text = [NSString stringWithFormat:@"销量%@",model.prosale];//@"销量200";
        }else{
            cell.saleCountLabel.text = [NSString stringWithFormat:@"销量0"];//@"销量200";
        }
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
//        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"] completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
//            
//            CGSize newSize;
//            CGImageRef imageRef =nil;
//            
//            if ((image.size.width / image.size.height) < 1) {
//                newSize.width = image.size.width;
//                newSize.height = image.size.width ;
//                
//                imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0,fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//                
//            } else {
//                newSize.height = image.size.height;
//                newSize.width = image.size.height *1;
//                
//                imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//                
//            }
//            
//            
//            
//            cell.imgView.image =[UIImage imageWithCGImage:imageRef];
//            
//        }];
    }

    
//    cell.titleLabel.text = @"汤成倍健蛋白粉";
//    cell.imgView.image = [UIImage imageNamed:@"default_img_cell"];
//    cell.saleCountLabel.text = @"销量200";
//    cell.prictLabel.text = @"￥10.00";
    
    return cell;
    
}

//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

- (void)framAdd:(id)sender
{
    CALayer *layer = [sender layer];
    layer.borderColor = SecondBackGorundColor.CGColor;
    layer.borderWidth = .5f;
    //    //添加四个边阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(0,0);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius = 10.0;//给imageview添加阴影和边框
    //    //添加两个边的阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(4,4);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius=2.0;
    
}

-(NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}

@end
