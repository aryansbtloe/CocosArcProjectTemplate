//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#ifndef NSLog_Helper_Macros_h
#define NSLog_Helper_Macros_h

#   define LOG(...)         NSLog(__VA_ARGS__)
#   define LOG_LINE         NSLog(@"---------------");
#   define LOG_BREAK        { for (int i = 0; i < 2; i++) NSLog(@" "); }
#   define LOG_METHOD       NSLog(@"%s line %d", __func__, __LINE__)
#   define LOG_RETAIN(obj)  NSLog(@"%s retainCount=%d", #obj, (int)CFGetRetainCount((__bridge CFTypeRef)obj))
#   define LOG_OBJECT(obj)  NSLog(@"%s=%@", #obj, obj)
#   define LOG_DATE(date)   NSLog(@"%s=%@", #date, [date descriptionWithLocale:[NSLocale currentLocale]])
#   define LOG_INT(i)       NSLog(@"%s=%d", #i, i)
#   define LOG_FLOAT(f)     NSLog(@"%s=%f", #f, f)
#   define LOG_RECT(rect)   NSLog(@"%s x=%.2f, y=%.2f, w=%.2f, h=%.2f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#   define LOG_POINT(pt)    NSLog(@"%s x=%.2f, y=%.2f", #pt, pt.x, pt.y)
#   define LOG_SIZE(size)   NSLog(@"%s w=%.2f, h=%.2f", #size, size.width, size.height)
#   define LOG_RANGE(range) NSLog(@"%s loc=%d, len=%d", #range, range.location, range.length)
#   define LOG_TRANSFORM(transform)     NSLog(@"%s = %@", #transform, NSStringFromCGAffineTransform(transform));
#   define LOG_TRANSFORM3D(transform3D) NSLog(@"%s =\n%f %f %f %f\n%f %f %f %f\n%f %f %f %f\n%f %f %f %f\n\n",#transform3D,transform3D.m11,transform3D.m12,transform3D.m13,transform3D.m14,transform3D.m21,transform3D.m22,transform3D.m23,transform3D.m24,transform3D.m31,transform3D.m32,transform3D.m33,transform3D.m34,transform3D.m41,transform3D.m42,transform3D.m43,transform3D.m44);

#   define LOG_THREAD       NSLog(@"thread=%@", [NSThread currentThread])
#   define LOG_STACK        NSLog(@"%@", [NSThread callStackSymbols])

#   define LOG_SUPERVIEWS(_VIEW)    { for (UIView* view = _VIEW; view; view = view.superview) { NSLog(@"%@", view); } }
#   define LOG_SUBVIEWS(_VIEW)      NSLog(@"%@", [_VIEW performSelector:@selector(recursiveDescription)])

#   define LOG_START(name)  CFAbsoluteTime name##_startTime = CFAbsoluteTimeGetCurrent();
#   define LOG_STOP(name)   NSLog(@"%s time=%f sec",#name, CFAbsoluteTimeGetCurrent() - name##_startTime);

#endif
