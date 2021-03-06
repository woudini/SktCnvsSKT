//
//  DeckMaker.m
//  starterkit
//
//  Created by Woudini on 12/1/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "SKTDeckMakerView.h"
#import <QuartzCore/QuartzCore.h>
@interface SKTDeckMakerView ()

@end

@implementation SKTDeckMakerView

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO; // I'm not opaque
    self.contentMode = UIViewContentModeRedraw; // want to redraw if bounds change
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    [self setup];
    return self;
}

-(int)scaleFactorForDevice
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1;
}

-(int)adjustedXOriginForDevice
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0 : -35;
}


-(int)adjustedYOriginForDevice
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (self.bounds.size.height-70)/2-(168*2)+2 : (self.bounds.size.height-70)/2-(168)+1;
}

-(int)adjustedHeightForDevice
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.bounds.size.width : self.bounds.size.height-100;
//    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.bounds.size.width : self.bounds.size.width;
}

-(int)adjustedWidthForDevice
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.bounds.size.width : self.bounds.size.width+70;
//    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.bounds.size.width : self.bounds.size.width;
}


- (void)drawRect:(CGRect)aRect
{
    // NSLog(@"drawRect called");
    CGFloat width = self.bounds.size.width; //width of the screen
    CGFloat height = self.bounds.size.height-70; //height of the screen
    
    CGFloat scaleFactor = [self scaleFactorForDevice];
    
    // widths: iphone 6: 375; iphone 6+: 414; 320 other models
        UIBezierPath *path = [[UIBezierPath alloc] init];
    
        // MISC NOTES:
        //  CGPoint topLeft = CGPointMake(self.navbarheight, 150); It would be nice to get the nav bar height
        //  Create scale factor for screen size- truck is too small

        //top left corner
        [path moveToPoint:CGPointMake(width/2-(50*scaleFactor), height/2-(90*scaleFactor))];
        [path addQuadCurveToPoint:CGPointMake(width/2,height/2-(168*scaleFactor)) controlPoint:CGPointMake(width/2-(50*scaleFactor),height/2-(168*scaleFactor))];
    
        //top right corner
        [path addQuadCurveToPoint:CGPointMake(width/2+(50*scaleFactor),height/2-(90*scaleFactor)) controlPoint:CGPointMake(width/2+(50*scaleFactor),height/2-(168*scaleFactor))];
    
        //right side
        [path addLineToPoint:CGPointMake(width/2+(50*scaleFactor), height/2+(140*scaleFactor))];
    
        //bottom right corner
        [path addQuadCurveToPoint:CGPointMake(width/2,height/2+(218*scaleFactor)) controlPoint:CGPointMake(width/2+(50*scaleFactor),height/2+(218*scaleFactor))];
    
        //bottom left corner
        [path addQuadCurveToPoint:CGPointMake(width/2-(50*scaleFactor),height/2+(140*scaleFactor)) controlPoint:CGPointMake(width/2-(50*scaleFactor),height/2+(218*scaleFactor))];
        [path closePath];
        
        [[UIColor blackColor] setStroke];
        
        [path stroke];
        
        // Fill the area outside of the bezier path we created with white
        // [path fill] does not cover the outside area with white; image shows through outside of the shape
        [[UIColor whiteColor] setFill];
        UIRectFill(aRect);
    
        // Cut a hole in the shape of the path, revealing the image in DeckViewController
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
        [path fill];
    
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    
        // Draw bolts
    NSArray *boltCGPointsArray = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:CGPointMake(width/2-10*scaleFactor, height/2-90*scaleFactor)],
                                                                      [NSValue valueWithCGPoint:CGPointMake(width/2+10*scaleFactor, height/2-90*scaleFactor)],
                                                                      [NSValue valueWithCGPoint:CGPointMake(width/2-10*scaleFactor, height/2-65*scaleFactor)],
                                                                      [NSValue valueWithCGPoint:CGPointMake(width/2+10*scaleFactor, height/2-65*scaleFactor)],
                                                                      [NSValue valueWithCGPoint:CGPointMake(width/2-10*scaleFactor, height/2+140*scaleFactor-25*scaleFactor)],
                                                                      [NSValue valueWithCGPoint:CGPointMake(width/2+10*scaleFactor, height/2+140*scaleFactor-25*scaleFactor)],
                                                                      [NSValue valueWithCGPoint:CGPointMake(width/2-10*scaleFactor, height/2+140*scaleFactor)],
                                                                      [NSValue valueWithCGPoint:CGPointMake(width/2+10*scaleFactor, height/2+140*scaleFactor)],nil];
    [[UIColor blackColor] setFill];
    
    for (NSValue *value in boltCGPointsArray)
    {
        UIBezierPath *bolt = [UIBezierPath bezierPathWithArcCenter:[value CGPointValue]
                                                            radius:1*scaleFactor
                                                        startAngle:0
                                                          endAngle:180
                                                         clockwise:YES];
        [bolt stroke];
        [bolt fill];
    }
        // Attempt to draw shadow
   /*     CGContextRef ctx2 = UIGraphicsGetCurrentContext();
        CGContextSetShadowWithColor(ctx2, CGSizeMake(-2,+2), 5, [[UIColor blackColor] CGColor]);
        [[UIColor grayColor] setStroke]; */
    
    // Redraw the path, as it has been changed to white
    [path stroke];
    
}

@end
