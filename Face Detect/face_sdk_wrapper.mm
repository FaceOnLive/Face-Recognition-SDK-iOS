//
//  face_sdk_wrapper.m
//  Face Detect
//
//  Created by Admin on 2/8/21.
//  Copyright © 2021 Sunyard. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc.hpp>

#import "face_sdk_wrapper.h"
#import "TTVFaceSDK/TTVFaceSDK.h"

bool g_face_sdk_initialized = false;

using namespace std;
//////////////////// MAIN PART END ////////////////////

int init_face_sdk() {
    if([[TTVFace sharedInstance] initSDK] != 0)
        return -1;

    return 0;
}


/// Converts an UIImage to Mat.
/// Orientation of UIImage will be lost.
static void UIImageToMat(UIImage *image, cv::Mat &mat) {
    assert(image.size.width > 0 && image.size.height);
    assert(image.CGImage != nil || image.CIImage != nil);
    
    // Create a pixel buffer.
    NSInteger width = image.size.width;
    NSInteger height = image.size.height;
    cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);
    
    // Draw all pixels to the buffer.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (image.CGImage) {
        // Render with using Core Graphics.
        CGContextRef contextRef = CGBitmapContextCreate(mat8uc4.data, mat8uc4.cols, mat8uc4.rows, 8, mat8uc4.step, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
        CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
        CGContextRelease(contextRef);
    } else {
        // Render with using Core Image.
        static CIContext* context = nil; // I do not like this declaration contains 'static'. But it is for performance.
        if (!context) {
            context = [CIContext contextWithOptions:@{ kCIContextUseSoftwareRenderer: @NO }];
        }
        CGRect bounds = CGRectMake(0, 0, width, height);
        [context render:image.CIImage toBitmap:mat8uc4.data rowBytes:mat8uc4.step bounds:bounds format:kCIFormatRGBA8 colorSpace:colorSpace];
    }
    CGColorSpaceRelease(colorSpace);
    
    // Adjust byte order of pixel.
    cv::Mat mat8uc3 = cv::Mat((int)width, (int)height, CV_8UC3);
    cv::cvtColor(mat8uc4, mat8uc3, CV_RGBA2BGR);
    
    mat = mat8uc3;
}

///  Objective-C Implementation
@implementation face_sdk_wrapper

-(void)init_wrapper {
    if (g_face_sdk_initialized) {
        return;
    }
    
    int inited = init_face_sdk();
    NSLog(@"========>SDK init result: %d", inited);
    g_face_sdk_initialized = true;
}

-(std::vector<FaceBox>) run_detect_wrapper: (nonnull UIImage *)src_image {
    cv::Mat bgr_mat;
    UIImage* input_image = src_image;
    UIImageToMat(input_image, bgr_mat);
   
    NSMutableArray *output_box_arr = [[TTVFace sharedInstance] detectAndLiveness:input_image];
    std::vector<FaceBox> output_boxes;

    for(int i = 0; i < output_box_arr.count; i ++) {
        FaceResult* faceResult = [output_box_arr objectAtIndex:i];
        
        FaceBox faceBox;
        faceBox.x1 = faceResult.left;
        faceBox.y1 = faceResult.top;
        faceBox.x2 = faceResult.right;
        faceBox.y2 = faceResult.bottom;
        faceBox.confidence = faceResult.liveness;
        output_boxes.push_back(faceBox);
    }
    
    return output_boxes;
}


@end
