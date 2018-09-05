//
//  BWEditorVC.h
//  BAOWEN
//
//  Created by 山东三米 on 13-10-12.
//  Copyright (c) 2013年 山东三米. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "XtomConst.h"
#import "AllVC.h"

typedef enum
{
    BWEditorTypeSinleInput = 0,
    BWEditorTypeNormalPick,
}BWEditorType;

@protocol EditerDelegate;
@interface BWEditorVC : AllVC<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,assign)BWEditorType editorType;
@property(nonatomic,copy)NSString *key;//传过来的关键值
@property(nonatomic,copy)NSString *title;//导航title
//普通输入的样式
@property(nonatomic,copy)NSString *content;//默认的内容
@property(nonatomic,copy)NSString *explanation;//说明文字 输入框下面的提示文字
@property(nonatomic,copy)NSString *placeholder;//如果内容为空的时候，输入框内的输入文字
@property(nonatomic,assign)NSInteger mymaxlength;//输入框的最大长度
@property(nonatomic,assign)UIKeyboardType keyBoardType;//输入框的键盘格式
//普通拾取器的样式
@property(nonatomic,retain)NSMutableArray *dataSource;//picker 数据源
@property(nonatomic,assign)NSObject<EditerDelegate>* delegate;
@end

@protocol EditerDelegate <NSObject>
-(void)inforEditer:(BWEditorVC*)inforEditer backValue:(NSString*)value;
@end
