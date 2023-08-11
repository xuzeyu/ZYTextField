//
//  ZYTextField.h
//  Example
//
//  Created by XUZY on 2023/8/1.
//

#import <UIKit/UIKit.h>

@class ZYTextField;

NS_ASSUME_NONNULL_BEGIN
@interface ZYTextField : UITextField
@property (nonatomic, strong, nullable) void(^textFieldBecomeFirstResponder)(ZYTextField *textField);///< 成为响应者
@property (nonatomic, strong, nullable) void(^textFieldResignFirstResponder)(ZYTextField *textField);///<  取消响应

@property (nonatomic, strong, nullable) void(^textFieldNotfiDidBeginEditing)(ZYTextField *textField);///< notification文本开始编辑Block
@property (nonatomic, strong, nullable) void(^textFieldNotfiDidEndEditing)(ZYTextField *textField);///< notification文本结束编辑Block
@property (nonatomic, strong, nullable) void(^textFieldNotfiDidChange)(ZYTextField *textField); ///< notification文本已经改变Block

@property (nonatomic, strong, nullable) BOOL(^textFieldShouldBeginEditing)(ZYTextField *textField);///< 是否可以开始编辑Block
@property (nonatomic, strong, nullable) void(^textFieldDidBeginEditing)(ZYTextField *textField);///< 文本开始编辑Block
@property (nonatomic, strong, nullable) BOOL(^textFieldShouldEndEditing)(ZYTextField *textField);///< 是否可以停止编辑Block
@property (nonatomic, strong, nullable) void(^textFieldDidEndEditing)(ZYTextField *textField); ///< 文本结束编辑Block
@property (nonatomic, strong, nullable) BOOL(^shouldChangeCharactersInRange)(ZYTextField *textField, NSRange range, NSString *replacementString);///< 文本改变Block
@property (nonatomic, strong, nullable) BOOL(^textFieldShouldClear)(ZYTextField *textField);///< 是否可以Cear Block
@property (nonatomic, strong, nullable) BOOL(^textFieldShouldReturn)(ZYTextField *textField);///< 是否可以点击Return Block
@property (nonatomic, strong, nullable) BOOL(^textFieldLengthDidMax)(ZYTextField *textField);///< 达到最大限制字符数Block

/**
 便利构造器.
 */
+ (instancetype)textField;

/**
 最大限制文本长度, 默认为无穷大, 即不限制, 如果被设为 0 也同样表示不限制字符数.
 */
@property (nonatomic, assign) NSUInteger maxLength;

/**
 圆角半径.
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 边框宽度.
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 边框颜色.
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/**
  是否禁止空格 默认为NO
 */
@property (nonatomic, assign) BOOL disableWhitespace;

/**
  禁止第一个字符输入空格 默认为YES
 */
@property (nonatomic, assign) BOOL disableFirstWhitespace;

/**
  是否点击Return按钮自动取消编辑状态 默认为NO
 */
@property (nonatomic, assign) BOOL isResignFirstResponderAfterReturn;

/**
  是否禁止0开头，默认为NO
 */
@property (nonatomic, assign) BOOL disableZeroPrefix;

/**
  是否为小数, 默认为NO,为YES的话会进制 . 开头
 */
@property (nonatomic, assign) BOOL isFloat;

/**
  是否设置小数点位数，isFloat为YES时，才生效, 默认为2
 */
@property (nonatomic, assign) NSInteger decimalPoint;

/**
 该属性返回一个经过处理的 `self.text` 的值, 去除了首位的空格和换行.
 */
@property (nonatomic, readonly) NSString *formatText;

@end

NS_ASSUME_NONNULL_END
