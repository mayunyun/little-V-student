//
//  SevenAddressPickerView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "SevenAddressPickerView.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"
#import "ServiceCenterModel.h"
#import "VillageModel.h"
#import "CommunityModel.h"
#import "RoomnumberModel.h"

#define FIRSTNUM 4
#define SECONDNUM 3
#define PickerHeight 162

@interface SevenAddressPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate>
{
    UIPickerView *_picker;
    UIPickerView *_secondpicker;
    UIButton *button;
    UIButton *closeBtn;
    
    NSMutableArray *province;
    NSMutableArray *city;
    NSMutableArray *district;
    NSMutableArray *sevicecenter;
    NSMutableArray *village;
    NSMutableArray *community;
    NSMutableArray *roomnumber;
    NSString* _selectProvinceStr;
}
@property (nonatomic,assign)SevenAddressPickerViewModel* addmodel;

@end

@implementation SevenAddressPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        province=[[NSMutableArray alloc] init];
        city=[[NSMutableArray alloc] init];
        district=[[NSMutableArray alloc] init];
        sevicecenter = [[NSMutableArray alloc]init];
        village = [[NSMutableArray alloc]init];
        community = [[NSMutableArray alloc]init];
        roomnumber = [[NSMutableArray alloc]init];
        _selectProvinceStr = @"0";
        //数据请求
        [self ProvinceRequest];
        
        CGRect cgrectFrame = CGRectMake(0, 0, frame.size.width, PickerHeight);
        _picker = [[UIPickerView alloc] initWithFrame: cgrectFrame];
        _picker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; //这里设置了就可以自定义高度了，一般默认是无法修改其216像素的高度
        _picker.dataSource = self;
        _picker.delegate = self;
        _picker.showsSelectionIndicator = YES;
        [_picker selectRow: 0 inComponent: 0 animated: YES];
        [self addSubview: _picker];
        
        CGRect secondFrame = CGRectMake(0, PickerHeight - 60, frame.size.width, PickerHeight);
        _secondpicker = [[UIPickerView alloc]initWithFrame:secondFrame];
        NSLog(@"_secondpicker ----- %f%f%f%f ------- %f",_secondpicker.frame.origin.x,_secondpicker.frame.origin.y,_secondpicker.frame.size.width,_secondpicker.frame.size.height,secondFrame.size.height);
        _secondpicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; //这里设置了就可以自定义高度了，一般默认是无法修改其216像素的高度
        _secondpicker.delegate = self;
        _secondpicker.dataSource = self;
        _secondpicker.showsSelectionIndicator = YES;
        [self addSubview:_secondpicker];
        
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
    NSInteger provinceIndex = [_picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [_picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [_picker selectedRowInComponent: DISTRICT_COMPONENT];
    NSInteger centerIndex = [_picker selectedRowInComponent:SERVICECENTER_COMPONENT];
    NSInteger villageIndex = [_secondpicker selectedRowInComponent:HOUSE_COMPONENT];
    NSInteger commuinityIndex = [_secondpicker selectedRowInComponent:COMUNITY_COMPONENT];
    NSInteger roomnumberIndex = [_secondpicker selectedRowInComponent:ROOMNUMBER_COMPONENT];
    NSString *provinceStr;
    NSString *province_id;
    if (province.count!=0) {
        ProvinceModel* promodel = [[ProvinceModel alloc]init];
        promodel = province[provinceIndex];
        provinceStr = promodel.name;
        province_id = promodel.Id;
    }
    NSString *cityStr;
    NSString *city_id;
    if (city.count!=0) {
        CityModel* citymodel = [[CityModel alloc]init];
        citymodel = city[cityIndex];
        cityStr = citymodel.name;
        city_id = citymodel.Id;
    }
    NSString *districtStr;
    NSString *district_id;
    if (district.count!=0) {
        AreaModel* areamodel = [[AreaModel alloc]init];
        areamodel = district[districtIndex];
        districtStr = areamodel.name;
        district_id = areamodel.Id;
    }
    NSString *centerStr;
    NSString *center_id;
    if (sevicecenter.count!=0) {
        ServiceCenterModel* centermodel = [[ServiceCenterModel alloc]init];
        centermodel = sevicecenter[centerIndex];
        centerStr = centermodel.name;
        center_id = centermodel.Id;
    }
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
    
    SevenAddressPickerViewModel* model = [[SevenAddressPickerViewModel alloc]init];
    model.province = provinceStr;
    model.city = cityStr;
    model.district = districtStr;
    model.sevicecenter = centerStr;
    model.village = villageStr;
    model.comunity = communityStr;
    model.roomnumber = roomnumberStr;
    model.province_id = province_id;
    model.city_id = city_id;
    model.district_id = district_id;
    model.sevicecenter_id = center_id;
    model.village_id = village_id;
    model.comunity_id = community_id;
    model.roomnumber_id = roomnumber_id;
    NSLog(@"=====%@%@%@%@%@%@%@",model.province,model.city,model.sevicecenter,model.district,model.village,model.comunity,model.roomnumber);
    //    通过block反向传值
    if (_transVaule) {
        _transVaule(model,YES);
    }
}

- (void)closeBtnClick:(UIButton*)sender
{
    NSInteger provinceIndex = [_picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [_picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [_picker selectedRowInComponent: DISTRICT_COMPONENT];
    NSInteger centerIndex = [_picker selectedRowInComponent:SERVICECENTER_COMPONENT];
    NSInteger villageIndex = [_secondpicker selectedRowInComponent:HOUSE_COMPONENT];
    NSInteger commuinityIndex = [_secondpicker selectedRowInComponent:COMUNITY_COMPONENT];
    NSInteger roomnumberIndex = [_secondpicker selectedRowInComponent:ROOMNUMBER_COMPONENT];
    NSString *provinceStr;
    NSString *province_id;
    if (province.count!=0) {
        ProvinceModel* promodel = [[ProvinceModel alloc]init];
        promodel = province[provinceIndex];
        provinceStr = promodel.name;
        province_id = promodel.Id;
    }
    NSString *cityStr;
    NSString *city_id;
    if (city.count!=0) {
        CityModel* citymodel = [[CityModel alloc]init];
        citymodel = city[cityIndex];
        cityStr = citymodel.name;
        city_id = citymodel.Id;
    }
    NSString *districtStr;
    NSString *district_id;
    if (district.count!=0) {
        AreaModel* areamodel = [[AreaModel alloc]init];
        areamodel = district[districtIndex];
        districtStr = areamodel.name;
        district_id = areamodel.Id;
    }
    NSString *centerStr;
    NSString *center_id;
    if (sevicecenter.count!=0) {
        ServiceCenterModel* centermodel = [[ServiceCenterModel alloc]init];
        centermodel = sevicecenter[centerIndex];
        centerStr = centermodel.name;
        center_id = centermodel.Id;
    }
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
    
    SevenAddressPickerViewModel* model = [[SevenAddressPickerViewModel alloc]init];
    model.province = provinceStr;
    model.city = cityStr;
    model.district = districtStr;
    model.sevicecenter = centerStr;
    model.village = villageStr;
    model.comunity = communityStr;
    model.roomnumber = roomnumberStr;
    model.province_id = province_id;
    model.city_id = city_id;
    model.district_id = district_id;
    model.sevicecenter_id = center_id;
    model.village_id = village_id;
    model.comunity_id = community_id;
    model.roomnumber_id = roomnumber_id;
     NSLog(@"=====%@%@%@%@%@%@%@",model.province,model.city,model.sevicecenter,model.district,model.village,model.comunity,model.roomnumber);
    //    通过block反向传值
    if (_transVaule) {
        _transVaule(model,NO);
    }
    
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _picker) {
        return FIRSTNUM;
    }else if (pickerView == _secondpicker){
        return SECONDNUM;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _picker) {
        if (component == PROVINCE_COMPONENT) {
            return [province count];
        }else if (component == CITY_COMPONENT) {
            return [city count];
        }else if (component == DISTRICT_COMPONENT){
            return [district count];
        }else if (component == SERVICECENTER_COMPONENT){
            return [sevicecenter count];
        }else {
            return 0;
        }
    }else if (pickerView == _secondpicker){
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
    if (pickerView == _picker) {
        if (component == PROVINCE_COMPONENT) {
            return [province objectAtIndex: row];
        }else if (component == CITY_COMPONENT) {
            return [city objectAtIndex: row];
        }else if (component == DISTRICT_COMPONENT){
            return [district objectAtIndex: row];
        }else if (component == SERVICECENTER_COMPONENT){
            return [sevicecenter objectAtIndex:row];
        }else {
            return 0;
        }
    }else if(pickerView == _secondpicker){
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
    if (pickerView == _picker) {
        if (component == PROVINCE_COMPONENT) {
            if (province.count!=0) {
                ProvinceModel* model = province[row];
                [self CityRequest:model.Id];
            }
            [pickerView selectRow: row inComponent: PROVINCE_COMPONENT animated: YES];
            [pickerView reloadComponent: PROVINCE_COMPONENT];
            [pickerView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
            [pickerView reloadComponent: CITY_COMPONENT];
            [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [pickerView reloadComponent: DISTRICT_COMPONENT];
            [pickerView selectRow:0 inComponent:SERVICECENTER_COMPONENT animated:YES];
            [pickerView reloadComponent:SERVICECENTER_COMPONENT];
            [_secondpicker selectRow: row inComponent: HOUSE_COMPONENT animated: YES];
            [_secondpicker reloadComponent: HOUSE_COMPONENT];
            [_secondpicker selectRow: 0 inComponent: COMUNITY_COMPONENT animated: YES];
            [_secondpicker reloadComponent: COMUNITY_COMPONENT];
            [_secondpicker selectRow:0 inComponent:ROOMNUMBER_COMPONENT animated:YES];
            [_secondpicker reloadComponent:ROOMNUMBER_COMPONENT];
            
        }else if (component == CITY_COMPONENT) {
            if (city.count!=0) {
                CityModel* model = city[row];
                NSLog(@"CITYid为:::%ld",(long)model.Id);
                [self AreaRequest:model.Id];
            }
            [pickerView selectRow: row inComponent: CITY_COMPONENT animated: YES];
            [pickerView reloadComponent: CITY_COMPONENT];
            [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [pickerView reloadComponent: DISTRICT_COMPONENT];
            [pickerView selectRow:0 inComponent:SERVICECENTER_COMPONENT animated:YES];
            [pickerView reloadComponent:SERVICECENTER_COMPONENT];
            [_secondpicker selectRow: row inComponent: HOUSE_COMPONENT animated: YES];
            [_secondpicker reloadComponent: HOUSE_COMPONENT];
            [_secondpicker selectRow: 0 inComponent: COMUNITY_COMPONENT animated: YES];
            [_secondpicker reloadComponent: COMUNITY_COMPONENT];
            [_secondpicker selectRow:0 inComponent:ROOMNUMBER_COMPONENT animated:YES];
            [_secondpicker reloadComponent:ROOMNUMBER_COMPONENT];
        }else if (component == DISTRICT_COMPONENT){
            if (district.count!=0) {
                AreaModel* model = district[row];
                NSLog(@"DISTRICTid为:::%ld",(long)model.Id);
                [self ServiceCenterRequest:model.Id];
            }
            [pickerView selectRow: row inComponent: DISTRICT_COMPONENT animated: YES];
            [pickerView reloadComponent: DISTRICT_COMPONENT];
            [pickerView selectRow:0 inComponent:SERVICECENTER_COMPONENT animated:YES];
            [pickerView reloadComponent:SERVICECENTER_COMPONENT];
            [_secondpicker selectRow: row inComponent: HOUSE_COMPONENT animated: YES];
            [_secondpicker reloadComponent: HOUSE_COMPONENT];
            [_secondpicker selectRow: 0 inComponent: COMUNITY_COMPONENT animated: YES];
            [_secondpicker reloadComponent: COMUNITY_COMPONENT];
            [_secondpicker selectRow:0 inComponent:ROOMNUMBER_COMPONENT animated:YES];
            [_secondpicker reloadComponent:ROOMNUMBER_COMPONENT];
        }else if (component == SERVICECENTER_COMPONENT){
            if(sevicecenter.count!=0){
                ServiceCenterModel* model = sevicecenter[row];
                NSLog(@"SERVICECENTERid为:::%ld",(long)model.Id);
                [self VillageRequest:model.Id];
            }
            [pickerView selectRow:row inComponent:SERVICECENTER_COMPONENT animated:YES];
            [pickerView reloadComponent:SERVICECENTER_COMPONENT];
            [_secondpicker selectRow: row inComponent: HOUSE_COMPONENT animated: YES];
            [_secondpicker reloadComponent: HOUSE_COMPONENT];
            [_secondpicker selectRow: 0 inComponent: COMUNITY_COMPONENT animated: YES];
            [_secondpicker reloadComponent: COMUNITY_COMPONENT];
            [_secondpicker selectRow:0 inComponent:ROOMNUMBER_COMPONENT animated:YES];
            [_secondpicker reloadComponent:ROOMNUMBER_COMPONENT];
        }

    }else if(pickerView == _secondpicker){
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
            [pickerView selectRow: 0 inComponent: COMUNITY_COMPONENT animated: YES];
            [pickerView reloadComponent: COMUNITY_COMPONENT];
            [pickerView selectRow:0 inComponent:ROOMNUMBER_COMPONENT animated:YES];
            [pickerView reloadComponent:ROOMNUMBER_COMPONENT];
        }else if (component == ROOMNUMBER_COMPONENT){
            [pickerView selectRow:0 inComponent:ROOMNUMBER_COMPONENT animated:YES];
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
    if (pickerView == _picker) {
        if (component == PROVINCE_COMPONENT) {
            return (pickerView.frame.size.width - 20)/FIRSTNUM;
        }else if (component == CITY_COMPONENT) {
            return (pickerView.frame.size.width - 20)/FIRSTNUM;
        }else if (component == DISTRICT_COMPONENT){
            return (pickerView.frame.size.width - 20)/FIRSTNUM;
        }else if (component == SERVICECENTER_COMPONENT){
            return (pickerView.frame.size.width - 20)/FIRSTNUM;
        }else {
            return 0;
        }
    }else if (pickerView == _secondpicker){
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
    if (pickerView == _picker) {
        if (component == PROVINCE_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/FIRSTNUM, 30)];
            myView.adjustsFontSizeToFitWidth = YES;
            myView.numberOfLines = 0;
            myView.textAlignment = NSTextAlignmentCenter;
            if (province.count!=0) {
                ProvinceModel* model = [province objectAtIndex:row];
                myView.text = model.name;
            }
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }else if (component == CITY_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/FIRSTNUM, 30)];
            myView.adjustsFontSizeToFitWidth = YES;
            myView.numberOfLines = 0;
            myView.textAlignment = NSTextAlignmentCenter;
            if (city.count!=0) {
                CityModel* model = [city objectAtIndex:row];
                myView.text = model.name;
            }
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }else if (component == DISTRICT_COMPONENT){
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/FIRSTNUM, 30)];
            myView.adjustsFontSizeToFitWidth = YES;
            myView.numberOfLines = 0;
            myView.textAlignment = NSTextAlignmentCenter;
            if (district.count!=0) {
                AreaModel* model = [district objectAtIndex:row];
                myView.text = model.name;
            }
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
            
        }else if (component == SERVICECENTER_COMPONENT){
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/FIRSTNUM, 30)];
            myView.adjustsFontSizeToFitWidth = YES;
            myView.numberOfLines = 0;
            myView.textAlignment = NSTextAlignmentCenter;
            if (sevicecenter.count!=0) {
                ServiceCenterModel* model = [sevicecenter objectAtIndex:row];
                myView.text = model.name;
            }
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
            
        }
    }else if (pickerView == _secondpicker){
        if(component == HOUSE_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/FIRSTNUM, 30)];
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
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/FIRSTNUM, 30)];
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
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (pickerView.frame.size.width - 20)/FIRSTNUM, 30)];
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


//省数据请求
- (void)ProvinceRequest
{
    [province removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadprovince.do",ROOT_Path];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"ProvinceArray%@",array);
        [province removeAllObjects];
        for (int i =0; i <array.count; i++) {
            ProvinceModel* model = [[ProvinceModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [province addObject:model];
        }
        [_picker reloadComponent:PROVINCE_COMPONENT];
        NSInteger provinceIndex = [_picker selectedRowInComponent: PROVINCE_COMPONENT];
        NSLog(@"省点击了第%ld个",(long)provinceIndex);
        if (province.count!=0) {
            ProvinceModel* model = province[provinceIndex];
            [self CityRequest:model.Id];
        }else{
            [city removeAllObjects];
            [_picker reloadComponent:CITY_COMPONENT];
            [district removeAllObjects];
            [_picker reloadComponent:DISTRICT_COMPONENT];
            [sevicecenter removeAllObjects];
            [_picker reloadComponent:SERVICECENTER_COMPONENT];
            [village removeAllObjects];
            [_secondpicker reloadComponent:HOUSE_COMPONENT];
            [community removeAllObjects];
            [_secondpicker reloadComponent:COMUNITY_COMPONENT];
            [roomnumber removeAllObjects];
            [_secondpicker reloadComponent:ROOMNUMBER_COMPONENT];
        }
        //        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        //                [_hud hide:YES];
    }];
    
}
//市数据请求
- (void)CityRequest:(NSString*)provinceID
{
    [city removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadcity.do?provinceid=%@",ROOT_Path,provinceID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"CityArray%@",array);
        [city removeAllObjects];
        for (int i =0; i <array.count; i++) {
            CityModel* model = [[CityModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [city addObject:model];
        }
        [_picker reloadComponent:CITY_COMPONENT];
        NSInteger cityIndex = [_picker selectedRowInComponent: CITY_COMPONENT];
        NSLog(@"市点击了第%ld个",(long)cityIndex);
        if (city.count!=0) {
            CityModel* model = city[cityIndex];
            [self AreaRequest:model.Id];
        }else{
            [district removeAllObjects];
            [_picker reloadComponent:DISTRICT_COMPONENT];
            [sevicecenter removeAllObjects];
            [_picker reloadComponent:SERVICECENTER_COMPONENT];
            [village removeAllObjects];
            [_secondpicker reloadComponent:HOUSE_COMPONENT];
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
//县数据请求
- (void)AreaRequest:(NSString*)cityID
{
    [district removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadarea.do?cityid=%@",ROOT_Path,cityID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"AreaArray%@",array);
        [district removeAllObjects];
        for (int i =0; i <array.count; i++) {
            AreaModel* model = [[AreaModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [district addObject:model];
        }
        [_picker reloadComponent:DISTRICT_COMPONENT];
        NSInteger districtIndex = [_picker selectedRowInComponent: DISTRICT_COMPONENT];
        NSLog(@"县点击了第%ld个",(long)districtIndex);
        if (district.count!=0) {
            AreaModel* model = district[districtIndex];
            [self ServiceCenterRequest:model.Id];
        }else{
            [sevicecenter removeAllObjects];
            [_picker reloadComponent:SERVICECENTER_COMPONENT];
            [village removeAllObjects];
            [_secondpicker reloadComponent:HOUSE_COMPONENT];
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
//区域数据请求
- (void)ServiceCenterRequest:(NSString*)areaID
{
    /*
     /areamanage/loadservicecenter.do
     */
    [sevicecenter removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadservicecenter.do?areaid=%@",ROOT_Path,areaID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"ServiceCenter%@",array);
        [sevicecenter removeAllObjects];
        for (int i =0; i <array.count; i++) {
            ServiceCenterModel * model = [[ServiceCenterModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [sevicecenter addObject:model];
        }
        [_picker reloadComponent:SERVICECENTER_COMPONENT];
        
        NSInteger centerIndex = [_picker selectedRowInComponent:SERVICECENTER_COMPONENT];
        NSLog(@"业务中心点击了第%ld个",(long)centerIndex);
        if (sevicecenter.count!=0) {
            ServiceCenterModel* model = sevicecenter[centerIndex];
            [self VillageRequest:model.Id];
        }else{
            [village removeAllObjects];
            [_secondpicker reloadComponent:HOUSE_COMPONENT];
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


//业务中心数据请求
- (void)VillageRequest:(NSString*)centerID
{
    /*
     /areamanage/loadhousenumber.do
     servicecenterid
     */
    [village removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadhousenumber.do?servicecenterid=%@",ROOT_Path,centerID];
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
