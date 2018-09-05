//
//  ProDetailMessTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/5.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ProDetailMessTableViewCell.h"

@implementation ProDetailMessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.text = @"商品信息";
    self.detailWebView.backgroundColor = [UIColor clearColor];
//    self.detailWebView.opaque = NO;
//    self.detailWebView.userInteractionEnabled = NO;
//    self.detailWebView.scrollView.bounces = NO;
//    self.detailWebView.paginationBreakingMode = UIWebPaginationBreakingModePage;
//    self.detailWebView.scalesPageToFit = YES;
    self.detailWebView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth,oldheight;"
         "var maxwidth=300;"// 图片宽度
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "myimg.width = maxwidth;"
         "}"
         "}"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"webView的高度-----%f",documentHeight);
    self.detailWebViewWidth.constant = documentHeight;
    if (_transVaule) {
        _transVaule(documentHeight);
    }
}



@end
