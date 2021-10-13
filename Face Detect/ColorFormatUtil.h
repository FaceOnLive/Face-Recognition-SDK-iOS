//
//  ColorFormatUtil.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TTVSoftFaceEngine/amcomdef.h>
#ifndef __common_utilitys
#define __common_utilitys

#ifdef __cplusplus
extern "C" {
#endif
    
typedef unsigned char BYTE;
    
#define SafeArrayFree(p) {if ((p)) free(p); (p) = NULL;}
#define LINE_BYTES(Width, BitCt)    (((int)(Width) * (BitCt) + 31) / 32 * 4)
    
void RGBA8888ToBGR(unsigned char* pRGBA, int width, int height, int pitch, unsigned char* pBGR);
void RGBA8888ToRGB(unsigned char* pRGBA, int width, int height, int pitch, unsigned char* pBGR);
void BGRToNV12(unsigned char *pBGR, int nW, int nH, unsigned char *pYUVY, int lYStride, unsigned char *pYUVUV, int lUVStride);
void BGR2NV21(unsigned char *pBGR, int nW, int nH, unsigned char *pYUVY, int lYStride, unsigned char *pYUVUV, int lUVStride);
    
#define    yuv_shift        14
#define    yuv_fix(x)        (int)((x) * (1 << (yuv_shift)) + 0.5f)
#define    yuv_descale(x)    (((x) + (1 << ((yuv_shift)-1))) >> (yuv_shift))
#define    yuv_prescale(x)    ((x) << yuv_shift)
    
#define    yuvYr    yuv_fix(0.299f)
#define    yuvYg    yuv_fix(0.587f)
#define    yuvYb    yuv_fix(0.114f)
#define    yuvCr    yuv_fix(0.713f)
#define    yuvCb    yuv_fix(0.564f)
    
#define    yuvRCr    yuv_fix(1.403f)
#define    yuvGCr    (-yuv_fix(0.714f))
#define    yuvGCb    (-yuv_fix(0.344f))
#define    yuvBCb    yuv_fix(1.773f)
    
#define ET_CAST_8U(t)         (BYTE)(!((t) & ~255) ? (t) : (t) > 0 ? 255 : 0)
#define ET_YUV_TO_R(y,v)      (BYTE)(ET_CAST_8U(yuv_descale((y) + yuvRCr * (v))))
#define ET_YUV_TO_G(y,u,v)    (BYTE)(ET_CAST_8U(yuv_descale((y) + yuvGCr * (v) + \
yuvGCb * (u))))
#define ET_YUV_TO_B(y,u)      (BYTE)(ET_CAST_8U(yuv_descale((y) + yuvBCb * (u))))
    
#define ET_RGB_TO_Y(r,g,b)    (int)(yuv_descale((b) * yuvYb + (g) * yuvYg + \
(r) * yuvYr))
#define ET_RGB_TO_U(y,b)      (int)(yuv_descale(((b) - (y)) * yuvCb) + 128)
#define ET_RGB_TO_V(y,r)      (int)(yuv_descale(((r) - (y)) * yuvCr) + 128)
    
#ifdef __cplusplus
}
#endif
#endif

@interface ColorFormatUtil : NSObject
+ (unsigned char *) bitmapFromImage: (UIImage *) image;
+ (UIImage *) imageWithBits: (unsigned char *) bits withSize: (CGSize) size;
@end
