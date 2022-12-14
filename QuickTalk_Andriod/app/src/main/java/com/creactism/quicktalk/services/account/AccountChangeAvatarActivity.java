package com.creactism.quicktalk.services.account;

import android.Manifest;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.FileProvider;
import android.support.v7.app.AlertDialog;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.services.account.model.AccountModel;
import com.creactism.quicktalk.services.user.model.UserModel;
import com.creactism.quicktalk.util.BitmapUtil;
import com.creactism.quicktalk.util.ColorUtil;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.creactism.quicktalk.util.DrawableUtil;
import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.GenericDraweeHierarchy;
import com.facebook.drawee.view.SimpleDraweeView;

import java.io.File;
import java.io.FileNotFoundException;

/**
 * Created by ruibin.chow on 18/01/2018.
 */

public class AccountChangeAvatarActivity extends BaseActivity {

    private SimpleDraweeView imageView;
    private Button changeButton;
    private Button saveButton;

    private final int PHOTO_REQUEST_GALLERY = 0; //相册
    private final int TAKE_PHOTO_REQUEST_CODE = 1; //拍照
    private final int PHOTO_REQUEST_CUT = 2; //裁切
    private Uri imageUri;
    private Bitmap bitmap; //将要上传至服务端的Bitmap

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("修改头像");
        this.navigationBar.setDefaultBackAction(this);
//        this.navigationBar.backItem.setImageDrawable(DrawableUtil.tintDrawable(
//                DrawableUtil.getDrawableFromResources(this, R.drawable.cancel), Color.WHITE));
//        this.navigationBar.rightItem.setText("确定");
//        this.navigationBar.rightItem.setTextColor(ColorUtil.getColorStateList(Color.YELLOW, Color.RED, 0, Color.GREEN));
//        this.navigationBar.rightItem.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                DLog.debug("rightItem onClick....");
//                navigationBar.rightItem.setEnabled(false);
//            }
//        });

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);
        LinearLayout lineLayout = new LinearLayout(this);
        lineLayout.setOrientation(LinearLayout.VERTICAL);
        lineLayout.setLayoutParams(params);
        lineLayout.setGravity(Gravity.TOP);
        this.initViews(lineLayout);
        setContentView(lineLayout);
        runtimePermissions();

        if (UserInfo.sharedInstance().getAvatar() != null) {
            this.imageView.setImageURI(Uri.parse(UserInfo.sharedInstance().getAvatar()));
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (this.imageUri != null) {
            DLog.info("imageUri: " + this.imageUri.getPath());
            new Handler().post(new Runnable() {
                @Override
                public void run() {
                    File file = new File(imageUri.getPath());
                    if (file.exists() && file.isFile()) file.delete();
                }
            });
        }
    }

    private void initViews(LinearLayout linearLayout) {

        this.imageView = new SimpleDraweeView(this);
        this.imageView.setBackgroundColor(Color.GRAY);
        int height = this.getResources().getDisplayMetrics().widthPixels;
        LinearLayout.LayoutParams imageViewParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                height);
        this.imageView.setLayoutParams(imageViewParams);
        linearLayout.addView(this.imageView);

        GenericDraweeHierarchy hierarchy = this.imageView.getHierarchy();
        hierarchy.setPlaceholderImage(R.mipmap.avatar_default, ScalingUtils.ScaleType.CENTER_CROP);
        hierarchy.setFailureImage(R.mipmap.avatar_default, ScalingUtils.ScaleType.CENTER_CROP);
        hierarchy.setActualImageScaleType(ScalingUtils.ScaleType.CENTER_CROP);
        this.imageView.setHierarchy(hierarchy);

        this.changeButton = new Button(this);
        this.changeButton.setText("更换头像");
//        this.changeButton.setBackground(DrawableUtil.getRoundRectRippleDrawable(10));
        this.changeButton.setBackground(DrawableUtil.getRippleDrawable(DrawableUtil.getBorderDrawable(DensityUtil.dip2px(4),
                Color.WHITE, DensityUtil.dip2px(1), Color.GRAY)));
        this.changeButton.setTextColor(ColorUtil.getColorStateList(Color.BLACK, Color.RED, 0, 0));
        this.changeButton.setStateListAnimator(null);//去掉阴影效果
        LinearLayout.LayoutParams changeBtnparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                80);
        changeBtnparams.setMargins(20, 40, 20, 0);
        changeBtnparams.gravity = Gravity.CENTER_HORIZONTAL;
        this.changeButton.setLayoutParams(changeBtnparams);
        linearLayout.addView(this.changeButton);

        this.saveButton = new Button(this);
        this.saveButton.setText("保存");
        this.saveButton.setBackgroundColor(Color.WHITE);
//        this.saveButton.setBackground(DrawableUtil.getRoundRectRippleDrawable(10));
        this.saveButton.setBackground(DrawableUtil.getRippleDrawable(DrawableUtil.getBorderDrawable(DensityUtil.dip2px(4),
                Color.WHITE, DensityUtil.dip2px(1), Color.GRAY)));
        this.saveButton.setTextColor(ColorUtil.getColorStateList(Color.BLACK, Color.RED, 0, 0));
        this.saveButton.setStateListAnimator(null);
        this.saveButton.setVisibility(View.GONE);
        LinearLayout.LayoutParams saveBtnParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                80);
        saveBtnParams.setMargins(20, 20, 20, 0);
        saveBtnParams.gravity = Gravity.CENTER_HORIZONTAL;
        this.saveButton.setLayoutParams(saveBtnParams);
        linearLayout.addView(saveButton);

        this.changeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder builder = new AlertDialog.Builder(AccountChangeAvatarActivity.this);
                builder.setTitle("更改头像");
                String[] items = {"选择本地照片","拍照"};
                builder.setNegativeButton("取消",null);
                builder.setItems(items, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int which) {
                        switch (which){
                            case PHOTO_REQUEST_GALLERY://选择本地照片
                                choicePicFromAlbum();
                                break;
                            case TAKE_PHOTO_REQUEST_CODE://拍照
                                takePhotos();
                                break;
                        }
                    }
                });
                builder.show();// 打开本地相册
            }
        });
        this.saveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                saveAction();
            }
        });
    }

    /**
     * 打开相机拍照
     */
    private void takePhotos() {
        String [] permissions  = {Manifest.permission.WRITE_EXTERNAL_STORAGE};
        if(Build.VERSION.SDK_INT >= 23){
            int check = ContextCompat.checkSelfPermission(this,permissions[0]);
            if(check != PackageManager.PERMISSION_GRANTED){
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},1);
            }
        }

        Intent openCameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        File file = new File(Environment.getExternalStorageDirectory(),"image.jpg");

        if(Build.VERSION.SDK_INT >= 24){
            openCameraIntent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            imageUri = FileProvider.getUriForFile(AccountChangeAvatarActivity.this,"com.creactism.quicktalk.fileProvider",file);
        }else {
            imageUri = Uri.fromFile(getImageStoragePath(this));
        }
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        //指定照片存储路径
        intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
        startActivityForResult(intent,TAKE_PHOTO_REQUEST_CODE);
    }

    /**
     * 打开相册选择图片
     */
    private void choicePicFromAlbum() {
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*");
        intent.putExtra("crop", "true");
        intent.putExtra("aspectX", 1);
        intent.putExtra("aspectY", 1);
        intent.putExtra("outputX", 1000);
        intent.putExtra("outputY", 1000);
        intent.putExtra("scale", true);
        intent.putExtra("return-data", false);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
        intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());
        intent.putExtra("noFaceDetection", true);
        startActivityForResult(intent, PHOTO_REQUEST_GALLERY);
    }

    /**
     * 设置图片保存路径
     * @return
     */
    private File getImageStoragePath(Context context){
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)){
            File file = new File(context.getExternalFilesDir(Environment.DIRECTORY_PICTURES), "temp.jpg");
            return file;
        }
        return null;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == TAKE_PHOTO_REQUEST_CODE){ //拍照
            if (imageUri != null){
                startPhotoZoom(imageUri, false);
            }
        } else if (requestCode == PHOTO_REQUEST_GALLERY){ //相册
            if (data != null) {
                imageUri = data.getData();
                startPhotoZoom(imageUri, true);
            }
        } else if (requestCode == PHOTO_REQUEST_CUT){ //裁剪
            if (imageUri != null) {
                Bitmap bitmap = decodeUriBitmap(imageUri);
                imageView.setImageBitmap(bitmap);
                this.bitmap = bitmap;
                this.saveButton.setVisibility(View.VISIBLE);
            }
        }
    }

    private Bitmap decodeUriBitmap(Uri uri) {
        Bitmap bitmap = null;
        try {
            bitmap = BitmapFactory.decodeStream(getContentResolver().openInputStream(uri));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        }
        return bitmap;
    }

    /**
     * 调用系统裁剪
     *
     * @param uri
     * @param generateOutputUrl 是否生成输入路径
     */
    public void startPhotoZoom(Uri uri, boolean generateOutputUrl) {

        Uri tempUri = null;
        if (generateOutputUrl) {
            tempUri = Uri.fromFile(getImageStoragePath(this));
        } else {
            tempUri = uri;
        }
        imageUri = tempUri;

        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(uri, "image/*");
        // crop为true是设置在开启的intent中设置显示的view可以剪裁
        intent.putExtra("crop", "true");
        intent.putExtra("scale", true);
        // aspectX aspectY 是宽高的比例
        intent.putExtra("aspectX", 1);
        intent.putExtra("aspectY", 1);

        // outputX,outputY 是剪裁图片的宽高
        intent.putExtra("outputX", 1000);
        intent.putExtra("outputY", 1000);

        //设置了true的话直接返回bitmap，可能会很占内存
        intent.putExtra("return-data", false);
        //设置输出的格式
        intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());
        //设置输出的地址
        intent.putExtra(MediaStore.EXTRA_OUTPUT, tempUri);
        //不启用人脸识别
        intent.putExtra("noFaceDetection", true);
        startActivityForResult(intent, PHOTO_REQUEST_CUT);
    }

    //运行时权限，所以就需要在用的时候去重新请求系统权限并得到用户的允许授权。
    //来自http://blog.csdn.net/qxs965266509/article/details/50606385
    private void runtimePermissions() {
        int REQUEST_EXTERNAL_STORAGE = 1;
        String[] PERMISSIONS_STORAGE = {
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        };
        int permission = ActivityCompat.checkSelfPermission(AccountChangeAvatarActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE);

        if (permission != PackageManager.PERMISSION_GRANTED) {
            // We don't have permission so prompt the user
            ActivityCompat.requestPermissions(
                    AccountChangeAvatarActivity.this,
                    PERMISSIONS_STORAGE,
                    REQUEST_EXTERNAL_STORAGE
            );
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

        } else {
            // 没有获取 到权限，从新请求，或者关闭app
            QTToast.makeText(this, "需要存储权限");
        }
    }

    private void saveAction() {
        //上传服务端
        QTProgressHUD.showHUD(this);
        String userUUID = UserInfo.sharedInstance().getUuid();
        String upFilePath = BitmapUtil.compressBitmap(this.bitmap, 98, Bitmap.CompressFormat.JPEG, this.imageUri.getPath());
        if (upFilePath == null) {
            QTProgressHUD.hide();
            QTToast.makeText(this, "压缩图片失败");
            return;
        }
        AccountModel.requestChangeAvatar(userUUID, upFilePath, new AccountModel.CompleteHandler() {
            @Override
            public void completeHanlder(String avatar, Error error) {
                super.completeHanlder(avatar, error);
                QTProgressHUD.hide();
                if (error == null) {
                    QTToast.makeText(AccountChangeAvatarActivity.this, "更改头像成功");
                    finish();
                } else {
                    QTToast.makeText(AccountChangeAvatarActivity.this, error.getMessage());
                }
            }
        });
    }
}
