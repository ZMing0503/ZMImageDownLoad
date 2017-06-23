//
//  ViewController.m
//  ZMimageDownLoad
//
//  Created by pg on 2017/6/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "ViewController.h"
#import "ZMDownLoadOperation.h"

#import "ZMWebImageManage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *urlstring = @"http://imgsrc.baidu.com/imgad/pic/item/b03533fa828ba61e5e6d4c0d4b34970a304e5915.jpg";
    [[ZMWebImageManage sharedManager]downLoadImageWithURLString:urlstring completed:^(UIImage *image) {
       
        NSLog(@"image%@",image);
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
