//
//  YGProgressCell.m
//  iSpoiler
//
//  Created by Yannick Heinrich on 03/10/13.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGProgressCell.h"
#import "NSColor+CGColor.h"

#define WIDTH_RATIO 0.9
#define HEIGHT_RATIO 0.7
@implementation YGProgressCell

- (void) drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    float value = [self.objectValue floatValue];
    if(value < 0)
        return;
    
    NSPoint cellOrigin = cellFrame.origin;
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, NSRectToCGRect(cellFrame));
    CGContextClip(context);
    
    CGSize cellSize = CGSizeMake(cellFrame.size.width*WIDTH_RATIO, cellFrame.size.height*HEIGHT_RATIO);
    
    
    CGRect borderRect = CGRectMake((cellFrame.size.width - cellSize.width)/2+cellOrigin.x, (cellFrame.size.height - cellSize.height)/2+cellOrigin.y, cellSize.width, cellSize.height);
    
   
    CGContextSetStrokeColorWithColor(context,[NSColor grayColor].toCGColor);
    CGContextStrokeRect(context, borderRect);
    
    
    CGFloat fillWidth = value*borderRect.size.width;
    CGRect progress = borderRect;
    progress.size.width = fillWidth;
    
    CGContextSetFillColorWithColor(context,[NSColor grayColor].toCGColor);
    CGContextFillRect(context, progress);
    
    CGContextRestoreGState(context);

}
@end
