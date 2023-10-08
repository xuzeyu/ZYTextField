//
//  ZYTextField.m
//  Example
//
//  Created by XUZY on 2023/8/1.
//

#import "ZYTextField.h"

@interface ZYTextField () <UITextFieldDelegate>

@end

@implementation ZYTextField

#pragma mark - Override

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self layoutIfNeeded];
    }
    
    [self initialize];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self initialize];
    
    return self;
}

- (BOOL)becomeFirstResponder
{
    // 成为第一响应者时注册通知监听文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    BOOL become = [super becomeFirstResponder];

    if (self.textFieldBecomeFirstResponder) {
        __weak __typeof(self)weakSelf = self;
        self.textFieldBecomeFirstResponder(weakSelf);
    }
    return become;
}

- (BOOL)resignFirstResponder
{
    BOOL resign = [super resignFirstResponder];

    // 注销第一响应者时移除文本变化的通知, 以免影响其它的`UITextView`对象.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

    if (self.textFieldResignFirstResponder) {
        __weak __typeof(self)weakSelf = self;
        self.textFieldResignFirstResponder(weakSelf);
    }
    return resign;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Private

- (void)initialize
{
    _decimalPoint = 2;
    self.delegate = self;
    _disableFirstWhitespace = YES;
    
    if (_maxLength == 0 || _maxLength == NSNotFound) {
        _maxLength = NSUIntegerMax;
    }
    
    // 基本设定 (需判断是否在Storyboard中设置了值)
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:15.f];
    }
}

#pragma mark - Getter
/// 返回一个经过处理的 `self.text` 的值, 去除了首位的空格和换行.
- (NSString *)formatText
{
    return [[super text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去除首尾的空格和换行.
}

#pragma mark - Setter

- (void)setText:(NSString *)text
{
    [super setText:text];
    // 手动模拟触发通知
    NSNotification *notification = [NSNotification notificationWithName:UITextViewTextDidChangeNotification object:self];
    [self textDidChange:notification];
}

- (void)setMaxLength:(NSUInteger)maxLength
{
    _maxLength = fmax(0, maxLength);
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (!borderColor) return;
    
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

#pragma mark - NSNotification
- (void)textDidBeginEditing:(NSNotification *)notification
{
    __weak __typeof(self)weakSelf = self;
    !_textFieldNotfiDidBeginEditing ?: _textFieldNotfiDidBeginEditing(weakSelf);
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    __weak __typeof(self)weakSelf = self;
    !_textFieldNotfiDidEndEditing ?: _textFieldNotfiDidEndEditing(weakSelf);
}

- (void)textDidChange:(NSNotification *)notification
{
    __weak __typeof(self)weakSelf = self;
    // 通知回调的实例的不是当前实例的话直接返回
    if (notification.object != self) return;
    
    // 禁止第一个字符输入空格
    while (self.disableFirstWhitespace && [self.text hasPrefix:@" "]) {
        self.text = [self.text substringFromIndex:1];
    }
    
    if (self.disableWhitespace && [self.text containsString:@" "]) {
        self.text = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    // 只有当maxLength字段的值不为无穷大整型也不为0时才计算限制字符数.
    if (_maxLength != NSUIntegerMax && _maxLength != 0 && self.text.length > 0) {
        
        if (!self.markedTextRange && self.text.length > _maxLength) {
            
            !_textFieldLengthDidMax ?: _textFieldLengthDidMax(weakSelf); // 回调达到最大限制的Block.
            self.text = [self.text substringToIndex:_maxLength]; // 截取最大限制字符数.
            [self.undoManager removeAllActions]; // 达到最大字符数后清空所有 undoaction, 以免 undo 操作造成crash.
        }
    }
    
    if (self.text.length > 0) {
        // NSOrderedAscending = -1L, NSOrderedSame,  NSOrderedDescending
        if (self.maxNumber && [self.maxNumber compare:[NSDecimalNumber decimalNumberWithString:self.text]] == NSOrderedAscending) {
            self.text = self.maxNumber.stringValue;
        }
        
        if (self.minNumber && [self.minNumber compare:[NSDecimalNumber decimalNumberWithString:self.text]] == NSOrderedDescending) {
            self.text = self.minNumber.stringValue;
        }
    }
    
    // 回调文本改变的Block
    !_textFieldNotfiDidChange ?: _textFieldNotfiDidChange(weakSelf);
}



#pragma mark - Public

+ (instancetype)textField
{
    return [[self alloc] init];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(ZYTextField *)textField {
    if (self.textFieldShouldBeginEditing) {
        return self.textFieldShouldBeginEditing(textField);
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(ZYTextField *)textField {
    if (self.textFieldDidBeginEditing) {
        return self.textFieldDidBeginEditing(textField);
    }
}

- (BOOL)textFieldShouldEndEditing:(ZYTextField *)textField {
    if (self.textFieldShouldEndEditing) {
        return self.textFieldShouldEndEditing(textField);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(ZYTextField *)textField {
    if (self.textFieldDidEndEditing) {
        return self.textFieldDidEndEditing(textField);
    }
}

- (BOOL)textField:(ZYTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 禁止第一个字符输入空格
    if (self.disableFirstWhitespace && [text hasPrefix:@" "]) {
        return NO;
    }
    
    if (self.disableWhitespace && [self.text containsString:@" "]) {
        return NO;
    }
    
    if (self.disableZeroPrefix && [string hasPrefix:@"0"] && range.location == 0) {
        return NO;
    }
    
    if (self.isFloat) {
        if ([self isPureFloat:text]) {
            if([string hasPrefix:@"."]) {
                if(range.location == 0) {
                    return NO;
                }else {
                    NSRange dianRange = [textField.text rangeOfString:@"."];
                    if (dianRange.location != NSNotFound) {
                        if (NSLocationInRange(dianRange.location, range)) {
                            return YES;
                        }else {
                            return NO;
                        }
                    }
                }
            }
            
//            if([textField.text hasPrefix:@"0"]) {
//                if(![string isEqualToString:@"."] && range.location == 1 && ![string isEqualToString:@""]) {
//                    return NO;
//                }
//            }
                        
            if (textField.text.length > 0 && [string isEqualToString:@"0"] && range.location == 0) {
                return NO;
            }
            
            if([textField.text hasPrefix:@"0"] && ![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
                NSString *tmpText = textField.text;
                while ([tmpText hasPrefix:@"0"] && ![tmpText hasPrefix:@"0."] && tmpText.length > 0) {
                    tmpText = [tmpText substringFromIndex:1];
                }
                textField.text = tmpText;
            }
            
            NSRange dianRange = [text rangeOfString:@"."];
            if (dianRange.location != NSNotFound) {
                return  text.length - NSMaxRange(dianRange) <= self.decimalPoint;
            }
        }else {
            if (![string isEqualToString:@""]) {
                return NO;
            }
        }
    }
    
    if (self.shouldChangePredicateFormat.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", self.shouldChangePredicateFormat];
        BOOL pResult = [predicate evaluateWithObject:text];
        if (!pResult) return NO;
    }
    
    if (self.shouldChangeCharactersInRange) {
        return self.shouldChangeCharactersInRange(textField, range, string);
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(ZYTextField *)textField {
    if (self.textFieldShouldClear) {
        return self.textFieldShouldClear(textField);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(ZYTextField *)textField {
    if (self.isResignFirstResponderAfterReturn) {
        [self resignFirstResponder];
    }
    if (self.textFieldShouldReturn) {
        return self.textFieldShouldReturn(textField);
    }
    return YES;
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end

