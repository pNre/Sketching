//
//  Sketching.h
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

//! Project version number for Sketching.
FOUNDATION_EXPORT double SketchingVersionNumber;

//! Project version string for Sketching.
FOUNDATION_EXPORT const unsigned char SketchingVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Sketching/PublicHeader.h>


