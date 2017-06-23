//
//  ZMWebImageManage.m
//  ZMimageDownLoad
//
//  Created by pg on 2017/6/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "ZMWebImageManage.h"
#import "ZMDownLoadOperation.h"
#import <CommonCrypto/CommonCrypto.h>

@interface ZMWebImageManage ()

//全局下载任务的队列
@property(nonatomic,strong)NSOperationQueue *downLoadQueue;

//图片内存缓冲
@property(nonatomic,strong)NSMutableDictionary *ImageCache;

//下载操作缓冲
@property(nonatomic,strong)NSMutableDictionary *operationCache;

@end

@implementation ZMWebImageManage



#pragma mark
#pragma mark - 将下载管理类作成单例类
+(instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

#pragma mark
#pragma mark - 单例对象初始化函数
-(instancetype)init
{
    if (self = [super init]) {
        
        self.downLoadQueue  = [NSOperationQueue new];
        self.ImageCache = [NSMutableDictionary dictionary];
        self.operationCache = [NSMutableDictionary dictionary];
        
    }
    return self;
}

#pragma mark
#pragma mark - 下载方法
-(void)downLoadImageWithURLString:(NSString*)urlString completed:(void(^)(UIImage *image))completeBlock
{
    if([self.ImageCache objectForKey:urlString])
    {
        //如果缓存中有要下载的图片就不要下载了,直接返回就好
        UIImage *dowmLoadimage = [self.ImageCache objectForKey:urlString];
        completeBlock(dowmLoadimage);
        return;
    }else
    {
        //如果内存缓冲没有,就要判断沙盒缓存中是否存在
        //获取沙盒路径
        NSString *cachePath = [self getImagePath:urlString];
        UIImage *sanBoxImage = [UIImage imageWithContentsOfFile:cachePath];
        if (sanBoxImage) {
            //沙盒缓存中有需要的图片
            //将图片缓存值内存缓存
            [self.ImageCache setObject:sanBoxImage forKey:urlString];
            //返回图片
            completeBlock(sanBoxImage);
        }
    }
    
    
    //-----------以下是下载代码-------------
    ZMDownLoadOperation *operation = [ZMDownLoadOperation downLoadOperationWithURLString:urlString completed:^(UIImage *image) {
        
     //   double start = CACurrentMediaTime();
        //经过测试沙盒缓存耗时很短所以这里不需要将其划为耗时操作
        
        //向沙盒中缓存图片
        NSData *data = nil;
        if ([[urlString stringByDeletingPathExtension] isEqualToString:@".png"]) {
           data = UIImagePNGRepresentation(image);
        }else
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        NSString *writePath = [self getImagePath:urlString];
        [data writeToFile:writePath atomically:YES];
      
        if(image != nil)
        {
            //图片完成下载,对已经下载的图片做内存缓存
            [self.ImageCache setObject:image forKey:urlString];
        }
       
        //图片下载完成,将操作缓存清除
        [self.operationCache removeObjectForKey:urlString];
        
        //调用block将图片上传
        if (completeBlock) {
            completeBlock(image);
        }
        
    }];
    
    //记录开启的下载操作
    [self.operationCache setObject:operation forKey:urlString];
    
    //下载操作加入队列,执行操作
    [self.downLoadQueue addOperation:operation];
    
}

#pragma mark
#pragma mark - 取消正在执行的下载操作
-(void)cancleOperation:(NSString*)urlString
{
    //获取操作
    ZMDownLoadOperation *operation = [self.operationCache objectForKey:urlString];
    //判断操作是否还存在
    if(operation!=nil)
    {
        [operation cancel];
        //取消操作之后要将操作重缓存中移除
        [self.operationCache removeObjectForKey:urlString];
        
    }
}




#pragma mark
#pragma mark - 获取图片对应的沙盒缓存路径
-(NSString*)getImagePath:(NSString*)urlstring
{
    //获取沙盒路经
    NSString *filepath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    //根据沙盒路径获取的哈希编码
    const char *str = urlstring.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [strM appendFormat:@"%02x", buffer[i]];
    }

    NSString *tempstr = strM.copy;

    
    return [filepath stringByAppendingPathComponent:tempstr];
    
}

@end
