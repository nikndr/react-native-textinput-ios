//
//  RNTextField.m
//  RevenueWell
//
//  Created by Nikandr Marhal on 12.10.2020.
//

#import <Foundation/Foundation.h>
#import <React/RCTFont.h>
#import "RNTextField.h"

@implementation RNTextFieldManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString)
RCT_EXPORT_VIEW_PROPERTY(maxLength, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(text, NSString)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEndEditing, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(returnKeyType, UIReturnKeyType)
RCT_CUSTOM_VIEW_PROPERTY(placeholderTextColor, UIColor, RNTextField)
{
    [view setValue: [RCTConvert UIColor:json] forKeyPath: @"_placeholderLabel.textColor"];
}
RCT_CUSTOM_VIEW_PROPERTY(textAlign, NSTextAlignment, RNTextField)
{
    [view setTextAlignment:[RCTConvert NSTextAlignment:json]];
}
RCT_EXPORT_VIEW_PROPERTY(textColor, UIColor)
RCT_CUSTOM_VIEW_PROPERTY(fontSize, NSNumber, RNTextField)
{
    view.font = [RCTFont updateFont:view.font withSize:json ?: @(defaultView.font.pointSize)];
}

- (UIView *)view
{
    RNTextField *textField = [[RNTextField alloc] init];
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}

- (void)textFieldDidChanged:(RNTextField *)textField {
    UITextRange *range = textField.markedTextRange;
    NSUInteger maxLength = textField.maxLength.unsignedIntegerValue;

    if (!range && maxLength) {
        NSString *str = textField.text;
        if (str.length > maxLength) {
            str = [str substringToIndex:maxLength];
            textField.text = str;
        }
    }
    if (textField.onChange) {
        textField.onChange(@{@"text": textField.attributedText.string});
    }
}

- (void)textFieldDidEndEditing:(RNTextField *)textField {
    if (textField.onEndEditing) {
        textField.onEndEditing(@{@"text": textField.attributedText.string});
    }
}

@end
