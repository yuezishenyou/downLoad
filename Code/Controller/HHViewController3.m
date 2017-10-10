//
//  HHViewController3.m
//  mj_downLoad
//
//  Created by maoziyue on 2017/10/10.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "HHViewController3.h"
#import "DejDownManager.h"

@interface HHViewController3 ()

@property (nonatomic,copy) NSArray *array;

@property (nonatomic,strong) UIProgressView *progressV;

@end

@implementation HHViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载";
    
    [self initSubViews];
    
    [self initData];
    
    [self loadData];
    
    
    
}

- (void)initSubViews
{
    self.progressV = [[UIProgressView alloc]init];
    
    self.progressV.frame = CGRectMake(100,100,200,30);
    
    self.progressV.progressViewStyle = UIProgressViewStyleDefault;
    
    //self.progressV.trackTintColor = [UIColor blueColor];  //设置默认颜色
    
    self.progressV.progressTintColor = [UIColor greenColor];
    
    self.progressV.progress = 0.01;
    
    [self.view addSubview:self.progressV];
    
}


- (void)initData
{
    self.array = @[
                   @"https://wkbos.bdimg.com/v1/wenku57//7b98301a2adf38c28ee0aef8921fda17?responseContentDisposition=attachment%3B%20filename%3D%22IOS%BF%AA%B7%A2%BB%B7%BE%B3%B4%EE%BD%A8%BA%CD%BC%F2%B5%A5%CA%B5%C0%FD.pdf%22&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2017-04-10T06%3A38%3A37Z%2F3600%2Fhost%2Feb0754e1d269be0ad50c2ebe78cf8f78ad065150edecfd731234e5374e7e5f84&token=da145c19277039627bf70015d9f111815fe86364ba0c387344f3b5d528a7f56b&expire=2017-04-10T07:38:37Z",
                    @"https://wkbos.bdimg.com/v1/wenku39//1d6911332cc6d657237bb02776868e05?responseContentDisposition=attachment%3B%20filename%3D%22iOS%BF%AA%B7%A2%D1%A7%CF%B0-%C8%E7%BA%CE%BC%F2%B5%A5%B5%C4%B4%EE%BD%A8%BB%B7%BE%B3.pptx%22&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2017-04-10T06%3A39%3A06Z%2F3600%2Fhost%2F24de87064b7f99a34e6e3e2ee7059d0b4225a2fb8f89ada0f300fb1b9b266567&token=4dcba41dff479e826c1ac3beeb9d282f62612d0f71ca1535dd404af062c6da79&expire=2017-04-10T07:39:06Z",
                    @"http://120.25.226.186:32812/resources/videos/minion_02.mp4",
                    @"http://120.25.226.186:32812/resources/images/minion_08.png"
                   ];
    
    
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    DejDownManager *manager = [[DejDownManager alloc]initWithArray:self.array completion:^(NSNumber *value) {
        //NSLog(@"----abc:%@----",value);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.progressV.progress = [value floatValue];
        
    }];;
    
    [manager startDown];
}











@end
