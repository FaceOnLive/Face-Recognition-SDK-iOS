//
	//  ViewController.m
//  Face Detect
//
//  Created by IanWong on 2019/11/12.
//  Copyright © 2019 Sunyard. All rights reserved.
//


#import "ViewController.h"
#import "face_sdk_wrapper.h"
#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<bankCardVideoControllerDelegate>
@property (strong, nonatomic) face_sdk_wrapper *sdk_wrapper;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
/*    [self.sdk_wrapper init_wrapper];
    
    UIImage *image = [UIImage imageNamed:@"1.png"];
    [self.sdk_wrapper run_detect_wrapper:image];
 */
}


- (IBAction)run:(id)sender {
    
    NSLog(@"video ======");
    VideoViewController *conttroller = [[VideoViewController alloc]init];
    conttroller.delegate = self;
    [self presentViewController:conttroller animated:YES completion:nil];
}

- (void)videoDidGetOneFrameToImage:(UIImage *)image{
    self.imageView.image = image;
}

@end
