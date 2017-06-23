//
//  ZMDownLoadOperation.m
//  ZMimageDownLoad
//
//  Created by pg on 2017/6/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "ZMDownLoadOperation.h"

@interface ZMDownLoadOperation ()

//接收外界传入的地址
@property(nonatomic,copy)NSString *URLString;
//图片下载完成之后,调用block 传递下载到的图片
@property(nonatomic,copy)void(^completedBlock)(UIImage *image);



@end

@implementation ZMDownLoadOperation

+(instancetype)downLoadOperationWithURLString:(NSString *)URLString completed:(void (^)(UIImage *))completedBlock
{
    ZMDownLoadOperation *operation = [ZMDownLoadOperation new];
    //记录全局图片地址
    operation.URLString = URLString;
    //记录全局回调代码块
    operation.completedBlock = completedBlock;
    
    return operation;
}


//操作入口方法
-(void)main
{
    NSAssert(_URLString, @"图片地址不能为空");
    
    NSURL *url  = [NSURL URLWithString:self.URLString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    //图片下载结束,由于外界很可能在block内部做UI的刷新操作,因此在此处回到主线程
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        if (_completedBlock) {
            _completedBlock(image);
        }
    }];
   
}

@end
