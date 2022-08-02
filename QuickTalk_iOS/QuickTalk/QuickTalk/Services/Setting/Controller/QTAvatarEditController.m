//
//  QTAvatarEditController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAvatarEditController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface QTAvatarEditController ()

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) UIButton *changeButton;
@property(nonatomic, strong) UIButton *saveButton;

- (void)visitAlbum:(BOOL)isAlbum orCamera:(BOOL)isCamera;

@end

@implementation QTAvatarEditController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViews];
    [self.avatarView cra_setImage:[QTUserInfo sharedInstance].avatar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"头像编辑";
    CGFloat w = CGRectGetWidth(self.view.bounds);
    [self.view addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(w);
    }];
    [self.view addSubview:self.changeButton];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.avatarView.mas_bottom).offset(40);
        make.height.mas_equalTo(44);
    }];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.changeButton.mas_bottom).offset(20);
        make.height.equalTo(self.changeButton);
    }];
    self.saveButton.hidden = YES;
}

#pragma mark - Private

- (void)visitAlbum:(BOOL)isAlbum orCamera:(BOOL)isCamera
{
    
    //检测访问权限
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"应用程序没有访问摄像头的权限" message:@"你可以在\"设置>隐私\"开启访问权限"  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了"  style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }
    
    ALAuthorizationStatus authStatusAssetsLib = [ALAssetsLibrary authorizationStatus];
    if (authStatusAssetsLib == AVAuthorizationStatusRestricted || authStatusAssetsLib == AVAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"应用程序没有访问照片的权限" message:@"你可以在\"设置>隐私\"开启访问权限"  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了"  style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIImagePickerControllerSourceType sourceType;
    NSString *stringTitle;
    if (isAlbum == YES) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        stringTitle = @"相册";
    } else {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        stringTitle = @"摄像头";
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:sourceType]; //设置类型
        [controller setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
        controller.allowsEditing = YES; /*区域裁剪*/
        [controller setDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"打开失败" message:[NSString stringWithFormat:@"%@不可用", stringTitle]  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了"  style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog(@"Picker returned successfully. %@", info);
    UIImage *theImage = nil;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断获取类型(图片)
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        /*controller.allowsEditing = NO 则 UIImagePickerControllerOriginalImage*/
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        weakSelf.saveButton.hidden = NO;
        weakSelf.avatarView.image = theImage;
    }];
}

#pragma mark - Action

- (void)changeButtonAction
{
    __weak typeof(self) weakSelf = self;
    void(^handler)(NSInteger index) = ^(NSInteger index){
        if (index == 0) {
            [weakSelf visitAlbum:NO orCamera:YES];
        } else {
            [weakSelf visitAlbum:YES orCamera:NO];
        }
    };
    NSArray *items =
    @[MMItemMake(@"拍照", MMItemTypeNormal, handler),
      MMItemMake(@"相册", MMItemTypeNormal, handler)];
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"选取照片"
                                                          items:items];
    //    sheetView.attachedView = self.view;
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView show];
}

- (void)saveButtonAction
{
    UIImage *image = self.avatarView.image;
    
    [QTProgressHUD showHUD:self.view];
    
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTUserInfo requestChangeAvatar:userUUID avatarImage:image completionHandler:^(NSString *avatar, NSError *error) {
        if (avatar) {
            [QTProgressHUD showHUDSuccess];
            [QTUserInfo sharedInstance].avatar = avatar;
            if (self.onAvatarChangeHandler) {
                self.onAvatarChangeHandler();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];

}

#pragma mark - setter and getter

-(UIImageView *)avatarView
{
    if (_avatarView == nil) {
        _avatarView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView;
        });
    }
    return _avatarView;
}

- (UIButton *)changeButton
{
    if (_changeButton == nil) {
        _changeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"更换头像" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.layer.borderWidth = 0.5f;
            button.layer.borderColor = [[UIColor colorFromHexValue:0x999999] CGColor];
            button.layer.masksToBounds = YES;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _changeButton;
}

- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"保存" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.layer.borderWidth = 0.5f;
            button.layer.borderColor = [[UIColor colorFromHexValue:0x999999] CGColor];
            button.layer.masksToBounds = YES;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _saveButton;
}


@end
