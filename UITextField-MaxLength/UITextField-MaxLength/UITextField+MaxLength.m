//
//  UITextField+MaxLength.m
//  UITextField-MaxLength
//
//  Created by sichenwang on 16/2/26.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "UITextField+MaxLength.h"
#import <objc/runtime.h>

@implementation UITextField (MaxLength)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self swizzledDealloc];
}

- (void)textDidChange:(NSNotification *)notification {
    if (self.text.length > self.maxLength && self.markedTextRange == nil && self.maxLength > 0) {
        self.text = [self.text substringToIndex:self.maxLength];
    }
}

- (void)setMaxLength:(NSInteger)maxLength {
    if (self.maxLength != maxLength && maxLength > 0) {
        objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
}

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, @selector(maxLength)) integerValue];
}


@end
