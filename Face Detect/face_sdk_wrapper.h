//
//  face_sdk_wrapper.h
//  Face Detect
//
//  Created by Admin on 2/8/21.
//  Copyright © 2021 Sunyard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <vector>
#import "base.h"

NS_ASSUME_NONNULL_BEGIN

@interface face_sdk_wrapper : NSObject

-(void)init_wrapper;
-(std::vector<FaceBox>) run_detect_wrapper: (nonnull UIImage *)src_image;

@end

NS_ASSUME_NONNULL_END
