//
//  ZMDownLoadOperation.h
//  ZMimageDownLoad
//
//  Created by pg on 2017/6/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMDownLoadOperation : NSOperation


+(instancetype)downLoadOperationWithURLString:(NSString*)URLString completed:(void(^)(UIImage *image))completedBlock;

@end
