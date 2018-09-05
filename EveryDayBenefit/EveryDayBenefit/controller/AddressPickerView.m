//
//  AddressPickerView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/6.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "AddressPickerView.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"
#import "ServiceCenterModel.h"
#import "VillageFenquModel.h"

@implementation AddressPickerView

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
        _selectProvinceStr = @"0";
        
        
        //数据请求
        [self ProvinceRequest];
//        [self CityRequest:@"0"];
//        [self AreaRequest:@"0"];
//        [self ServiceCenterRequest:@"0"];
//        [self VillageRequest:@"0"];
        
        picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height-70)];
        picker.dataSource = self;
        picker.delegate = self;
        picker.showsSelectionIndicator = YES;
        [picker selectRow: 0 inComponent: 0 animated: YES];
        [self addSubview: picker];
        _detailAddressTView = [[UITextView alloc]init];
         _detailAddressTView.frame = CGRectMake(0, picker.bottom, self.bounds.size.width, 30);
        _detailAddressTView.backgroundColor = [UIColor grayColor];
        _detailAddressTView.text = @"请输入详细地址";
        _detailAddressTView.textColor = GrayTitleColor;
        _detailAddressTView.delegate = self;
        _detailAddressTView.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_detailAddressTView];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, _detailAddressTView.bottom+2, self.bounds.size.width, 1)];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [closeBtn setFrame:CGRectMake(20+(self.bounds.size.width - 40)/2, line.bottom, (self.bounds.size.width - 40)/2, 30)];
        [self addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button = [UIButton buttonWithType: 100];
        [button setTitle: @"确定" forState: UIControlStateNormal];
//        [button setFrame: CGRectMake(160-button.bounds.size.width/2, 320, button.bounds.size.width, button.bounds.size.height)];
        [button setFrame:CGRectMake(20, _detailAddressTView.bottom, (self.bounds.size.width - 40)/2, 30)];
        [button setTintColor: [UIColor grayColor]];
        [button addTarget: self action: @selector(buttobClicked:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: button];

//        UIView* line1 = [UIView alloc]initWithFrame:CGRectMake(20+(self.bounds.size.width - 40)/2, line.bottom, <#CGFloat width#>, <#CGFloat height#>)
        
    }
    return self;
}

#pragma mark- button clicked

- (void) buttobClicked:(UIButton*)sender {
    NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
    NSInteger centerIndex = [picker selectedRowInComponent:SERVICECENTER_COMPONENT];
    NSInteger villageIndex = [picker selectedRowInComponent:VILLAGE_COMPONENT];
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
        VillageFenquModel* villaremodel = [[VillageFenquModel alloc]init];
        villaremodel = village[villageIndex];
        villageStr = villaremodel.name;
        village_id = villaremodel.Id;
    }
//    NSString *provinceStr = [province objectAtIndex: provinceIndex];
//    NSString *cityStr = [city objectAtIndex: cityIndex];
//    NSString *districtStr = [district objectAtIndex:districtIndex];
//    NSString *centerStr = [sevicecenter objectAtIndex:centerIndex];
//    NSString *villageStr = [village objectAtIndex:villageIndex];
    
//    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
//        cityStr = @"";
//        districtStr = @"";
//    }
//    else if ([cityStr isEqualToString: districtStr]) {
//        districtStr = @"";
//    }
    
//    NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@.%@ %@", provinceStr, cityStr, districtStr,centerStr,villageStr];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"alert"
//                                                    message: showMsg
//                                                   delegate: self
//                                          cancelButtonTitle:@"ok"
//                                          otherButtonTitles: nil, nil];
//    
//    [alert show];
    AddressPickerViewModel* model = [[AddressPickerViewModel alloc]init];
    model.province = provinceStr;
    model.city = cityStr;
    model.district = districtStr;
    model.sevicecenter = centerStr;
    model.village = villageStr;
    model.province_id = province_id;
    model.city_id = city_id;
    model.district_id = district_id;
    model.sevicecenter_id = center_id;
    model.village_id = village_id;
    if ([_detailAddressTView.text isEqualToString:@"请输入详细地址"]) {
        //    通过block反向传值
        if (_transVaule) {
            _transVaule(model,@"",YES);
        }
    }else{
        //    通过block反向传值
        if (_transVaule) {
            _transVaule(model,_detailAddressTView.text,YES);
        }
    }

    
}

- (void)closeBtnClick:(UIButton*)sender
{
    NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
    NSInteger centerIndex = [picker selectedRowInComponent:SERVICECENTER_COMPONENT];
    NSInteger villageIndex = [picker selectedRowInComponent:VILLAGE_COMPONENT];
    
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
        VillageFenquModel* villaremodel = [[VillageFenquModel alloc]init];
        villaremodel = village[villageIndex];
        villageStr = villaremodel.name;
        village_id = villaremodel.Id;
    }
    
    AddressPickerViewModel* model = [[AddressPickerViewModel alloc]init];
    model.province = provinceStr;
    model.city = cityStr;
    model.district = districtStr;
    model.sevicecenter = centerStr;
    model.village = villageStr;
    model.province_id = province_id;
    model.city_id = city_id;
    model.district_id = district_id;
    model.sevicecenter_id = center_id;
    model.village_id = village_id;
    if ([_detailAddressTView.text isEqualToString:@"请输入详细地址"]) {
        //    通过block反向传值
        if (_transVaule) {
            _transVaule(model,@"",NO);
        }
    }else{
        //    通过block反向传值
        if (_transVaule) {
            _transVaule(model,_detailAddressTView.text,NO);
        }
    }
    
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }else if (component == CITY_COMPONENT) {
        return [city count];
    }else if (component == DISTRICT_COMPONENT){
        return [district count];
    }else if (component == SERVICECENTER_COMPONENT){
        return [sevicecenter count];
    }else if (component == VILLAGE_COMPONENT){
        return [village count];
    }else {
        return 0;
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }else if (component == DISTRICT_COMPONENT){
        return [district objectAtIndex: row];
    }else if (component == SERVICECENTER_COMPONENT){
        return [sevicecenter objectAtIndex:row];
    }else if (component == VILLAGE_COMPONENT){
        return [village objectAtIndex:row];
    }else {
        return 0;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == PROVINCE_COMPONENT) {
        if (province.count!=0) {
            ProvinceModel* model = province[row];
//            [city removeAllObjects];
            [self CityRequest:model.Id];
        }
//        if (district.count!=0) {
//            CityModel* model = city[0];
//            NSLog(@"城市id为:::%ld",(long)model.Id);
//            [district removeAllObjects];
//            [self AreaRequest:model.Id];
//        }
        [picker selectRow: row inComponent: PROVINCE_COMPONENT animated: YES];
        [picker reloadComponent: PROVINCE_COMPONENT];
        [picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
        [picker selectRow:0 inComponent:SERVICECENTER_COMPONENT animated:YES];
        [picker reloadComponent:SERVICECENTER_COMPONENT];
        [picker selectRow:0 inComponent:VILLAGE_COMPONENT animated:YES];
        [picker reloadComponent:VILLAGE_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        if (city.count!=0) {
            CityModel* model = city[row];
            NSLog(@"CITYid为:::%ld",(long)model.Id);
//            [district removeAllObjects];
            [self AreaRequest:model.Id];
        }
        [picker selectRow: row inComponent: CITY_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
        [picker selectRow:0 inComponent:SERVICECENTER_COMPONENT animated:YES];
        [picker reloadComponent:SERVICECENTER_COMPONENT];
        [picker selectRow:0 inComponent:VILLAGE_COMPONENT animated:YES];
        [picker reloadComponent:VILLAGE_COMPONENT];
    }else if (component == DISTRICT_COMPONENT){
        if (district.count!=0) {
            AreaModel* model = district[row];
            NSLog(@"DISTRICTid为:::%ld",(long)model.Id);
//            [sevicecenter removeAllObjects];
            [self ServiceCenterRequest:model.Id];
        }
        [picker selectRow: row inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
        [picker selectRow:0 inComponent:SERVICECENTER_COMPONENT animated:YES];
        [picker reloadComponent:SERVICECENTER_COMPONENT];
        [picker selectRow:0 inComponent:VILLAGE_COMPONENT animated:YES];
        [picker reloadComponent:VILLAGE_COMPONENT];
    }else if (component == SERVICECENTER_COMPONENT){
        if(sevicecenter.count!=0){
            ServiceCenterModel* model = sevicecenter[row];
            NSLog(@"SERVICECENTERid为:::%ld",(long)model.Id);
//            [village removeAllObjects];
            [self VillageRequest:model.Id];
        }
        [picker selectRow:row inComponent:SERVICECENTER_COMPONENT animated:YES];
        [picker reloadComponent:SERVICECENTER_COMPONENT];
        [picker selectRow:0 inComponent:VILLAGE_COMPONENT animated:YES];
        [picker reloadComponent:VILLAGE_COMPONENT];
    }else if (component == VILLAGE_COMPONENT){

        [picker selectRow:row inComponent:VILLAGE_COMPONENT animated:YES];
        [picker reloadComponent:VILLAGE_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    if (component == PROVINCE_COMPONENT) {
        return (picker.frame.size.width - 20)/5;
    }else if (component == CITY_COMPONENT) {
        return (picker.frame.size.width - 20)/5;
    }else if (component == DISTRICT_COMPONENT){
        return (picker.frame.size.width - 20)/5;
    }else if (component == SERVICECENTER_COMPONENT){
        return (picker.frame.size.width - 20)/5;
    }else if (component == VILLAGE_COMPONENT){
        return (picker.frame.size.width - 20)/5;
    }else {
        return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (picker.frame.size.width - 20)/5, 30)];
        myView.adjustsFontSizeToFitWidth = YES;
        myView.numberOfLines = 0;
        myView.textAlignment = NSTextAlignmentCenter;
        if (province.count!=0) {
            ProvinceModel* model = [province objectAtIndex:row];
            myView.text = model.name;
        }
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (picker.frame.size.width - 20)/5, 30)];
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
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (picker.frame.size.width - 20)/5, 30)];
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
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (picker.frame.size.width - 20)/5, 30)];
        myView.adjustsFontSizeToFitWidth = YES;
        myView.numberOfLines = 0;
        myView.textAlignment = NSTextAlignmentCenter;
        if (sevicecenter.count!=0) {
            ServiceCenterModel* model = [sevicecenter objectAtIndex:row];
            myView.text = model.name;
        }
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];

    }else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (picker.frame.size.width - 20)/5, 30)];
        myView.adjustsFontSizeToFitWidth = YES;
        myView.numberOfLines = 0;
        myView.textAlignment = NSTextAlignmentCenter;
        if (village.count!=0) {
            VillageFenquModel* model = [village objectAtIndex:row];
            myView.text = model.name;
        }
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
 
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
    /*
     +/areamanage/loadprovince.do
     */
//    NSArray *data = [[NSArray alloc]init];
//    NSData *fileData = [[NSData alloc]init];
//    NSString *path;
//    path = [[NSBundle mainBundle] pathForResource:@"ProvinceModel" ofType:@"json"];
//    fileData = [NSData dataWithContentsOfFile:path];
//    data = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
//    [province removeAllObjects];
//    for (int i =0; i <data.count; i++) {
//        ProvinceModel* model = [[ProvinceModel alloc]init];
//        [model setValuesForKeysWithDictionary:data[i]];
//        [province addObject:model];
//    }
//    [picker reloadComponent:PROVINCE_COMPONENT];
    
    
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
        [picker reloadComponent:PROVINCE_COMPONENT];
        NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
        NSLog(@"省点击了第%ld个",(long)provinceIndex);
        if (province.count!=0) {
            ProvinceModel* model = province[provinceIndex];
            [self CityRequest:model.Id];
        }else{
            [city removeAllObjects];
            [picker reloadComponent:CITY_COMPONENT];
            [district removeAllObjects];
            [picker reloadComponent:DISTRICT_COMPONENT];
            [sevicecenter removeAllObjects];
            [picker reloadComponent:SERVICECENTER_COMPONENT];
            [village removeAllObjects];
            [picker reloadComponent:VILLAGE_COMPONENT];
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
//    NSArray *data = [[NSArray alloc]init];
//    NSData *fileData = [[NSData alloc]init];
//    NSString *path;
//    path = [[NSBundle mainBundle] pathForResource:@"CityModel" ofType:@"json"];
//    fileData = [NSData dataWithContentsOfFile:path];
//    data = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
//    [city removeAllObjects];
//    for (int i =0; i <data.count; i++) {
//        CityModel* model = [[CityModel alloc]init];
//        [model setValuesForKeysWithDictionary:data[i]];
//        [city addObject:model];
//    }
//    [picker reloadComponent:CITY_COMPONENT];
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
            [picker reloadComponent:CITY_COMPONENT];
            NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
            NSLog(@"市点击了第%ld个",(long)cityIndex);
        if (city.count!=0) {
            CityModel* model = city[cityIndex];
            [self AreaRequest:model.Id];
        }else{
            [district removeAllObjects];
            [picker reloadComponent:DISTRICT_COMPONENT];
            [sevicecenter removeAllObjects];
            [picker reloadComponent:SERVICECENTER_COMPONENT];
            [village removeAllObjects];
            [picker reloadComponent:VILLAGE_COMPONENT];
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
//        NSArray *data = [[NSArray alloc]init];
//        NSData *fileData = [[NSData alloc]init];
//        NSString *path;
//        path = [[NSBundle mainBundle] pathForResource:@"AreaModel" ofType:@"json"];
//        fileData = [NSData dataWithContentsOfFile:path];
//        data = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
//        [district removeAllObjects];
//        for (int i =0; i <data.count; i++) {
//            AreaModel* model = [[AreaModel alloc]init];
//            [model setValuesForKeysWithDictionary:data[i]];
//            [district addObject:model];
//        }
//        [picker reloadComponent:DISTRICT_COMPONENT];
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
        [picker reloadComponent:DISTRICT_COMPONENT];
        NSInteger districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
        NSLog(@"县点击了第%ld个",(long)districtIndex);
        if (district.count!=0) {
            AreaModel* model = district[districtIndex];
            [self ServiceCenterRequest:model.Id];
        }else{
            [sevicecenter removeAllObjects];
            [picker reloadComponent:SERVICECENTER_COMPONENT];
            [village removeAllObjects];
            [picker reloadComponent:VILLAGE_COMPONENT];
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
//    NSArray *data = [[NSArray alloc]init];
//    NSData *fileData = [[NSData alloc]init];
//    NSString *path;
//    path = [[NSBundle mainBundle] pathForResource:@"ServiceCenterModel" ofType:@"json"];
//    fileData = [NSData dataWithContentsOfFile:path];
//    data = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
//    [sevicecenter removeAllObjects];
//    for (int i =0; i <data.count; i++) {
//       ServiceCenterModel * model = [[ServiceCenterModel alloc]init];
//        [model setValuesForKeysWithDictionary:data[i]];
//        [sevicecenter addObject:model];
//    }
//    [picker reloadComponent:SERVICECENTER_COMPONENT];
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
        [picker reloadComponent:SERVICECENTER_COMPONENT];
        
        NSInteger centerIndex = [picker selectedRowInComponent:SERVICECENTER_COMPONENT];
        NSLog(@"业务中心点击了第%ld个",(long)centerIndex);
        if (sevicecenter.count!=0) {
            ServiceCenterModel* model = sevicecenter[centerIndex];
            [self VillageRequest:model.Id];
        }else{
            [village removeAllObjects];
            [picker reloadComponent:VILLAGE_COMPONENT];
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
//    NSArray *data = [[NSArray alloc]init];
//    NSData *fileData = [[NSData alloc]init];
//    NSString *path;
//    path = [[NSBundle mainBundle] pathForResource:@"VillageModel" ofType:@"json"];
//    fileData = [NSData dataWithContentsOfFile:path];
//    data = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
//    [village removeAllObjects];
//    for (int i =0; i <data.count; i++) {
//        VillageModel* model = [[VillageModel alloc]init];
//        [model setValuesForKeysWithDictionary:data[i]];
//        [village addObject:model];
//    }
//    [picker reloadComponent:VILLAGE_COMPONENT];
    /*
     /areamanage/loadvillage.do?servicecenterid
     */
    /*
     /areamanage/loadvillage.do
     servicecenterid
     */
    [village removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadvillage.do?servicecenterid=%@",ROOT_Path,centerID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"VillageArray%@",array);
        for (int i =0; i <array.count; i++) {
            VillageFenquModel* model = [[VillageFenquModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [village addObject:model];
        }
        [picker reloadComponent:VILLAGE_COMPONENT];
        //        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        //        [_hud hide:YES];
    }];
    
}






@end
