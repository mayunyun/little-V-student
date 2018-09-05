//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>
#import "XtomConst.h"
#import "BBButton.h"

#define CORNER_RADIUS 10.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 1.0f
#define FONT_SIZE 13.0f
#define HORIZONTAL_PADDING 1.0f
#define VERTICAL_PADDING 1.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f

@implementation DWTagList

@synthesize view, textArray;
@synthesize lastVC;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}

- (void)display
{
    for (BBButton *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {
        //CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
        CGSize textSize = [XtomFunction getSizeWithStrNo:text width:self.frame.size.width font:FONT_SIZE];
        //NSLog(@"你猜:%f",textSize.width);
        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
        BBButton *label = nil;
        if (!gotPreviousFrame) {
            label = [[BBButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                //NSLog(@"你猜aaaa:%f,%f",previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN,self.frame.size.width);
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            label = [[BBButton alloc] initWithFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        if (!lblBackgroundColor) {
            [label setBackgroundColor:[UIColor clearColor]];
        } else {
            [label setBackgroundColor:lblBackgroundColor];
        }
        [label setTitle:text forState:UIControlStateNormal];
        [label setTitleColor:BB_Blue_Color forState:UIControlStateNormal];
        /*
        [label.titleLabel setTextColor:TEXT_COLOR];
        [label.titleLabel setText:text];
        [label.titleLabel setTextAlignment:UITextAlignmentCenter];
        [label.titleLabel setShadowColor:TEXT_SHADOW_COLOR];
        [label.titleLabel setShadowOffset:TEXT_SHADOW_OFFSET];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:CORNER_RADIUS];
        [label.layer setBorderColor:BORDER_COLOR];
        [label.layer setBorderWidth: BORDER_WIDTH];
         */
        [self addSubview:label];
        
        //按钮点击
        [label setBackgroundImage:[UIImage imageNamed:@"white_color_here.png"] forState:UIControlStateHighlighted];
        label.btnId = text;
        [label addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
}
-(void)gotoHome:(BBButton*)sender
{
    
}
- (CGSize)fittedSize
{
    return sizeFit;
}

@end
