//
//  TagCollectionViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) NSString *content;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

+ (CGSize) getSizeWithContent:(NSString *) content maxWidth:(CGFloat)maxWidth customHeight:(CGFloat)cellHeight;

@end
