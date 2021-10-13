//
//  ColorFormatUtil.mm
//

#import "ColorFormatUtil.h"
#import <CoreGraphics/CoreGraphics.h>

#define TRIMBYTE(x)    (MUInt8)((x)&(~255)?((-(x))>>31):(x))

void RGBA8888ToBGR(unsigned char* pRGBA, int width, int height,int pitch, unsigned char* pBGR)
{
    int iSrcXStride = LINE_BYTES(width, 24);
    int iSrcXStride2 = LINE_BYTES(width, 32);
    int i, j;
    for(i = 0; i < height; i++)
    {
        for(j = 0; j < width; j++)
        {
            pBGR[i*iSrcXStride+j*3]=pRGBA[i*iSrcXStride2+j*4+2];
            pBGR[i*iSrcXStride+j*3+1]=pRGBA[i*iSrcXStride2+j*4+1];
            pBGR[i*iSrcXStride+j*3+2] = pRGBA[i*iSrcXStride2+j*4];
        }
    }
}

void RGBA8888ToRGB(unsigned char* pRGBA, int width, int height,int pitch, unsigned char* pBGR)
{
    int iSrcXStride = LINE_BYTES(width, 24);
    int iSrcXStride2 = LINE_BYTES(width, 32);
    int i, j;
    for(i = 0; i < height; i++)
    {
        for(j = 0; j < width; j++)
        {
            pBGR[i*iSrcXStride+j*3  ]=pRGBA[i*iSrcXStride2+j*4];
            pBGR[i*iSrcXStride+j*3+1]=pRGBA[i*iSrcXStride2+j*4+1];
            pBGR[i*iSrcXStride+j*3+2] = pRGBA[i*iSrcXStride2+j*4 + 2];
        }
    }
}
void BGR2NV21(unsigned char *pBGR, int nW, int nH, unsigned char *pYUVY, int lYStride, unsigned char *pYUVUV, int lUVStride) {
    unsigned int x;
    int y;
    BYTE *pbSrcX = pBGR;
    BYTE *pbDstY = pYUVY;
    BYTE *pbDstUV = pYUVUV;
    
    int iSrcXStride = LINE_BYTES(nW, 24);
    int iDstYStride = lYStride;
    int iDstUVStride = lUVStride;
    int iSrcXDif;
    int iDstYDif;
    int iDstUVDif;
    
    iSrcXDif = iSrcXStride - (nW * 3);
    iDstYDif = iDstYStride - nW;
    iDstUVDif = iDstUVStride - nW;
    
    for (y = nH / 2; y; y--)
    {
        for (x = nW / 2; x; x--)
        {
            int r, g, b, y0, y1, y2, y3, cb, cr;
            
            b = pbSrcX[0];
            g = pbSrcX[1];
            r = pbSrcX[2];
            y0 = yuv_descale(b*yuvYb + g*yuvYg + r*yuvYr);
            cb = yuv_descale((b - y0)*yuvCb) + 128;
            cr = yuv_descale((r - y0)*yuvCr) + 128;
            
            b = pbSrcX[3];
            g = pbSrcX[4];
            r = pbSrcX[5];
            y1 = yuv_descale(b*yuvYb + g*yuvYg + r*yuvYr);
            cb += yuv_descale((b - y1)*yuvCb) + 128;
            cr += yuv_descale((r - y1)*yuvCr) + 128;
            
            b = pbSrcX[iSrcXStride  ];
            g = pbSrcX[iSrcXStride+1];
            r = pbSrcX[iSrcXStride+2];
            y2 = yuv_descale(b*yuvYb + g*yuvYg + r*yuvYr);
            cb += yuv_descale((b - y2)*yuvCb) + 128;
            cr += yuv_descale((r - y2)*yuvCr) + 128;
            
            b = pbSrcX[iSrcXStride+3];
            g = pbSrcX[iSrcXStride+4];
            r = pbSrcX[iSrcXStride+5];
            y3 = yuv_descale(b*yuvYb + g*yuvYg + r*yuvYr);
            cb += yuv_descale((b - y3)*yuvCb) + 128;
            cr += yuv_descale((r - y3)*yuvCr) + 128;
            
            pbDstY[0] = ET_CAST_8U(y0);
            pbDstY[1] = ET_CAST_8U(y1);
            pbDstY[iDstYStride  ] = ET_CAST_8U(y2);
            pbDstY[iDstYStride+1] = ET_CAST_8U(y3);
            pbDstUV[0] = ET_CAST_8U(cr>>2);
            pbDstUV[1] = ET_CAST_8U(cb>>2);
            
            pbSrcX += 6;
            pbDstY += 2;
            pbDstUV += 2;
        }
        
        pbSrcX += iSrcXDif + iSrcXStride;
        pbDstY += iDstYDif + iDstYStride;
        pbDstUV += iDstUVDif;
    }
}

void BGRToNV12(unsigned char *pBGR, int nW, int nH, unsigned char *pYUVY, int lYStride, unsigned char *pYUVUV, int lUVStride)
{
    unsigned int x;
    int y;
    unsigned char *pbSrcX = pBGR;
    unsigned char *pbDstY = pYUVY;
    unsigned char *pbDstUV = pYUVUV;
    
    int iSrcXStride = LINE_BYTES(nW, 24);
    int iDstYStride = lYStride;
    int iDstUVStride = lUVStride;
    int iSrcXDif;
    int iDstYDif;
    int iDstUVDif;
    
    iSrcXDif = iSrcXStride - (nW * 3);
    iDstYDif = iDstYStride - nW;
    iDstUVDif = iDstUVStride - nW;
    
    for (y = nH / 2; y; y--)
    {
        for (x = nW / 2; x; x--)
        {
            int r, g, b, y0, y1, y2, y3, cb, cr;
            
            b = pbSrcX[0];
            g = pbSrcX[1];
            r = pbSrcX[2];
            y0 = yuv_descale(b*yuvYb + g*yuvYg + r*yuvYr);
            cb = yuv_descale((b - y0)*yuvCb) + 128;
            cr = yuv_descale((r - y0)*yuvCr) + 128;
            
            b = pbSrcX[3];
            g = pbSrcX[4];
            r = pbSrcX[5];
            y1 = yuv_descale(b*yuvYb + g*yuvYg + r*yuvYr);
            cb += yuv_descale((b - y1)*yuvCb) + 128;
            cr += yuv_descale((r - y1)*yuvCr) + 128;
            
            b = pbSrcX[iSrcXStride  ];
            g = pbSrcX[iSrcXStride+1];
            r = pbSrcX[iSrcXStride+2];
            y2 = yuv_descale(b*yuvYb + g*yuvYg + r*yuvYr);
            cb += yuv_descale((b - y2)*yuvCb) + 128;
            cr += yuv_descale((r - y2)*yuvCr) + 128;
            
            b = pbSrcX[iSrcXStride+3];
            g = pbSrcX[iSrcXStride+4];
            r = pbSrcX[iSrcXStride+5];
            y3 = yuv_descale(b*yuvYb + g*yuvYg + r*yuvYr);
            cb += yuv_descale((b - y3)*yuvCb) + 128;
            cr += yuv_descale((r - y3)*yuvCr) + 128;
            
            pbDstY[0] = ET_CAST_8U(y0);
            pbDstY[1] = ET_CAST_8U(y1);
            pbDstY[iDstYStride  ] = ET_CAST_8U(y2);
            pbDstY[iDstYStride+1] = ET_CAST_8U(y3);
            pbDstUV[0] = ET_CAST_8U(cb>>2);
            pbDstUV[1] = ET_CAST_8U(cr>>2);
            
            pbSrcX += 6;
            pbDstY += 2;
            pbDstUV += 2;
        }
        
        pbSrcX += iSrcXDif + iSrcXStride;
        pbDstY += iDstYDif + iDstYStride;
        pbDstUV += iDstUVDif;
    }
}

@implementation ColorFormatUtil
+ (UIImage *) imageWithBits: (unsigned char *) bits withSize: (CGSize) size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        free(bits);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate (bits, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    if (context == NULL)
    {
        fprintf (stderr, "Error: Context not created!");
        free (bits);
        CGColorSpaceRelease(colorSpace );
        return nil;
    }
    
    CGColorSpaceRelease(colorSpace );
    CGImageRef ref = CGBitmapContextCreateImage(context);
    free(CGBitmapContextGetData(context));
    CGContextRelease(context);
    
    UIImage *img = [UIImage imageWithCGImage:ref];
    CFRelease(ref);
    return img;
}

+ (unsigned char *) bitmapFromImage: (UIImage *) image
{
    CGContextRef context = _fxiang_CreateARGBBitmapContext(image.size);
    if (context == NULL) return NULL;
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    unsigned char *data = (unsigned char *)CGBitmapContextGetData (context);
    CGContextRelease(context);
    return data;
}

CGContextRef _fxiang_CreateARGBBitmapContext (CGSize size)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    void *bitmapData = malloc(size.width * size.height * 4);
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Error: Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    CGContextRef context = CGBitmapContextCreate (bitmapData, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace );
    if (context == NULL)
    {
        fprintf (stderr, "Error: Context not created!");
        free (bitmapData);
        return NULL;
    }
    
    return context;
}

@end
