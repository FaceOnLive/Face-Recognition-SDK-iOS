# FaceOnLive — Face Recognition & Liveness SDK for iOS

On-device face detection, **face liveness (anti-spoofing)**, and 1:1 / 1:N face matching for iOS. All processing runs locally — no image ever leaves the device.

> Part of the [FaceOnLive](https://faceonlive.com) on-premises biometric SDK suite.

## Features
- Face detection with landmarks and a **liveness score** (blocks photos, videos, masks).
- Face template extraction and similarity comparison for verification & identification.
- Fully on-device and offline; camera and image input.

## Requirements
| | |
|---|---|
| Min iOS | 13.0+ |
| Language | Swift |
| IDE | Xcode 14+ |
| Framework | `facesdk.framework` (included) |

## Setup
1. Open `FaceDemo.xcodeproj` (or the workspace) in **Xcode**.
2. Get a license key — free trial at **https://faceonlive.com**.
3. In `FaceDemo/ViewController.swift`, replace `<YOUR_LICENSE_KEY>` in `FaceSDK.setActivation(...)`.
4. Build and run on a device.

## Quick start
```swift
var ret = FaceSDK.setActivation("<YOUR_LICENSE_KEY>")
if ret == SDK_SUCCESS.rawValue {
    ret = FaceSDK.initSDK()
}

let faces = FaceSDK.faceDetection(image)          // detect + liveness
let t1 = FaceSDK.templateExtraction(image1, faces1[0])
let t2 = FaceSDK.templateExtraction(image2, faces2[0])
let similarity = FaceSDK.similarityCalculation(t1, t2)   // 0.0 – 1.0
```

## API reference
| Method | Description | Returns |
|---|---|---|
| `setActivation(license)` | Activate with your license key. | `SDK_SUCCESS` or error |
| `initSDK()` | Load the face models. | `SDK_SUCCESS` or error |
| `faceDetection(image)` | Detect faces (box, landmarks, liveness score). | array of faces |
| `templateExtraction(image, face)` | Extract a face's feature template. | template |
| `similarityCalculation(t1, t2)` | Compare two templates. | `0.0–1.0` |

**Status codes:** `SDK_SUCCESS`, `SDK_LICENSE_KEY_ERROR`, `SDK_LICENSE_APPID_ERROR`, `SDK_LICENSE_EXPIRED`, `SDK_NO_ACTIVATED`, `SDK_INIT_ERROR`.

## License & support
Requires a valid license key — get one at **[faceonlive.com](https://faceonlive.com)**. Never commit your key. Questions: contact@faceonlive.com

## 📦 Full SDK download
This repository contains the source/demo code only. Download the complete SDK — engine libraries and models, with full project structure — from the [Releases](../../releases) page and extract it over this project.
