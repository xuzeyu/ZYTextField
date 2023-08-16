//
//  ViewController.m
//  Example
//
//  Created by XUZY on 2022/10/24.
//

#import "ViewController.h"
#import "ZYTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZYTextField *textField = [[ZYTextField alloc] init];
    textField.isResignFirstResponderAfterReturn = YES;
    textField.placeholder = @"请输入文字";
    textField.frame = CGRectMake(30, 100, 320, 50);
    [self.view addSubview:textField];
    textField.backgroundColor = [UIColor yellowColor];
    textField.isFloat = YES;
    textField.decimalPoint = 2;
    textField.maxNumber = [NSDecimalNumber decimalNumberWithString:@"15.5"];
    textField.minNumber = [NSDecimalNumber decimalNumberWithString:@"2"];
    NSLog(@"----%d", [self isPureFloat:@"10.11"]);
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string{

    NSScanner* scan = [NSScanner scannerWithString:string];

    float val;

    return[scan scanFloat:&val] && [scan isAtEnd];

}

@end
