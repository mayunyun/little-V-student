//
//  ThirdAddressPickerView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ThirdAddressPickerView.h"
#import "VillageModel.h"
#import "CommunityModel.h"
#import "RoomnumberModel.h"
#define SECONDNUM 3
#define PickerHeight 162


@interface ThirdAddressPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate>
{
    UIPickerView *_secondpicker;
    UIButton *button;
    UIButton *closeBtn;
    
    NSMutableArray *village;
    NSMutableArray *community;
    NSMutableArray *roomnumber;
    NSString* _selectProvinceStr;
}
@property (nonatomic,assign)ThirdAddressPickerViewModel* addmodel;

@end


@implementation ThirdAddressPickerView

- (instancetype)initWithFrame:(CGRect)frame Id:(NSString*)villageid
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        village = [[NSMutableArray alloc]init];
        community = [[NSMutableArray alloc]init];
        roomnumber = [[NSMutableArray alloc]init];
        _selectProvinceStr = @"0";
        if (!IsEmptyValue1(villageid)) {
            //数据请求
            [self VillageRequest:villageid];
        }
        CGRect cgrectFrame = CGRectMake(0, 0, frame.size.width, PickerHeight);
        _secondpicker = [[UIPickerView alloc] initWithFrame: cgrectFrame];
        _secondpicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; //这里设置了就可以自定义高度了，一般默认是无法修改其216像素的高度
        _secondpicker.dataSource = self;
        _secondpicker.delegate = self;
        _secondpicker.showsSelectionIndicator = YES;
        [_secondpicker selectRow: 0 inComponent: 0 animated: YES];
        [self addSubview: _secondpicker];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 37, self.bounds.size.width, 1)];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [closeBtn setFrame:CGRectMake(20+(self.frame.size.width - 40)/2, self.frame.size.height - 35, (self.frame.size.width - 40)/2, 30)];
        [self addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button = [UIButton buttonWithType: 100];
        [button setTitle: @"确定" forState: UIControlStateNormal];
        [button setFrame:CGRectMake(20, self.frame.size.height - 35, (self.frame.size.width - 40)/2, 30)];
        [button setTintColor: [UIColor grayColor]];
        [button addTarget: self action: @selector(buttobClicked:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: button];
        
        UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(button.right, button.top, 1, 28)];
        line1.backgroundColor = LineColor;
        [self addSubview:line1];
        
    }
    return self;
}

#pragma mark- button clicked

- (void) buttobClicked:(UIButton*)sender {
    NSInteger villageIndex = [_secondpicker selectedRowInComponent:HOUSE_COMPONENT];
    NSInteger commuinityIndex = [_secondpicker selectedRowInComponent:COMUNITY_COMPONENT];
    NSInteger roomnumberIndex = [_secondpicker selectedRowInComponent:ROOMNUMBER_COMPONENT];
    NSString *villageStr;
    NSString *village_id;
    if (village.count!=0) {
        VillageModel* villaremodel = [[VillageModel alloc]init];
        villaremodel = village[villageIndex];
        villageStr = villaremodel.name;
        village_id = villaremodel.Id;
    }
    NSString *communityStr;
    NSString *community_id;
    if (community.count!=0) {
        CommunityModel* commModel = [[CommunityModel alloc]init];
        commModel = community[commuinityIndex];
        communityStr = commModel.name;
        community_id = commModel.Id;
    }
    NSString *roomnumberStr;
    NSString *roomnumber_id;
    if (roomnumber.count!=0) {
        RoomnumberModel* roomModel = [[RoomnumberModel alloc]init];
        roomModel = roomnumber[roomnumberIndex];
        roomnumberStr = roomModel.name;
        roomnumber_id = roomModel.Id;
    }
    
    ThirdAddressPickerViewModel* model = [[ThirdAddressPickerViewModel alloc]init];
    model.village = villageStr;
    model.comunity = communityStr;
    model.roomnumber = roomnumberStr;
    model.village_id = village_id;
    model.comunity_id = community_id;
    model.roomnumber_id = roomnumber_id;
    NSLog(@"=====%@%@%@",model.village,model.comunity,model.roomnumber);
    //    通过block反向传值
    if (_transVaule) {
        _transVaule(model,YES);
    }
}

- (void)closeBtnClick:(UIButton*)sender
{
    NSInteger villageIndex = [_secondpicker selectedRowInComponent:HOUSE_COMPONENT];
    NSInteger commuinityIndex = [_secondpicker selectedRowInComponent:COMUNITY_COMPONENT];
    NSInteger roomnumberIndex = [_secondpicker selectedRowInComponent:ROOMNUMBER_COMPONENT];
    NSString *villageStr;
    NSString *village_id;
    if (village.count!=0) {
        VillageModel* villaremodel = [[VillageModel alloc]init];
        villaremodel = village[villageIndex];
        villageStr = villaremodel.name;
        village_id = villaremodel.Id;
    }
    NSString *communityStr;
    NSString *community_id;
    if (community.count!=0) {
        CommunityModel* commModel = [[CommunityModel alloc]init];
        commModel = community[commuinityIndex];
        communityStr = commModel.name;
        community_id = commModel.Id;
    }
    NSString *roomnumberStr;
    NSString *roomnumber_id;
    if (roomnumber.count!=0) {
        RoomnumberModel* roomModel = [[RoomnumberModel alloc]init];
        roomModel = roomnumber[roomnumberIndex];
        roomnumberStr = roomModel.name;
        roomnumber_id = roomModel.Id;
    }
    
    ThirdAddressPickerViewModel* model = [[ThirdAddressPickerViewModel alloc]init];
    model.village = villageStr;
    model.comunity = communityStr;
    model.roomnumber = roomnumberStr;
    model.village_id = village_id;
    model.comunity_id = community_id;
    model.roomnumber_id = roomnumber_id;
    NSLog(@"=====%@%@%@",model.village,model.comunity,model.roomnumber);
    //    通过block反向传值
    if (_transVaule) {
        _transVaule(model,NO);
    }
    
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _secondpicker) {
        return SECONDNUM;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _secondpicker) {
        if (component == HOUSE_COMPONENT){
            return [village count];
        }else if (component == COMUNITY_COMPONENT){
            return [community count];
        }else if (component == ROOMNUMBER_COMPONENT){
            return [roomnumber count];
        }
    }
    return 0;
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _secondpicker) {
        if (component == HOUSE_COMPONENT){
            return [village objectAtIndex:row];
        }else if (component == COMUNITY_COMPONENT){
            return [community objectAtIndex:row];
        }else if (component == ROOMNUMBER_COMPONENT){
            return [roomnumber objectAtIndex:row];
        }
    }
    return 0;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _secondpicker) {
        if (component == HOUSE_COMPONENT) {
            if (village.count!=0) {
                VillageModel* model = village[row];
                [self LoadcommunityRequestData:model.Id];
            }
            [pickerView selectRow: row inComponent: HOUSE_COMPONENT animated: YES];
            [pickerView reloadComponent: HOUSE_COMPONENT];
            [pickerView selectRow: 0 inComponent: COMUNITY_COMPONENT animated: YES];
            [pickerView reloadComponent: COMUNITY_COMPONENT];
            [pickerView selectRow:0 inComponent:ROOMNUMBER_COMPONENT animated:YES];
            [pickerView reloadComponent:ROOMNUMBER_COMPONENT];
            
        }else if (component == COMUNITY_COMPONENT){
            if (community.count!=0) {
                CommunityModel* model = community[row];
                [self LoadroomnumberRequestData:model.Id];
            }
            [pickerView selectRow: row inComponent: COMUNITY_COMPONENT animated: YES];
            [pickerView reloadComponent: COMUNITY_COMPONENT];
            [pickerView selectRow:0 inComponent:ROOMNUMBER_COMPONENT animated:YES];
            [pickerView reloadComponent:ROOMNUMBER_COMPONENT];
        }else if (component == ROOMNUMBER_COMPONENT){
            [pickerView selectRow: row inComponent:ROOMNUMBER_COMPONENT animated:YES];
            [pickerView reloadComponent:ROOMNUMBER_COMPONENT];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 15;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView == _secondpicker) {
        if (component == HOUSE_COMPONENT){
            return (pickerView.frame.size.width - 20)/SECONDNUM;
        }else if (component == COMUNITY_COMPONENT){
            return (pickerView.frame.size.width - 20)/SECONDNUM;
        }else if (component == ROOMNUMBER_COMPONENT){
            return (pickerView.frame.size.width - 20)/SECONDNUM;
        }
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    if (pickerView == _secondpicker) {
        if(component == HOUSE_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/SECONDNUM, 30)];
            myView.adjustsFontSizeToFitWidth = YES;
            myView.numberOfLines = 0;
            myView.textAlignment = NSTextAlignmentCenter;
            if (village.count!=0) {
                VillageModel* model = [village objectAtIndex:row];
                myView.text = model.name;
            }
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
            
        }else if (component == COMUNITY_COMPONENT){
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/SECONDNUM, 30)];
            myView.adjustsFontSizeToFitWidth = YES;
            myView.numberOfLines = 0;
            myView.textAlignment = NSTextAlignmentCenter;
            if (community.count!=0) {
                CommunityModel* model = [community objectAtIndex:row];
                myView.text = model.name;
            }
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }else if (component == ROOMNUMBER_COMPONENT){
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/SECONDNUM, 30)];
            myView.adjustsFontSizeToFitWidth = YES;
            myView.numberOfLines = 0;
            myView.textAlignment = NSTextAlignmentCenter;
            if (roomnumber.count!=0) {
                RoomnumberModel* model = [roomnumber objectAtIndex:row];
                myView.text = model.name;
            }
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }

    }
    return myView;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入详细地址"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入详细地址";
        textView.textColor = GrayTitleColor;
    }else if (textView.text.length>100){
        UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"字符不能超过200" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aleartView show];
    }
}


//业务中心数据请求
- (void)VillageRequest:(NSString*)centerID
{
    /*
     /areamanage/loadhousenumber.do
     servicecenterid
     */
    /*
     areamanage/loadhousenumber.do
     villageid
     */
    [village removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadhousenumber.do?villageid=%@",ROOT_Path,centerID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"VillageArray%@",array);
        for (int i =0; i <array.count; i++) {
            VillageModel* model = [[VillageModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [village addObject:model];
        }
        [_secondpicker reloadComponent:HOUSE_COMPONENT];
        
        NSInteger centerIndex = [_secondpicker selectedRowInComponent:HOUSE_COMPONENT];
        NSLog(@"业务中心点击了第%ld个",(long)centerIndex);
        if (village.count!=0) {
            VillageModel* model = village[centerIndex];
            [self LoadcommunityRequestData:model.Id];
        }else{
            [community removeAllObjects];
            [_secondpicker reloadComponent:COMUNITY_COMPONENT];
            [roomnumber removeAllObjects];
            [_secondpicker reloadComponent:ROOMNUMBER_COMPONENT];
        }
        //        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        //        [_hud hide:YES];
    }];
    
}
//小区
- (void)LoadcommunityRequestData:(NSString*)housenumid{
    /*
     /areamanage/loadcommunity.do
     housenumberid
     */
    /*
    areamanage/loadcommunity.do
     housenumberid
     */
    [community removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadcommunity.do?housenumberid=%@",ROOT_Path,housenumid];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"community%@",array);
        for (int i =0; i <array.count; i++) {
            CommunityModel* model = [[CommunityModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [community addObject:model];
        }
        [_secondpicker reloadComponent:COMUNITY_COMPONENT];
        NSInteger centerIndex = [_secondpicker selectedRowInComponent:COMUNITY_COMPONENT];
        NSLog(@"小区点击了第%ld个",(long)centerIndex);
        if (community.count!=0) {
            CommunityModel* model = community[centerIndex];
            [self LoadroomnumberRequestData:model.Id];
        }else{
            [roomnumber removeAllObjects];
            [_secondpicker reloadComponent:ROOMNUMBER_COMPONENT];
        }
        //        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        //        [_hud hide:YES];
    }];
    
    
}

//楼号
- (void)LoadroomnumberRequestData:(NSString*)communityid{
    /*
     /areamanage/loadroomnumber.do
     comunityid
     */
    [roomnumber removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadroomnumber.do?comunityid=%@",ROOT_Path,communityid];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"community%@",array);
        for (int i =0; i <array.count; i++) {
            RoomnumberModel* model = [[RoomnumberModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [roomnumber addObject:model];
        }
        [_secondpicker reloadComponent:ROOMNUMBER_COMPONENT];
        //        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        //        [_hud hide:YES];
    }];
    
}








@end
