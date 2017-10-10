//
//  HHMainController.m
//  mj_downLoad
//
//  Created by maoziyue on 2017/9/28.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "HHMainController.h"
#import "AFNetworking.h"

@interface HHMainController ()

@end

@implementation HHMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载";
    
    
    [self loadData];//下载单个文件
    
}

- (void)loadData
{
    NSString *urlStr = @"http://img1.sc115.com/uploads/sc/jpg/HD/1/204.jpg";

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"---------进度--%f-------------", downloadProgress.fractionCompleted);//下载进度
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //返回下载到哪里(返回值是一个路径)
        //拼接存放路径
        NSURL *pathURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        return [pathURL URLByAppendingPathComponent:[response suggestedFilename]];
        
   
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成走这个block
        if (!error)
        {
            //如果请求没有错误(请求成功), 则打印地址
            NSLog(@"%@", filePath);
        }
    }];
    
    //开始请求
    [task resume];
}







@end










