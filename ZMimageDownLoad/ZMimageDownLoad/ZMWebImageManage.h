//
//  ZMWebImageManage.h
//  ZMimageDownLoad
//
//  Created by pg on 2017/6/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZMWebImageManage : NSObject

+(instancetype)sharedManager;

//单例对象调用的下载图片的接口
-(void)downLoadImageWithURLString:(NSString*)urlString completed:(void(^)(UIImage *image))completeBlock;


@end
