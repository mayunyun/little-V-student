//
//  BWEditorVC.m
//  BAOWEN
//
//  Created by 山东三米 on 13-10-12.
//  Copyright (c) 2013年 山东三米. All rights reserved.
//

#import "BWEditorVC.h"
#import "Navbar.h"

@interface BWEditorVC ()
@property (nonatomic,retain)UIView *backView;//白色背景框
@property (nonatomic,retain)UITextField *myTextField;
@property (nonatomic,retain)UILabel *myLabel;//下面的提示语句
@property (nonatomic,retain)UIPickerView *myPicker;//选择器
@end

@implementation BWEditorVC
@synthesize editorType;
@synthesize key;
@synthesize title;
@synthesize content;
@synthesize explanation;
@synthesize placeholder;
@synthesize mymaxlength;
@synthesize keyBoardType;
@synthesize dataSource;
@synthesize delegate;

//私有的
@synthesize backView;
@synthesize myTextField;
@synthesize myLabel;
@synthesize myPicker;

-(void)dealloc
{
    [key release];key = nil;
    [title release];title = nil;
    [content release];content = nil;
    [explanation release];explanation = nil;
    [placeholder release];placeholder = nil;
    [dataSource release];dataSource = nil;
    
    [backView release];backView = nil;
    [myTextField release];myTextField = nil;
    [myLabel release];myLabel = nil;
    [myPicker release];myPicker = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self loadSet];
}
-(void)loadSet
{
    //导航
    [self.navigationItem setNewTitle:title];
    [self.view setBackgroundColor:BB_Back_Color_Here];
    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"返回.png" imageH:@"返回-点击.png"];
    if (BWEditorTypeNormalPick == editorType)
    {
        [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) title:@"完成"];
    }
    
    //白色背景
    self.backView = [[[UIView alloc]init]autorelease];
    backView.frame = CGRectMake(8, 10, 304, 40);
    [backView setBackgroundColor:BB_White_Color];
    [XtomFunction addbordertoView:backView radius:1.0f width:1.f color:BB_Border_Color];
    [self.view addSubview:backView];
    
    //输入框
    self.myTextField = [[[UITextField alloc]initWithFrame:CGRectMake(10, 5, 284, 30)]autorelease];
    myTextField.delegate = self;
    myTextField.placeholder = placeholder;
    myTextField.text = content;
    myTextField.keyboardType = self.keyBoardType;
    myTextField.returnKeyType = UIReturnKeyDone;
    myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myTextField.textAlignment = NSTextAlignmentLeft;
    myTextField.font = [UIFont systemFontOfSize:14];
    myTextField.textColor = [UIColor grayColor];
    [backView addSubview:myTextField];
    
    //提示语
    self.myLabel = [[[UILabel alloc]init]autorelease];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.textAlignment = NSTextAlignmentRight;
    myLabel.font = [UIFont systemFontOfSize:12];
    myLabel.frame = CGRectMake(0, backView.frame.size.height+15, 312, 14);
    myLabel.userInteractionEnabled = NO;
    myLabel.textColor = [UIColor grayColor];
    myLabel.text = explanation;
    [self.view addSubview:myLabel];
    
    //选择器
    self.myPicker = [[[UIPickerView alloc]init]autorelease];
    myPicker.dataSource = self;
    myPicker.delegate = self;
    [myPicker reloadAllComponents];
    myPicker.showsSelectionIndicator = YES;
    myPicker.frame = CGRectMake(0.0f, UI_View_Hieght-216.0f, 320.0f, 216.0f);
    [self.view addSubview:myPicker];
    
    if (BWEditorTypeSinleInput == editorType)
    {
        [myTextField becomeFirstResponder];
        [myPicker setHidden:YES];
    }
    if (BWEditorTypeNormalPick == editorType)
    {
        [myTextField setEnabled:NO];
        [myLabel setHidden:YES];
        for(int i = 0;i<dataSource.count;i++)
        {
            if([myTextField.text isEqualToString:[dataSource objectAtIndex:i]])
            {
                [myPicker selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
    }
}
-(void)loadData
{
    
}
#pragma mark- 自定义
#pragma mark 事件
-(void)leftbtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightbtnPressed:(id)sender
{
    [self okGoback];
}
//点击完成
-(void)okGoback
{
    NSString *temStr = myTextField.text;
    if (myTextField.text.length >= mymaxlength)
    {
        temStr = [myTextField.text substringWithRange:NSMakeRange(0, mymaxlength)];
    }
    [delegate inforEditer:self backValue:temStr];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Touch delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[myTextField resignFirstResponder];
}
#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [myTextField resignFirstResponder];
    [self okGoback];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}
#pragma mark- UIPickerView Datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dataSource.count;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataSource objectAtIndex:row];
}
#pragma mark- UIPickerView Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    myTextField.text = [dataSource objectAtIndex:row];
}
@end
