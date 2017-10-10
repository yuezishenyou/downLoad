//
//  HHViewController2.m
//  mj_downLoad
//
//  Created by maoziyue on 2017/10/10.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "HHViewController2.h"
#import "AFNetworking.h"


@interface HHViewController2 ()
{
    // 下载任务句柄
    NSURLSessionDownloadTask *_downloadTask;
    int downIndex;
}

@property (nonatomic,strong) UIProgressView *progressV;

@property (nonatomic,assign) CGFloat  value;

@property (nonatomic,retain) NSArray  *urlArray;

@property (nonatomic, copy ) NSString *path;

@end

@implementation HHViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载多个任务";
    
    
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
    self.urlArray = @[
                      @"https://wkbos.bdimg.com/v1/wenku57//7b98301a2adf38c28ee0aef8921fda17?responseContentDisposition=attachment%3B%20filename%3D%22IOS%BF%AA%B7%A2%BB%B7%BE%B3%B4%EE%BD%A8%BA%CD%BC%F2%B5%A5%CA%B5%C0%FD.pdf%22&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2017-04-10T06%3A38%3A37Z%2F3600%2Fhost%2Feb0754e1d269be0ad50c2ebe78cf8f78ad065150edecfd731234e5374e7e5f84&token=da145c19277039627bf70015d9f111815fe86364ba0c387344f3b5d528a7f56b&expire=2017-04-10T07:38:37Z",
                      @"https://wkbos.bdimg.com/v1/wenku39//1d6911332cc6d657237bb02776868e05?responseContentDisposition=attachment%3B%20filename%3D%22iOS%BF%AA%B7%A2%D1%A7%CF%B0-%C8%E7%BA%CE%BC%F2%B5%A5%B5%C4%B4%EE%BD%A8%BB%B7%BE%B3.pptx%22&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2017-04-10T06%3A39%3A06Z%2F3600%2Fhost%2F24de87064b7f99a34e6e3e2ee7059d0b4225a2fb8f89ada0f300fb1b9b266567&token=4dcba41dff479e826c1ac3beeb9d282f62612d0f71ca1535dd404af062c6da79&expire=2017-04-10T07:39:06Z",
                      @"http://120.25.226.186:32812/resources/videos/minion_02.mp4",
                      @"http://120.25.226.186:32812/resources/images/minion_08.png"];
    
    downIndex = 0;
    
    

}

- (void)loadData
{
    NSString *urlSr = self.urlArray[0];
    
    //准备从远程下载文件
    [self downFileFromServer:urlSr];
    
    [_downloadTask resume];
    
    //[_downloadTask suspend];   //暂停下载
}



- (void)downFileFromServer:(NSString *)urlStr
{
    __weak typeof(self) weakSelf = self;
    
    downIndex ++;
    
    if (urlStr <= 0)
    {
        if (downIndex < weakSelf.urlArray.count)
        {
            [weakSelf downFileFromServer:weakSelf.urlArray[downIndex]];
        }
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    
    
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
      
        
        // 回到主队列刷新UI
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CGFloat locValue = (1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount ) / strongSelf.urlArray.count * downIndex;
            
            NSLog(@"-----value:%f-------",locValue);
            
            strongSelf.progressV.progress = locValue;
            
        });
        
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"文件路径：%@",path);
        self.path = path;
        return [NSURL fileURLWithPath:path];
        

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //设置下载完成操作
        // filePath就是下载文件的位置,
        [filePath path];
        // 将NSURL转成NSString
        //下载完成后 进行下一个任务
        if (downIndex < weakSelf.urlArray.count)
        {
            weakSelf.progressV.progress = 0.0;
            [weakSelf downFileFromServer:weakSelf.urlArray[downIndex]];
            //开始下载
            [_downloadTask resume];
        }
    }];
    
    
}






@end
