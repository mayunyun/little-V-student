

//
//  Created by YeJian on 13-8-12.
//  Copyright (c) 2013年 YeJian. All rights reserved.
//

#define SysNavbarHeight 44

#define DefaultStateBarColor [UIColor blackColor]
#define DefaultStateBarSytle UIBarStyleBlackOpaque

#import <UIKit/UIKit.h>

@interface Navbar : UINavigationBar

 /**< 适用于ios7*/
@property (nonatomic,strong)UIColor *stateBarColor;/**< 默认black*/
@property (nonatomic,assign)UIBarStyle cusBarStyele;/**< 默认UIBarStyleBlackOpaque*/

- (void)setDefault;
@end

/**
 * @brief 自定义barbuttonitem
 *
 * @param
 * @return 
 */

#define BackgroundImage @"bb_greenColor.png"
//#define ItemSelectedImage @"bar_back_new_s.png"
#define ItemSelectedImage @""
//#define BackItemImage @"bar_back_new.png"




//#define ItemImage @"bar_back_new.png"
#define ItemImage @""
#define BackItemSelectedImage @"bar_back_new_s.png"
#define ItemImageEnabled @"no_click.png"
//#define ItemTextNormalColot [UIColor whiteColor]
#import "XtomConst.h"

typedef enum
{
    NavBarButtonItemTypeDefault = 0,
    NavBarButtonItemTypeBack = 1,
    NavBarButtonItemTypeNone = 2
}NavBarButtonItemType;
@interface NavBarButtonItem : NSObject
@property (nonatomic,assign)NavBarButtonItemType itemType;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)NSString *imageH;
@property (nonatomic,strong)UIFont *font;
@property (nonatomic,strong)UIColor *normalColor;
@property (nonatomic,strong)UIColor *selectedColor;
@property (nonatomic,strong)id target;
@property (nonatomic,assign)SEL selector;
@property (nonatomic,assign)BOOL highlightedWhileSwitch;
- (id)initWithType:(NavBarButtonItemType)itemType;

+ (id)defauleItemWithTarget:(id)target
                     action:(SEL)action
                      title:(NSString *)title;
+ (id)defauleItemWithTarget:(id)target
                     action:(SEL)action
                      image:(NSString *)image imageH:(NSString *)imageH;
+ (id)backItemWithTarget:(id)target
                  action:(SEL)action
                   title:(NSString *)title;
- (void)setTarget:(id)target withAction:(SEL)action;
@end
@interface UINavigationItem (CustomBarButtonItem)<UIGestureRecognizerDelegate>

- (void)setNewTitle:(NSString *)title;
- (void)setNewTitleImage:(UIImage *)image;
- (void)setLeftItemWithTarget:(id)target
                       action:(SEL)action
                        title:(NSString *)title;
- (void)setLeftItemWithTarget:(id)target
                       action:(SEL)action
                        image:(NSString *)image imageH:(NSString *)imageH;
- (void)setLeftItemWithButtonItem:(NavBarButtonItem *)item;
- (void)setRightItemWithTarget:(id)target
                        action:(SEL)action
                         title:(NSString *)title;
- (void)setRightItemWithTarget:(id)target
                        action:(SEL)action
                         image:(NSString *)image imageH:(NSString *)imageH;
- (void)setRightItemWithButtonItem:(NavBarButtonItem *)item;
- (void)setBackItemWithTarget:(id)target
                       action:(SEL)action;
- (void)setBackItemWithTarget:(id)target
                       action:(SEL)action
                        title:(NSString *)title;
@end
