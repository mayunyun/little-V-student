//
//  YYTextView.m
//  YYZZB
//
//  Created by 李朋 on 13-4-29.
//  Copyright (c) 2013年 中国山东三米. All rights reserved.
//

#import "BWTextView.h"

@implementation BWTextView
@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [placeHolderLabel release];placeHolderLabel = nil;
    [placeholderColor release];placeholderColor = nil;
    [placeholder release];placeholder = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setPlaceholder:@""];
    
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification*)notification
{
    if(0 == [[self placeholder] length])
        return;
    if(0 == [[self text] length])
       [[self viewWithTag:999] setAlpha:1.0f];
    else
        [[self viewWithTag:999] setAlpha:0.0f];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if([[self placeholder] length]>0)
    {
        if(!placeHolderLabel)
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, self.bounds.size.width - 14, 0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:placeHolderLabel];
        }
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];

    }
    if(0 == [[self text] length]&&[[self placeholder] length] > 0)
    {
        [[self viewWithTag:999] setAlpha:1.0f];
    }
    [super drawRect:rect];
}


@end
