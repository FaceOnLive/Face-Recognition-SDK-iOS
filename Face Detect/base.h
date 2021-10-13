//
// Created by demid on 2/23/2017.
//

#ifndef IDVERIFYDEMO_BASE_H
#define IDVERIFYDEMO_BASE_H

#import <Foundation/Foundation.h>

typedef struct _FaceBox {
    float confidence;
    float x1;
    float y1;
    float x2;
    float y2;
    int trackID;
} FaceBox;


#endif //IDVERIFYDEMO_BASE_H
