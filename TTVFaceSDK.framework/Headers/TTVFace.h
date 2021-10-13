//
//  TTVFace.h
//  TTVFaceSDK
//
//  Created by user on 9/24/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FaceResult : NSObject

@property (nonatomic) int left;
@property (nonatomic) int top;
@property (nonatomic) int right;
@property (nonatomic) int bottom;
@property (nonatomic) int liveness;
@end

NS_ASSUME_NONNULL_BEGIN

@interface TTVFace : NSObject

+ (instancetype)sharedInstance;
- (int) initSDK;
- (NSMutableArray*) detectAndLiveness:(UIImage*) image;
- (int) processLivenes:(UIImage*) image faceResuls:(NSMutableArray*) faceResuls;
- (void) setLivenessThreshold:(float)threshold;

@end

NS_ASSUME_NONNULL_END
