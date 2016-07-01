//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Catherine Washburn on 6/2/16.
//  Copyright © 2016 Catherine Washburn. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, weak) UIButton *currentButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation AwesomeFloatingToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 buttons
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *button = [[UIButton alloc] init];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = NO;
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            button.titleLabel.text = titleForThisLabel;
            button.backgroundColor = colorForThisLabel;
            button.titleLabel.textColor = [UIColor whiteColor];
            
            [buttonsArray addObject:button];
        }
        
        self.buttons = buttonsArray;
        
        for (UIButton *thisButton in self.buttons) {
            [self addSubview:thisButton];
        }
        
        // #1
        //self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        // #2
//        [self addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];

        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
}
    
    return self;
}

- (void) buttonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
        [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UIButton *)sender).titleLabel.text];
    }
    
}
//- (void) tapFired:(UITapGestureRecognizer *)recognizer {
//    if (recognizer.state == UIGestureRecognizerStateRecognized) { // #3
//        CGPoint location = [recognizer locationInView:self]; // #4
//        UIView *tappedView = [self hitTest:location withEvent:nil]; // #5
//        
//        if ([self.labels containsObject:tappedView]) { // #6
//            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
//                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
//            }
//        }
//    }
//}

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = recognizer.scale;
        
        NSLog(@"Pinch scale: %f", scale);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchWithScale:)]) {
            [self.delegate floatingToolbar:self didTryToPinchWithScale:scale];
        }
    }
}

- (void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        NSUInteger randomInteger = arc4random_uniform(4);
        for (int i = 0; i < self.colors.count; i++) {
            [self.buttons[i] setBackgroundColor:self.colors[randomInteger]];
            randomInteger++;
            if (randomInteger == self.colors.count) {
                randomInteger = 0;
            }
        }
        
//        NSMutableArray *mutableColors = [NSMutableArray arrayWithArray:self.colors];
//        NSUInteger count = [mutableColors count];
//           for(NSUInteger i = count - 1; i > 0; --i){
//                [mutableColors exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i+1))];
//           }
        
        // C method to generate a random number:
        // int randomInt = arc4random(4);
        // do some magic to rearrange the colors array
        
//        for (int i = 0 ; i < self.labels.count; i++) {
//            [self.labels[i] setBackgroundColor:mutableColors[i]];
//        }
    }
}

- (void) layoutSubviews {
    // set the frames for the 4 labels
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];
        
        CGFloat buttonHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat buttonWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
        
        // adjust labelX and labelY for each label
        if (currentButtonIndex < 2) {
            // 0 or 1, so on top
            buttonY = 0;
        } else {
            // 2 or 3, so on bottom
            buttonY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentButtonIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            buttonX = 0;
        } else {
            // 1 or 3, so on the right
            buttonX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    }
}

#pragma mark - Touch Handling

//- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    UIView *subview = [self hitTest:location withEvent:event];
//    
//    if ([subview isKindOfClass:[UILabel class]]) {
//        return (UILabel *)subview;
//    } else {
//        return nil;
//    }
//}



#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}

@end
