//
//  UIColor+Utilities.m
//  ColorAlgorithm
//
//  Created by Quenton Jones on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSColor+Utilities.h"


@implementation NSColor (Utilities)

+ (NSArray *)calveticaPalette {
    return @[
            [NSColor colorWithRed:1 green:1 blue:1 alpha:1],
            [NSColor colorWithRed:.5 green:.5 blue:.5 alpha:1],

            [NSColor colorWithRed:1 green:1 blue:0 alpha:1],
            [NSColor colorWithRed:1 green:0 blue:0 alpha:1],
            [NSColor colorWithRed:0 green:1 blue:0 alpha:1],
            [NSColor colorWithRed:1 green:0 blue:1 alpha:1],
            [NSColor colorWithRed:0 green:1 blue:1 alpha:1],
            [NSColor colorWithRed:0 green:0 blue:1 alpha:1],

            [NSColor colorWithRed:0 green:0 blue:0 alpha:1],
    ];
}

- (NSColor *)closestColorInCalveticaPalette {
    return [self closestColorInPalette:[NSColor calveticaPalette]];
}

- (NSColor *)closestColorInPalette:(NSArray *)palette {
    CGFloat bestDifference = MAXFLOAT;
    NSColor *bestColor = nil;

    CGFloat *lab1 = [self colorToLab];
    CGFloat C1 = sqrtf((float) (lab1[1] * lab1[1] + lab1[2] * lab1[2]));

    for (NSColor *color in palette) {
        CGFloat *lab2 = [color colorToLab];
        CGFloat C2 = sqrtf((float) (lab2[1] * lab2[1] + lab2[2] * lab2[2]));

        CGFloat deltaL = lab1[0] - lab2[0];
        CGFloat deltaC = C1 - C2;
        CGFloat deltaA = lab1[1] - lab2[1];
        CGFloat deltaB = lab1[2] - lab2[2];
        CGFloat deltaH = sqrtf((float) (deltaA * deltaA + deltaB * deltaB - deltaC * deltaC));

        CGFloat deltaE = sqrtf(powf((float) (deltaL / K_L), 2) + powf((float) (deltaC / (1 + K_1 * C1)), 2) + powf((float) (deltaH / (1 + K_2 * C1)), 2));
        if (deltaE < bestDifference) {
            bestColor = color;
            bestDifference = deltaE;
        }

        free(lab2);
    }

    NSLog(@"Color Difference: %f", bestDifference);
    NSLog(@"Color: %@", bestColor);

    free(lab1);
    return bestColor;
}

- (CGFloat *)colorToLab {
    // Don't allow grayscale colors.
    if (CGColorGetNumberOfComponents(self.CGColor) != 4) {
        return nil;
    }

    CGFloat *rgb = (CGFloat *) malloc(3 * sizeof(CGFloat));
    const CGFloat *components = CGColorGetComponents(self.CGColor);

    rgb[0] = components[0];
    rgb[1] = components[1];
    rgb[2] = components[2];

    //NSLog(@"Color (RGB) %@: r: %i g: %i b: %i", self, (int)(rgb[0] * 255), (int)(rgb[1] * 255), (int)(rgb[2] * 255));

    CGFloat *lab = [NSColor rgbToLab:rgb];
    free(rgb);

    //NSLog(@"Color (Lab) %@: L: %f a: %f b: %f", self, lab[0], lab[1], lab[2]);

    return lab;
}

+ (CGFloat *)rgbToLab:(CGFloat *)rgb {
    CGFloat *xyz = [NSColor rgbToXYZ:rgb];
    CGFloat *lab = [NSColor xyzToLab:xyz];

    free(xyz);
    return lab;
}

+ (CGFloat *)rgbToXYZ:(CGFloat *)rgb {
    CGFloat *newRGB = (CGFloat *) malloc(3 * sizeof(CGFloat));

    for (int i = 0; i < 3; i++) {
        CGFloat component = rgb[i];

        if (component > 0.04045f) {
            component = powf((float) ((component + 0.055f) / 1.055f), 2.4f);
        } else {
            component = component / 12.92f;
        }

        newRGB[i] = component;
    }

    newRGB[0] = newRGB[0] * 100.0f;
    newRGB[1] = newRGB[1] * 100.0f;
    newRGB[2] = newRGB[2] * 100.0f;

    CGFloat *xyz = (CGFloat *) malloc(3 * sizeof(CGFloat));
    xyz[0] = (newRGB[0] * 0.4124f) + (newRGB[1] * 0.3576f) + (newRGB[2] * 0.1805f);
    xyz[1] = (newRGB[0] * 0.2126f) + (newRGB[1] * 0.7152f) + (newRGB[2] * 0.0722f);
    xyz[2] = (newRGB[0] * 0.0193f) + (newRGB[1] * 0.1192f) + (newRGB[2] * 0.9505f);

    free(newRGB);
    return xyz;
}

+ (CGFloat *)xyzToLab:(CGFloat *)xyz {
    CGFloat *newXYZ = (CGFloat *) malloc(3 * sizeof(CGFloat));
    newXYZ[0] = xyz[0] / X_REF;
    newXYZ[1] = xyz[1] / Y_REF;
    newXYZ[2] = xyz[2] / Z_REF;

    for (int i = 0; i < 3; i++) {
        CGFloat component = newXYZ[i];

        if (component > 0.008856) {
            component = powf((float) component, 0.333f);
        } else {
            component = (7.787 * component) + (16 / 116);
        }

        newXYZ[i] = component;
    }

    CGFloat *lab = (CGFloat *) malloc(3 * sizeof(CGFloat));
    lab[0] = (116 * newXYZ[1]) - 16;
    lab[1] = 500 * (newXYZ[0] - newXYZ[1]);
    lab[2] = 200 * (newXYZ[1] - newXYZ[2]);

    free(newXYZ);
    return lab;
}

@end
