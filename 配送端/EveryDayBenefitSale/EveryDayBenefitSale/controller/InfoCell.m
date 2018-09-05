//
//  InfoCell.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 17/1/21.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        hortable = [[UITableView alloc]initWithFrame:CGRectMake(22, -22, 276, 320) style:UITableViewStylePlain];//由于使用了仿射变换，所以这里的frame显得很诡异，慢慢调吧～
        hortable.delegate = self;
        hortable.dataSource = self;
        hortable.layer.borderColor = [UIColor blackColor].CGColor;
        hortable.layer.borderWidth = 1;
        hortable.transform = CGAffineTransformMakeRotation(M_PI / 2 *3);
        hortable.separatorColor = [UIColor redColor];
        hortable.decelerationRate = UIScrollViewDecelerationRateFast;
        hortable.showsHorizontalScrollIndicator = NO;
        hortable.showsVerticalScrollIndicator = NO;
        [self addSubview:hortable];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.backgroundColor = [UIColor orangeColor];
    }
    //在这里添加你的view，就是那些UITableView，<span style="color:#ff0000">注意，关键在这里：如果添加到cell上的table需要下拉刷新，如果不想滑动时间出现冲突，要保证cell上的UITableView的contentoffset 不等于0和不便宜到最底部，这样下拉刷新才没有问题，例如 当<span style="font-family:Arial,Helvetica,sans-serif">contentoffset.y = 0时候，使其等于1。不然背景的table就会跟着一起滚动，达不到下拉刷新的效果</span></span>
    
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return mScreenWidth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击%ld",(long)[indexPath row]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
