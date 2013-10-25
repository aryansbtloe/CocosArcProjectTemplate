//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#ifndef UIDevice_Macros_h
#define UIDevice_Macros_h

#define IS_IPAD                                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                                       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5                                     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

#define CURRENT_DEVICE_VERSION_FLOAT  [[UIDevice currentDevice] systemVersion].floatValue
#define CURRENT_DEVICE_VERSION_STRING [[[NSBundle mainBundle] infoDictionary] objectForKey : @ "CFBundleVersion"]

#define IS_CAMERA_AVAILABLE [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]

#endif
