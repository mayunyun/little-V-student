//
//  HomeIconsCollectionView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/21.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeIconsCollectionView.h"
#import "IconsCollectionViewCell.h"
#import "getAllProductTypeModel.h"


@interface HomeIconsCollectionView ()
{
    CGFloat _width;
    CGFloat _height;
}
@end

@implementation HomeIconsCollectionView

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
        _width = self.frame.size.width;
        _height = self.frame.size.height;
        //注册单元格
        [self registerNib:[UINib nibWithNibName:@"IconsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IconsCollectionViewCellID"];
    }
    
    return self;
}

//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count+2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    //    CustomCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellID" forIndexPath:indexPath];
    static NSString *HomeSelarCellID = @"IconsCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"IconsCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    IconsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
//    [self framAdd:cell];

    cell.imgView.image = nil;
    cell.titleLabel.text = nil;
    if (_dataArr.count!=0) {
//        if (indexPath.row >= _dataArr.count) {
//            if (indexPath.row == 6) {
//                cell.imgView.image = [UIImage imageNamed:@"icon-j"];
//                cell.titleLabel.text = @"金币商城";
//            }else if (indexPath.row == 7){
//                cell.imgView.image = [UIImage imageNamed:@"icon-k"];
//                cell.titleLabel.text = @"全部";
//            }
//        }else{
            getAllProductTypeModel* model = _dataArr[indexPath.row];
            cell.titleLabel.text = model.name;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
            
//            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"] completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
//                
//                CGSize newSize;
//                CGImageRef imageRef =nil;
//                
//                if ((image.size.width / image.size.height) < 1) {
//                    newSize.width = image.size.width;
//                    newSize.height = image.size.width ;
//                    
//                    imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0,fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//                    
//                } else {
//                    newSize.height = image.size.height;
//                    newSize.width = image.size.height *1;
//                    
//                    imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//                    
//                }
//                
//                
//                
//                cell.imgView.image =[UIImage imageWithCGImage:imageRef];
//                
//            }];
//        }
    }
    
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
    layer.borderColor = [UIColor lightGrayColor].CGColor;
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
