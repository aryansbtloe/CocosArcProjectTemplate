//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#ifndef HelperMacros_h
#define HelperMacros_h

#define BOX_BOOL(x) [NSNumber numberWithBool:(x)]
#define BOX_INT(x) [NSNumber numberWithInt:(x)]
#define BOX_SHORT(x) [NSNumber numberWithShort:(x)]
#define BOX_LONG(x) [NSNumber numberWithLong:(x)]
#define BOX_UINT(x) [NSNumber numberWithUnsignedInt:(x)]
#define BOX_FLOAT(x) [NSNumber numberWithFloat:(x)]
#define BOX_DOUBLE(x) [NSNumber numberWithDouble:(x)]

#define UNBOX_BOOL(x) [(x) boolValue]
#define UNBOX_INT(x) [(x) intValue]
#define UNBOX_SHORT(x) [(x) shortValue]
#define UNBOX_LONG(x) [(x) longValue]
#define UNBOX_UINT(x) [(x) unsignedIntValue]
#define UNBOX_FLOAT(x) [(x) floatValue]
#define UNBOX_DOUBLE(x) [(x) doubleValue]

#endif
