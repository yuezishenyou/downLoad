//
//  DejDownManager.m
//  mj_downLoad
//
//  Created by maoziyue on 2017/10/10.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "DejDownManager.h"
#import "AFNetworking.h"

@interface DejDownManager ()
{
    // 下载任务句柄
    NSURLSessionDownloadTask *_downloadTask;
    NSInteger downIndex;
    NSInteger arrCount;
    CGFloat progress;
}

@property (nonatomic,strong) NSArray *urlArray;

@property (nonatomic,copy) completion blcok;

@end

@implementation DejDownManager


- (instancetype)initWithArray:(NSArray *)urlArray completion:(completion)completion
{
    if (self = [super init])
    {
        _urlArray = urlArray;
        downIndex = 0;
        arrCount = urlArray.count;
        _blcok = completion;
        [self setup];
    }
    return self;
}




- (void)setup
{
     NSString *urlSr = self.urlArray[0];
    
    [self downFileFromServer:urlSr];
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
        //__weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //__strong typeof(weakSelf) strongSelf = weakSelf;
            
            CGFloat locValue = (1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount ) / arrCount ;
            
             locValue  = (downIndex - 1) * (1.0 / (CGFloat) arrCount) + locValue;
            
            progress = locValue;

            
            
            
            NSLog(@"-----value:%f-------",progress);
        
            
            NSNumber *num = [[NSNumber alloc]initWithFloat:progress];
            
            if (_blcok) {
                _blcok(num);
            }
            //strongSelf.progressV.progress = locValue;
            
        });
        
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];

        NSString *path = [pathDocuments stringByAppendingPathComponent:response.suggestedFilename];
        
        //NSLog(@"文件路径：%@",path);
        
        return [NSURL fileURLWithPath:path];
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //设置下载完成操作
        // filePath就是下载文件的位置,
        [filePath path];
        // 将NSURL转成NSString
        //下载完成后 进行下一个任务
        if (downIndex < weakSelf.urlArray.count)
        {
            //weakSelf.progressV.progress = 0.0;
            [weakSelf downFileFromServer:weakSelf.urlArray[downIndex]];
            //开始下载
            [_downloadTask resume];
        }
    }];
}



- (void)startDown
{
    [_downloadTask resume];
}

- (void)stopDown
{
    [_downloadTask suspend];
}



- (void)dealloc
{
    NSLog(@"-----释放----");
}






@end







