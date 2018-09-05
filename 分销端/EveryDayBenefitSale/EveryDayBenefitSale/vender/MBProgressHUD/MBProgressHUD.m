////
//// MBProgressHUD.m
//// Version 0.4
//// Created by Matej Bukovinski on 2.4.09.
////
//
//#import "MBProgressHUD.h"
//
//@interface MBProgressHUD ()
//
//- (void)hideUsingAnimation:(BOOL)animated;
//- (void)showUsingAnimation:(BOOL)animated;
//- (void)done;
//- (void)updateLabelText:(NSString *)newText;
//- (void)updateDetailsLabelText:(NSString *)newText;
//- (void)updateProgress;
//- (void)updateIndicators;
//- (void)handleGraceTimer:(NSTimer *)theTimer;
//- (void)handleMinShowTimer:(NSTimer *)theTimer;
//- (void)setTransformForCurrentOrientation:(BOOL)animated;
//- (void)cleanUp;
//- (void)launchExecution;
//- (void)deviceOrientationDidChange:(NSNotification *)notification;
//- (void)hideDelayed:(NSNumber *)animated;
//- (void)launchExecution;
//- (void)cleanUp;
//
//#if __has_feature(objc_arc)
//@property (strong) UIView *indicator;
//@property (strong) NSTimer *graceTimer;
//@property (strong) NSTimer *minShowTimer;
//@property (strong) NSDate *showStarted;
//#else
//@property (retain) UIView *indicator;
//@property (retain) NSTimer *graceTimer;
//@property (retain) NSTimer *minShowTimer;
//@property (retain) NSDate *showStarted;
//#endif
//
//@property (assign) float width;
//@property (assign) float height;
//
//@end
//
//
//@implementation MBProgressHUD
//
//#pragma mark -
//#pragma mark Accessors
//
//@synthesize animationType;
//
//@synthesize delegate;
//@synthesize opacity;
//@synthesize labelFont;
//@synthesize detailsLabelFont;
//
//@synthesize indicator;
//
//@synthesize width;
//@synthesize height;
//@synthesize xOffset;
//@synthesize yOffset;
//@synthesize minSize;
//@synthesize square;
//@synthesize margin;
//@synthesize dimBackground;
//
//@synthesize graceTime;
//@synthesize minShowTime;
//@synthesize graceTimer;
//@synthesize minShowTimer;
//@synthesize taskInProgress;
//@synthesize removeFromSuperViewOnHide;
//
//@synthesize customView;
//
//@synthesize showStarted;
//
//- (void)setMode:(MBProgressHUDMode)newMode {
//    // Dont change mode if it wasn't actually changed to prevent flickering
//    if (mode && (mode == newMode)) {
//        return;
//    }
//	
//    mode = newMode;
//	
//	if ([NSThread isMainThread]) {
//		[self updateIndicators];
//		[self setNeedsLayout];
//		[self setNeedsDisplay];
//	} else {
//		[self performSelectorOnMainThread:@selector(updateIndicators) withObject:nil waitUntilDone:NO];
//		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
//		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
//	}
//}
//
//- (MBProgressHUDMode)mode {
//	return mode;
//}
//
//- (void)setLabelText:(NSString *)newText {
//	if ([NSThread isMainThread]) {
//		[self updateLabelText:newText];
//		[self setNeedsLayout];
//		[self setNeedsDisplay];
//	} else {
//		[self performSelectorOnMainThread:@selector(updateLabelText:) withObject:newText waitUntilDone:NO];
//		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
//		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
//	}
//}
//
//- (NSString *)labelText {
//	return labelText;
//}
//
//- (void)setDetailsLabelText:(NSString *)newText {
//	if ([NSThread isMainThread]) {
//		[self updateDetailsLabelText:newText];
//		[self setNeedsLayout];
//		[self setNeedsDisplay];
//	} else {
//		[self performSelectorOnMainThread:@selector(updateDetailsLabelText:) withObject:newText waitUntilDone:NO];
//		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
//		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
//	}
//}
//
//- (NSString *)detailsLabelText {
//	return detailsLabelText;
//}
//
//- (void)setProgress:(float)newProgress {
//    progress = newProgress;
//	
//    // Update display ony if showing the determinate progress view
//    if (mode == MBProgressHUDModeDeterminate) {
//		if ([NSThread isMainThread]) {
//			[self updateProgress];
//			[self setNeedsDisplay];
//		} else {
//			[self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO];
//			[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
//		}
//    }
//}
//
//- (float)progress {
//	return progress;
//}
//
//#pragma mark -
//#pragma mark Accessor helpers
//
//- (void)updateLabelText:(NSString *)newText {
//    if (labelText != newText) {
//#if !__has_feature(objc_arc)
//        [labelText release];
//#endif
//        labelText = [newText copy];
//    }
//}
//
//- (void)updateDetailsLabelText:(NSString *)newText {
//    if (detailsLabelText != newText) {
//#if !__has_feature(objc_arc)
//        [detailsLabelText release];
//#endif
//        detailsLabelText = [newText copy];
//    }
//}
//
//- (void)updateProgress {
//    [(MBRoundProgressView *)indicator setProgress:progress];
//}
//
//- (void)updateIndicators {
//    if (indicator) {
//        [indicator removeFromSuperview];
//    }
//	
//    if (mode == MBProgressHUDModeDeterminate) {
//#if __has_feature(objc_arc)
//        self.indicator = [[MBRoundProgressView alloc] init];
//#else
//        self.indicator = [[[MBRoundProgressView alloc] init] autorelease];
//#endif
//}
//    else if (mode == MBProgressHUDModeCustomView && self.customView != nil){
//        self.indicator = self.customView;
//    } else {
//#if __has_feature(objc_arc)
//		self.indicator = [[UIActivityIndicatorView alloc]
//						   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//#else
//		self.indicator = [[[UIActivityIndicatorView alloc]
//						   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
//#endif
//        [(UIActivityIndicatorView *)indicator startAnimating];
//	}
//	
//	
//    [self addSubview:indicator];
//}
//
//#pragma mark -
//#pragma mark Constants
//
//#define PADDING 4.0f
//
//#define LABELFONTSIZE 16.0f
//#define LABELDETAILSFONTSIZE 12.0f
//
//#pragma mark -
//#pragma mark Class methods
//
//+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
//	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
//	[view addSubview:hud];
//	[hud show:animated];
//#if __has_feature(objc_arc)
//	return hud;
//#else
//	return [hud autorelease];
//#endif
//}
//
//+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
//	UIView *viewToRemove = nil;
//	for (UIView *v in [view subviews]) {
//		if ([v isKindOfClass:[MBProgressHUD class]]) {
//			viewToRemove = v;
//		}
//	}
//	if (viewToRemove != nil) {
//		MBProgressHUD *HUD = (MBProgressHUD *)viewToRemove;
//		HUD.removeFromSuperViewOnHide = YES;
//		[HUD hide:animated];
//		return YES;
//	} else {
//		return NO;
//	}
//}
//
//
//#pragma mark -
//#pragma mark Lifecycle methods
//
//- (id)initWithWindow:(UIWindow *)window {
//    return [self initWithView:window];
//}
//
//- (id)initWithView:(UIView *)view {
//	// Let's check if the view is nil (this is a common error when using the windw initializer above)
//	if (!view) {
//		[NSException raise:@"MBProgressHUDViewIsNillException" 
//					format:@"The view used in the MBProgressHUD initializer is nil."];
//	}
//	id me = [self initWithFrame:view.bounds];
//	// We need to take care of rotation ourselfs if we're adding the HUD to a window
//	if ([view isKindOfClass:[UIWindow class]]) {
//		[self setTransformForCurrentOrientation:NO];
//	}
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) 
//												 name:UIDeviceOrientationDidChangeNotification object:nil];
//	
//	return me;
//}
//
//- (void)removeFromSuperview {
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIDeviceOrientationDidChangeNotification
//                                                  object:nil];
//    
//    [super removeFromSuperview];
//}
//
//
//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//	if (self) {
//        // Set default values for properties
//        self.animationType = MBProgressHUDAnimationFade;
//        self.mode = MBProgressHUDModeIndeterminate;
//        self.labelText = nil;
//        self.detailsLabelText = nil;
//        self.opacity = 0.8f;
//        self.labelFont = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
//        self.detailsLabelFont = [UIFont boldSystemFontOfSize:LABELDETAILSFONTSIZE];
//        self.xOffset = 0.0f;
//        self.yOffset = 0.0f;
//		self.dimBackground = NO;
//		self.margin = 20.0f;
//		self.graceTime = 0.0f;
//		self.minShowTime = 0.0f;
//		self.removeFromSuperViewOnHide = NO;
//		self.minSize = CGSizeZero;
//		self.square = NO;
//		
//		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//		
//        // Transparent background
//        self.opaque = NO;
//        self.backgroundColor = [UIColor clearColor];
//		
//        // Make invisible for now
//        self.alpha = 0.0f;
//		
//        // Add label
//        label = [[UILabel alloc] initWithFrame:self.bounds];
//		
//        // Add details label
//        detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
//		
//		taskInProgress = NO;
//		rotationTransform = CGAffineTransformIdentity;
//    }
//    return self;
//}
//
//#if !__has_feature(objc_arc)
//- (void)dealloc {
//    [indicator release];
//    [label release];
//    [detailsLabel release];
//    [labelText release];
//    [detailsLabelText release];
//	[graceTimer release];
//	[minShowTimer release];
//	[showStarted release];
//	[customView release];
//    [super dealloc];
//}
//#endif
//
//#pragma mark -
//#pragma mark Layout
//
//- (void)layoutSubviews {
//    CGRect frame = self.bounds;
//	
//    // Compute HUD dimensions based on indicator size (add margin to HUD border)
//    CGRect indFrame = indicator.bounds;
//    self.width = indFrame.size.width + 2 * margin;
//    self.height = indFrame.size.height + 2 * margin;
//	
//    // Position the indicator
//    indFrame.origin.x = floorf((frame.size.width - indFrame.size.width) / 2) + self.xOffset;
//    indFrame.origin.y = floorf((frame.size.height - indFrame.size.height) / 2) + self.yOffset;
//    indicator.frame = indFrame;
//	
//    // Add label if label text was set
//    if (nil != self.labelText) {
//        // Get size of label text
//        CGSize dims = [self.labelText sizeWithFont:self.labelFont];
//		
//        // Compute label dimensions based on font metrics if size is larger than max then clip the label width
//        float lHeight = dims.height;
//        float lWidth;
//        if (dims.width <= (frame.size.width - 4 * margin)) {
//            lWidth = dims.width;
//        }
//        else {
//            lWidth = frame.size.width - 4 * margin;
//        }
//		
//        // Set label properties
//        label.font = self.labelFont;
//        label.adjustsFontSizeToFitWidth = NO;
//        label.textAlignment = UITextAlignmentCenter;
//        label.opaque = NO;
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor whiteColor];
//        label.text = self.labelText;
//		
//        // Update HUD size
//        if (self.width < (lWidth + 2 * margin)) {
//            self.width = lWidth + 2 * margin;
//        }
//        self.height = self.height + lHeight + PADDING;
//		
//        // Move indicator to make room for the label
//        indFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2));
//        indicator.frame = indFrame;
//		
//        // Set the label position and dimensions
//        CGRect lFrame = CGRectMake(floorf((frame.size.width - lWidth) / 2) + xOffset,
//                                   floorf(indFrame.origin.y + indFrame.size.height + PADDING),
//                                   lWidth, lHeight);
//        label.frame = lFrame;
//		
//        [self addSubview:label];
//		
//        // Add details label delatils text was set
//        if (nil != self.detailsLabelText) {
//			
//            // Set label properties
//            detailsLabel.font = self.detailsLabelFont;
//            detailsLabel.adjustsFontSizeToFitWidth = NO;
//            detailsLabel.textAlignment = UITextAlignmentCenter;
//            detailsLabel.opaque = NO;
//            detailsLabel.backgroundColor = [UIColor clearColor];
//            detailsLabel.textColor = [UIColor whiteColor];
//            detailsLabel.text = self.detailsLabelText;
//            detailsLabel.numberOfLines = 0;
//
//			CGFloat maxHeight = frame.size.height - self.height - 2*margin;
//			CGSize labelSize = [detailsLabel.text sizeWithFont:detailsLabel.font constrainedToSize:CGSizeMake(frame.size.width - 4*margin, maxHeight) lineBreakMode:detailsLabel.lineBreakMode];
//            lHeight = labelSize.height;
//            lWidth = labelSize.width;
//			
//            // Update HUD size
//            if (self.width < lWidth) {
//                self.width = lWidth + 2 * margin;
//            }
//            self.height = self.height + lHeight + PADDING;
//			
//            // Move indicator to make room for the new label
//            indFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2));
//            indicator.frame = indFrame;
//			
//            // Move first label to make room for the new label
//            lFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2));
//            label.frame = lFrame;
//			
//            // Set label position and dimensions
//            CGRect lFrameD = CGRectMake(floorf((frame.size.width - lWidth) / 2) + xOffset,
//                                        lFrame.origin.y + lFrame.size.height + PADDING, lWidth, lHeight);
//            detailsLabel.frame = lFrameD;
//			
//            [self addSubview:detailsLabel];
//        }
//    }
//	
//	if (square) {
//		CGFloat max = MAX(self.width, self.height);
//		if (max <= frame.size.width - 2*margin) {
//			self.width = max;
//		}
//		if (max <= frame.size.height - 2*margin) {
//			self.height = max;
//		}
//	}
//	
//	if (self.width < minSize.width) {
//		self.width = minSize.width;
//	} 
//	if (self.height < minSize.height) {
//		self.height = minSize.height;
//	}
//}
//
//#pragma mark -
//#pragma mark Showing and execution
//
//- (void)show:(BOOL)animated {
//	useAnimation = animated;
//	
//	// If the grace time is set postpone the HUD display
//	if (self.graceTime > 0.0) {
//		self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime 
//														   target:self 
//														 selector:@selector(handleGraceTimer:) 
//														 userInfo:nil 
//														  repeats:NO];
//	} 
//	// ... otherwise show the HUD imediately 
//	else {
//		[self setNeedsDisplay];
//		[self showUsingAnimation:useAnimation];
//	}
//}
//
//- (void)hide:(BOOL)animated {
//	useAnimation = animated;
//	
//	// If the minShow time is set, calculate how long the hud was shown,
//	// and pospone the hiding operation if necessary
//	if (self.minShowTime > 0.0 && showStarted) {
//		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
//		if (interv < self.minShowTime) {
//			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) 
//																 target:self 
//															   selector:@selector(handleMinShowTimer:) 
//															   userInfo:nil 
//																repeats:NO];
//			return;
//		} 
//	}
//	
//	// ... otherwise hide the HUD immediately
//    [self hideUsingAnimation:useAnimation];
//}
//
//- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
//	[self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
//}
//
//- (void)hideDelayed:(NSNumber *)animated {
//	[self hide:[animated boolValue]];
//}
//
//- (void)handleGraceTimer:(NSTimer *)theTimer {
//	// Show the HUD only if the task is still running
//	if (taskInProgress) {
//		[self setNeedsDisplay];
//		[self showUsingAnimation:useAnimation];
//	}
//}
//
//- (void)handleMinShowTimer:(NSTimer *)theTimer {
//	[self hideUsingAnimation:useAnimation];
//}
//
//- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
//	
//    methodForExecution = method;
//#if __has_feature(objc_arc)
//    targetForExecution = target;
//    objectForExecution = object;	
//#else
//    targetForExecution = [target retain];
//    objectForExecution = [object retain];
//#endif
//    
//    // Launch execution in new thread
//	taskInProgress = YES;
//    [NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
//	
//	// Show HUD view
//	[self show:animated];
//}
//
//- (void)launchExecution {
//#if !__has_feature(objc_arc)
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//#endif	
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    // Start executing the requested task
//    [targetForExecution performSelector:methodForExecution withObject:objectForExecution];
//#pragma clang diagnostic pop
//    // Task completed, update view in main thread (note: view operations should
//    // be done only in the main thread)
//    [self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
//	
//#if !__has_feature(objc_arc)
//    [pool release];
//#endif
//}
//
//- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
//    [self done];
//}
//
//- (void)done {
//    isFinished = YES;
//	
//    // If delegate was set make the callback
//    self.alpha = 0.0f;
//    
//	if(delegate != nil) {
//        if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
//            [delegate performSelector:@selector(hudWasHidden:) withObject:self];
//        } else if ([delegate respondsToSelector:@selector(hudWasHidden)]) {
//            [delegate performSelector:@selector(hudWasHidden)];
//        }
//	}
//	
//	if (removeFromSuperViewOnHide) {
//		[self removeFromSuperview];
//	}
//}
//
//- (void)cleanUp {
//	taskInProgress = NO;
//	
//	self.indicator = nil;
//	
//#if !__has_feature(objc_arc)
//    [targetForExecution release];
//    [objectForExecution release];
//#endif
//	
//    [self hide:useAnimation];
//}
//
//#pragma mark -
//#pragma mark Fade in and Fade out
//
//- (void)showUsingAnimation:(BOOL)animated {
//    self.alpha = 0.0f;
//    if (animated && animationType == MBProgressHUDAnimationZoom) {
//        self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
//    }
//    
//	self.showStarted = [NSDate date];
//    // Fade in
//    if (animated) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.30];
//        self.alpha = 1.0f;
//        if (animationType == MBProgressHUDAnimationZoom) {
//            self.transform = rotationTransform;
//        }
//        [UIView commitAnimations];
//    }
//    else {
//        self.alpha = 1.0f;
//    }
//}
//
//- (void)hideUsingAnimation:(BOOL)animated {
//    // Fade out
//    if (animated) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.30];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
//        // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
//        // in the done method
//        if (animationType == MBProgressHUDAnimationZoom) {
//            self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
//        }
//        self.alpha = 0.02f;
//        [UIView commitAnimations];
//    }
//    else {
//        self.alpha = 0.0f;
//        [self done];
//    }
//}
//
//#pragma mark BG Drawing
//
//- (void)drawRect:(CGRect)rect {
//	
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    if (dimBackground) {
//        //Gradient colours
//        size_t gradLocationsNum = 2;
//        CGFloat gradLocations[2] = {0.0f, 1.0f};
//        CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f}; 
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
//		CGColorSpaceRelease(colorSpace);
//        
//        //Gradient center
//        CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//        //Gradient radius
//        float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
//        //Gradient draw
//        CGContextDrawRadialGradient (context, gradient, gradCenter,
//                                     0, gradCenter, gradRadius,
//                                     kCGGradientDrawsAfterEndLocation);
//		CGGradientRelease(gradient);
//    }    
//    
//    // Center HUD
//    CGRect allRect = self.bounds;
//    // Draw rounded HUD bacgroud rect
//    CGRect boxRect = CGRectMake(roundf((allRect.size.width - self.width) / 2) + self.xOffset,
//                                roundf((allRect.size.height - self.height) / 2) + self.yOffset, self.width, self.height);
//	// Corner radius
//	float radius = 10.0f;
//	
//    CGContextBeginPath(context);
//    CGContextSetGrayFillColor(context, 0.0f, self.opacity);
//    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
//    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
//    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
//    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
//    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
//}
//
//#pragma mark -
//#pragma mark Manual oritentation change
//
//#define RADIANS(degrees) ((degrees * (float)M_PI) / 180.0f)
//
//- (void)deviceOrientationDidChange:(NSNotification *)notification { 
//	if (!self.superview) {
//		return;
//	}
//	
//	if ([self.superview isKindOfClass:[UIWindow class]]) {
//		[self setTransformForCurrentOrientation:YES];
//	} else {
//		self.bounds = self.superview.bounds;
//		[self setNeedsDisplay];
//	}
//}
//
//- (void)setTransformForCurrentOrientation:(BOOL)animated {
//	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//	NSInteger degrees = 0;
//	
//	// Stay in sync with the superview
//	if (self.superview) {
//		self.bounds = self.superview.bounds;
//		[self setNeedsDisplay];
//	}
//	
//	if (UIInterfaceOrientationIsLandscape(orientation)) {
//		if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; } 
//		else { degrees = 90; }
//		// Window coordinates differ!
//		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
//	} else {
//		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; } 
//		else { degrees = 0; }
//	}
//	
//	rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
//
//	if (animated) {
//		[UIView beginAnimations:nil context:nil];
//	}
//	[self setTransform:rotationTransform];
//	if (animated) {
//		[UIView commitAnimations];
//	}
//}
//
//@end
//
///////////////////////////////////////////////////////////////////////////////////////////////
//
//@implementation MBRoundProgressView
//
//#pragma mark -
//#pragma mark Accessors
//
//- (float)progress {
//    return _progress;
//}
//
//- (void)setProgress:(float)progress {
//    _progress = progress;
//    [self setNeedsDisplay];
//}
//
//#pragma mark -
//#pragma mark Lifecycle
//
//- (id)init {
//    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
//}
//
//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//		self.opaque = NO;
//    }
//    return self;
//}
//
//#pragma mark -
//#pragma mark Drawing
//
//- (void)drawRect:(CGRect)rect {
//    
//    CGRect allRect = self.bounds;
//    CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // Draw background
//    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
//    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.1f); // translucent white
//    CGContextSetLineWidth(context, 2.0f);
//    CGContextFillEllipseInRect(context, circleRect);
//    CGContextStrokeEllipseInRect(context, circleRect);
//    
//    // Draw progress
//    CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
//    CGFloat radius = (allRect.size.width - 4) / 2;
//    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
//    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
//    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
//    CGContextMoveToPoint(context, center.x, center.y);
//    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
//}
//
//@end
//
///////////////////////////////////////////////////////////////////////////////////////////////

//
// MBProgressHUD.m
// Version 0.7
// Created by Matej Bukovinski on 2.4.09.
//

#import "MBProgressHUD.h"


#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp) exp
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define MBLabelAlignmentCenter NSTextAlignmentCenter
#else
#define MBLabelAlignmentCenter UITextAlignmentCenter
#endif


static const CGFloat kPadding = 4.f;
static const CGFloat kLabelFontSize = 12.f;
static const CGFloat kDetailsLabelFontSize = 12.f;


@interface MBProgressHUD ()

- (void)setupLabels;
- (void)registerForKVO;
- (void)unregisterFromKVO;
- (NSArray *)observableKeypaths;
- (void)registerForNotifications;
- (void)unregisterFromNotifications;
- (void)updateUIForKeypath:(NSString *)keyPath;
- (void)hideUsingAnimation:(BOOL)animated;
- (void)showUsingAnimation:(BOOL)animated;
- (void)done;
- (void)updateIndicators;
- (void)handleGraceTimer:(NSTimer *)theTimer;
- (void)handleMinShowTimer:(NSTimer *)theTimer;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (void)cleanUp;
- (void)launchExecution;
- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)hideDelayed:(NSNumber *)animated;

@property (atomic, MB_STRONG) UIView *indicator;
@property (atomic, MB_STRONG) NSTimer *graceTimer;
@property (atomic, MB_STRONG) NSTimer *minShowTimer;
@property (atomic, MB_STRONG) NSDate *showStarted;
@property (atomic, assign) CGSize size;

@end


@implementation MBProgressHUD {
	BOOL useAnimation;
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	UILabel *label;
	UILabel *detailsLabel;
	BOOL isFinished;
	CGAffineTransform rotationTransform;
}

#pragma mark - Properties

@synthesize animationType;
@synthesize delegate;
@synthesize opacity;
@synthesize color;
@synthesize labelFont;
@synthesize detailsLabelFont;
@synthesize indicator;
@synthesize xOffset;
@synthesize yOffset;
@synthesize minSize;
@synthesize square;
@synthesize margin;
@synthesize dimBackground;
@synthesize graceTime;
@synthesize minShowTime;
@synthesize graceTimer;
@synthesize minShowTimer;
@synthesize taskInProgress;
@synthesize removeFromSuperViewOnHide;
@synthesize customView;
@synthesize showStarted;
@synthesize mode;
@synthesize labelText;
@synthesize detailsLabelText;
@synthesize progress;
@synthesize size;
#if NS_BLOCKS_AVAILABLE
@synthesize completionBlock;
#endif

#pragma mark - Class methods

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
	MBProgressHUD *hud = [[self alloc] initWithView:view];
	[view addSubview:hud];
	[hud show:animated];
	return MB_AUTORELEASE(hud);
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
	MBProgressHUD *hud = [self HUDForView:view];
	if (hud != nil) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
		return YES;
	}
	return NO;
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
	NSArray *huds = [MBProgressHUD allHUDsForView:view];
	for (MBProgressHUD *hud in huds) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
	}
	return [huds count];
}

+ (MB_INSTANCETYPE)HUDForView:(UIView *)view {
	NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
	for (UIView *subview in subviewsEnum) {
		if ([subview isKindOfClass:self]) {
			return (MBProgressHUD *)subview;
		}
	}
	return nil;
}

+ (NSArray *)allHUDsForView:(UIView *)view {
	NSMutableArray *huds = [NSMutableArray array];
	NSArray *subviews = view.subviews;
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:self]) {
			[huds addObject:aView];
		}
	}
	return [NSArray arrayWithArray:huds];
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Set default values for properties
		self.animationType = MBProgressHUDAnimationFade;
		self.mode = MBProgressHUDModeIndeterminate;
		self.labelText = nil;
		self.detailsLabelText = nil;
		self.opacity = 0.8f;
        self.color = nil;
		self.labelFont = [UIFont boldSystemFontOfSize:kLabelFontSize];
		self.detailsLabelFont = [UIFont boldSystemFontOfSize:kDetailsLabelFontSize];
		self.xOffset = 0.0f;
		self.yOffset = 0.0f;
		self.dimBackground = NO;
		self.margin = 20.0f;
		self.graceTime = 0.0f;
		self.minShowTime = 0.0f;
		self.removeFromSuperViewOnHide = NO;
		self.minSize = CGSizeZero;
		self.square = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
		// Transparent background
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		// Make it invisible for now
		self.alpha = 0.0f;
		
		taskInProgress = NO;
		rotationTransform = CGAffineTransformIdentity;
		
		[self setupLabels];
		[self updateIndicators];
		[self registerForKVO];
		[self registerForNotifications];
	}
	return self;
}

- (id)initWithView:(UIView *)view {
	NSAssert(view, @"View must not be nil.");
	return [self initWithFrame:view.bounds];
}

- (id)initWithWindow:(UIWindow *)window {
	return [self initWithView:window];
}

- (void)dealloc {
	[self unregisterFromNotifications];
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[color release];
	[indicator release];
	[label release];
	[detailsLabel release];
	[labelText release];
	[detailsLabelText release];
	[graceTimer release];
	[minShowTimer release];
	[showStarted release];
	[customView release];
#if NS_BLOCKS_AVAILABLE
	[completionBlock release];
#endif
	[super dealloc];
#endif
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated {
	useAnimation = animated;
	// If the grace time is set postpone the HUD display
	if (self.graceTime > 0.0) {
		self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime target:self
                                                         selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
	}
	// ... otherwise show the HUD imediately
	else {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)hide:(BOOL)animated {
	useAnimation = animated;
	// If the minShow time is set, calculate how long the hud was shown,
	// and pospone the hiding operation if necessary
	if (self.minShowTime > 0.0 && showStarted) {
		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
		if (interv < self.minShowTime) {
			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self
                                                               selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
			return;
		}
	}
	// ... otherwise hide the HUD immediately
	[self hideUsingAnimation:useAnimation];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
	[self hide:[animated boolValue]];
}

#pragma mark - Timer callbacks

- (void)handleGraceTimer:(NSTimer *)theTimer {
	// Show the HUD only if the task is still running
	if (taskInProgress) {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
	[self hideUsingAnimation:useAnimation];
}

#pragma mark - View Hierrarchy

- (void)didMoveToSuperview {
	// We need to take care of rotation ourselfs if we're adding the HUD to a window
	if ([self.superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:NO];
	}
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
	if (animated && animationType == MBProgressHUDAnimationZoomIn) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
	} else if (animated && animationType == MBProgressHUDAnimationZoomOut) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
	}
	self.showStarted = [NSDate date];
	// Fade in
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		self.alpha = 1.0f;
		if (animationType == MBProgressHUDAnimationZoomIn || animationType == MBProgressHUDAnimationZoomOut) {
			self.transform = rotationTransform;
		}
		[UIView commitAnimations];
	}
	else {
		self.alpha = 1.0f;
	}
}

- (void)hideUsingAnimation:(BOOL)animated {
	// Fade out
	if (animated && showStarted) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
		// 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
		// in the done method
		if (animationType == MBProgressHUDAnimationZoomIn) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
		} else if (animationType == MBProgressHUDAnimationZoomOut) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
		}
        
		self.alpha = 0.02f;
		[UIView commitAnimations];
	}
	else {
		self.alpha = 0.0f;
		[self done];
	}
	self.showStarted = nil;
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
	[self done];
}

- (void)done {
	isFinished = YES;
	self.alpha = 0.0f;
	if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
		[delegate performSelector:@selector(hudWasHidden:) withObject:self];
	}
#if NS_BLOCKS_AVAILABLE
	if (self.completionBlock) {
		self.completionBlock();
		self.completionBlock = NULL;
	}
#endif
	if (removeFromSuperViewOnHide) {
		[self removeFromSuperview];
	}
}

#pragma mark - Threading

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	methodForExecution = method;
	targetForExecution = MB_RETAIN(target);
	objectForExecution = MB_RETAIN(object);
	// Launch execution in new thread
	self.taskInProgress = YES;
	[NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
	// Show HUD view
	[self show:animated];
}

#if NS_BLOCKS_AVAILABLE

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue {
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue	completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
	 completionBlock:(MBProgressHUDCompletionBlock)completion {
	self.taskInProgress = YES;
	self.completionBlock = completion;
	dispatch_async(queue, ^(void) {
        block();
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self cleanUp];
        });
    });
    [self show:animated];
}

#endif

- (void)launchExecution {
	@autoreleasepool {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		// Start executing the requested task
		[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
#pragma clang diagnostic pop
		// Task completed, update view in main thread (note: view operations should
		// be done only in the main thread)
		[self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
	}
}

- (void)cleanUp {
	taskInProgress = NO;
	self.indicator = nil;
#if !__has_feature(objc_arc)
	[targetForExecution release];
	[objectForExecution release];
#else
	targetForExecution = nil;
	objectForExecution = nil;
#endif
	[self hide:useAnimation];
}

#pragma mark - UI

- (void)setupLabels {
	label = [[UILabel alloc] initWithFrame:self.bounds];
	label.adjustsFontSizeToFitWidth = NO;
    //label.numberOfLines = 0;
	label.textAlignment = MBLabelAlignmentCenter;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = self.labelFont;
	label.text = self.labelText;
	[self addSubview:label];
	
	detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.adjustsFontSizeToFitWidth = NO;
	detailsLabel.textAlignment = MBLabelAlignmentCenter;
	detailsLabel.opaque = NO;
	detailsLabel.backgroundColor = [UIColor clearColor];
	detailsLabel.textColor = [UIColor whiteColor];
	detailsLabel.numberOfLines = 0;
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.text = self.detailsLabelText;
	[self addSubview:detailsLabel];
}

- (void)updateIndicators {
	
	BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
	BOOL isRoundIndicator = [indicator isKindOfClass:[MBRoundProgressView class]];
	
	if (mode == MBProgressHUDModeIndeterminate &&  !isActivityIndicator) {
		// Update to indeterminate indicator
		[indicator removeFromSuperview];
		self.indicator = MB_AUTORELEASE([[UIActivityIndicatorView alloc]
										 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
		[(UIActivityIndicatorView *)indicator startAnimating];
		[self addSubview:indicator];
	}
	else if (mode == MBProgressHUDModeDeterminateHorizontalBar) {
		// Update to bar determinate indicator
		[indicator removeFromSuperview];
        self.indicator = MB_AUTORELEASE([[MBBarProgressView alloc] init]);
		[self addSubview:indicator];
	}
	else if (mode == MBProgressHUDModeDeterminate || mode == MBProgressHUDModeAnnularDeterminate) {
		if (!isRoundIndicator) {
			// Update to determinante indicator
			[indicator removeFromSuperview];
			self.indicator = MB_AUTORELEASE([[MBRoundProgressView alloc] init]);
			[self addSubview:indicator];
		}
		if (mode == MBProgressHUDModeAnnularDeterminate) {
			[(MBRoundProgressView *)indicator setAnnular:YES];
		}
	}
	else if (mode == MBProgressHUDModeCustomView && customView != indicator) {
		// Update custom view indicator
		[indicator removeFromSuperview];
		self.indicator = customView;
		[self addSubview:indicator];
	} else if (mode == MBProgressHUDModeText) {
		[indicator removeFromSuperview];
		self.indicator = nil;
	}
}

#pragma mark - Layout

- (void)layoutSubviews {
	
	// Entirely cover the parent view
	UIView *parent = self.superview;
	if (parent) {
		self.frame = parent.bounds;
	}
	CGRect bounds = self.bounds;
	
	// Determine the total widt and height needed
	CGFloat maxWidth = bounds.size.width - 4 * margin;
	CGSize totalSize = CGSizeZero;
	
	CGRect indicatorF = indicator.bounds;
	indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
	totalSize.width = MAX(totalSize.width, indicatorF.size.width);
	totalSize.height += indicatorF.size.height;
	
	CGSize labelSize = [label.text sizeWithFont:label.font];
	labelSize.width = MIN(labelSize.width, maxWidth);
	totalSize.width = MAX(totalSize.width, labelSize.width);
	totalSize.height += labelSize.height;
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		totalSize.height += kPadding;
	}
    
	CGFloat remainingHeight = bounds.size.height - totalSize.height - kPadding - 4 * margin;
	CGSize maxSize = CGSizeMake(maxWidth, remainingHeight);
	CGSize detailsLabelSize = [detailsLabel.text sizeWithFont:detailsLabel.font
                                            constrainedToSize:maxSize lineBreakMode:detailsLabel.lineBreakMode];
	totalSize.width = MAX(totalSize.width, detailsLabelSize.width);
	totalSize.height += detailsLabelSize.height;
	if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
		totalSize.height += kPadding;
	}
	
	totalSize.width += 2 * margin;
	totalSize.height += 2 * margin;
	
	// Position elements
	CGFloat yPos = roundf(((bounds.size.height - totalSize.height) / 2)) + margin + yOffset;
	CGFloat xPos = xOffset;
	indicatorF.origin.y = yPos;
	indicatorF.origin.x = roundf((bounds.size.width - indicatorF.size.width) / 2) + xPos;
	indicator.frame = indicatorF;
	yPos += indicatorF.size.height;
	
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		yPos += kPadding;
	}
	CGRect labelF;
	labelF.origin.y = yPos;
	labelF.origin.x = roundf((bounds.size.width - labelSize.width) / 2) + xPos;
	labelF.size = labelSize;
	label.frame = labelF;
	yPos += labelF.size.height;
	
	if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
		yPos += kPadding;
	}
	CGRect detailsLabelF;
	detailsLabelF.origin.y = yPos;
	detailsLabelF.origin.x = roundf((bounds.size.width - detailsLabelSize.width) / 2) + xPos;
	detailsLabelF.size = detailsLabelSize;
	detailsLabel.frame = detailsLabelF;
	
	// Enforce minsize and quare rules
	if (square) {
		CGFloat max = MAX(totalSize.width, totalSize.height);
		if (max <= bounds.size.width - 2 * margin) {
			totalSize.width = max;
		}
		if (max <= bounds.size.height - 2 * margin) {
			totalSize.height = max;
		}
	}
	if (totalSize.width < minSize.width) {
		totalSize.width = minSize.width;
	}
	if (totalSize.height < minSize.height) {
		totalSize.height = minSize.height;
	}
	
	self.size = totalSize;
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    
	if (self.dimBackground) {
		//Gradient colours
		size_t gradLocationsNum = 2;
		CGFloat gradLocations[2] = {0.0f, 1.0f};
		CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
		CGColorSpaceRelease(colorSpace);
		//Gradient center
		CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		//Gradient radius
		float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
		//Gradient draw
		CGContextDrawRadialGradient (context, gradient, gradCenter,
									 0, gradCenter, gradRadius,
									 kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}
    
    // Set background rect color
    if (self.color) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
    } else {
        CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    }
    
	
	// Center HUD
	CGRect allRect = self.bounds;
	// Draw rounded HUD backgroud rect
	CGRect boxRect = CGRectMake(roundf((allRect.size.width - size.width) / 2) + self.xOffset,
								roundf((allRect.size.height - size.height) / 2) + self.yOffset, size.width, size.height);
	float radius = 10.0f;
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
	CGContextClosePath(context);
	CGContextFillPath(context);
    
	UIGraphicsPopContext();
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"mode", @"customView", @"labelText", @"labelFont",
			@"detailsLabelText", @"detailsLabelFont", @"progress", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateUIForKeypath:keyPath];
	}
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"mode"] || [keyPath isEqualToString:@"customView"]) {
		[self updateIndicators];
	} else if ([keyPath isEqualToString:@"labelText"]) {
		label.text = self.labelText;
	} else if ([keyPath isEqualToString:@"labelFont"]) {
		label.font = self.labelFont;
	} else if ([keyPath isEqualToString:@"detailsLabelText"]) {
		detailsLabel.text = self.detailsLabelText;
	} else if ([keyPath isEqualToString:@"detailsLabelFont"]) {
		detailsLabel.font = self.detailsLabelFont;
	} else if ([keyPath isEqualToString:@"progress"]) {
		if ([indicator respondsToSelector:@selector(setProgress:)]) {
			[(id)indicator setProgress:progress];
		}
		return;
	}
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else if ([superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; }
		else { radians = (CGFloat)M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; }
		else { radians = 0; }
	}
	rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}

@end


@implementation MBRoundProgressView

#pragma mark - Lifecycle

- (id)init {
	return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		_progress = 0.f;
		_annular = NO;
		_progressTintColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
		_backgroundTintColor = [[UIColor alloc] initWithWhite:1.f alpha:.1f];
		[self registerForKVO];
	}
	return self;
}

- (void)dealloc {
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[_progressTintColor release];
	[_backgroundTintColor release];
	[super dealloc];
#endif
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	
	CGRect allRect = self.bounds;
	CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_annular) {
		// Draw background
		CGFloat lineWidth = 5.f;
		UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
		processBackgroundPath.lineWidth = lineWidth;
		processBackgroundPath.lineCapStyle = kCGLineCapRound;
		CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		CGFloat radius = (self.bounds.size.width - lineWidth)/2;
		CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
		CGFloat endAngle = (2 * (float)M_PI) + startAngle;
		[processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[_backgroundTintColor set];
		[processBackgroundPath stroke];
		// Draw progress
		UIBezierPath *processPath = [UIBezierPath bezierPath];
		processPath.lineCapStyle = kCGLineCapRound;
		processPath.lineWidth = lineWidth;
		endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
		[processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[_progressTintColor set];
		[processPath stroke];
	} else {
		// Draw background
		[_progressTintColor setStroke];
		[_backgroundTintColor setFill];
		CGContextSetLineWidth(context, 2.0f);
		CGContextFillEllipseInRect(context, circleRect);
		CGContextStrokeEllipseInRect(context, circleRect);
		// Draw progress
		CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
		CGFloat radius = (allRect.size.width - 4) / 2;
		CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
		CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
		CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
		CGContextClosePath(context);
		CGContextFillPath(context);
	}
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"progressTintColor", @"backgroundTintColor", @"progress", @"annular", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setNeedsDisplay];
}

@end


@implementation MBBarProgressView

#pragma mark - Lifecycle

- (id)init {
	return [self initWithFrame:CGRectMake(.0f, .0f, 120.0f, 20.0f)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_progress = 0.f;
		_lineColor = [UIColor whiteColor];
		_progressColor = [UIColor whiteColor];
		_progressRemainingColor = [UIColor clearColor];
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		[self registerForKVO];
    }
    return self;
}

- (void)dealloc {
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[_lineColor release];
	[_progressColor release];
	[_progressRemainingColor release];
	[super dealloc];
#endif
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// setup properties
	CGContextSetLineWidth(context, 2);
	CGContextSetStrokeColorWithColor(context,[_lineColor CGColor]);
	CGContextSetFillColorWithColor(context, [_progressRemainingColor CGColor]);
	
	// draw line border
	float radius = (rect.size.height / 2) - 2;
	CGContextMoveToPoint(context, 2, rect.size.height/2);
	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
	CGContextFillPath(context);
	
	// draw progress background
	CGContextMoveToPoint(context, 2, rect.size.height/2);
	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
	CGContextStrokePath(context);
	
	// setup to draw progress color
	CGContextSetFillColorWithColor(context, [_progressColor CGColor]);
	radius = radius - 2;
	float amount = self.progress * rect.size.width;
	
	// if progress is in the middle area
	if (amount >= radius + 4 && amount <= (rect.size.width - radius - 4)) {
		// top
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, amount, 4);
		CGContextAddLineToPoint(context, amount, radius + 4);
		
		// bottom
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, amount, rect.size.height - 4);
		CGContextAddLineToPoint(context, amount, radius + 4);
		
		CGContextFillPath(context);
	}
	
	// progress is in the right arc
	else if (amount > radius + 4) {
		float x = amount - (rect.size.width - radius - 4);
		
		// top
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, rect.size.width - radius - 4, 4);
		float angle = -acos(x/radius);
		if (isnan(angle)) angle = 0;
		CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, M_PI, angle, 0);
		CGContextAddLineToPoint(context, amount, rect.size.height/2);
		
		// bottom
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, rect.size.width - radius - 4, rect.size.height - 4);
		angle = acos(x/radius);
		if (isnan(angle)) angle = 0;
		CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, -M_PI, angle, 1);
		CGContextAddLineToPoint(context, amount, rect.size.height/2);
		
		CGContextFillPath(context);
	}
	
	// progress is in the left arc
	else if (amount < radius + 4 && amount > 0) {
		// top
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
		
		// bottom
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
		
		CGContextFillPath(context);
	}
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"lineColor", @"progressRemainingColor", @"progressColor", @"progress", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setNeedsDisplay];
}

@end

