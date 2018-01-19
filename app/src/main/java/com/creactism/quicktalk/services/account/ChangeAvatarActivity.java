package com.creactism.quicktalk.services.account;

import android.Manifest;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.FileProvider;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.Toolbar;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import java.io.File;
import java.io.FileNotFoundException;

/**
 * Created by ruibin.chow on 18/01/2018.
 */

public class ChangeAvatarActivity extends BaseActivity {

    private ImageView imageView;
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

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS,
                    WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        }

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);
        LinearLayout lineLayout = new LinearLayout(this);
        lineLayout.setOrientation(LinearLayout.VERTICAL);
        lineLayout.setLayoutParams(params);
        lineLayout.setGravity(Gravity.TOP);
        this.initViews(lineLayout);
        setContentView(lineLayout);
    }

    private void initViews(LinearLayout linearLayout) {
        final Toolbar toolbar = new Toolbar(this);
        toolbar.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT));
        toolbar.setBackgroundColor(Color.parseColor("#38383C"));
        TypedValue typedValue = new TypedValue();
        this.getTheme().resolveAttribute(R.attr.actionBarSize, typedValue, true);
        toolbar.setMinimumHeight(44);
        toolbar.setPopupTheme(R.style.ThemeOverlay_AppCompat_Light);
        linearLayout.addView(toolbar);


        this.imageView = new ImageView(this);
        this.imageView.setBackgroundColor(Color.GRAY);
        int height = this.getResources().getDisplayMetrics().widthPixels;
        LinearLayout.LayoutParams imageViewParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                height);
        this.imageView.setLayoutParams(imageViewParams);
        linearLayout.addView(this.imageView);

        this.changeButton = new Button(this);
        this.changeButton.setText("更换头像");
        this.changeButton.setBackgroundColor(Color.GRAY);
        this.changeButton.setBackground(this.getResources().getDrawable(R.drawable.ripple_bg, null));
        this.changeButton.setStateListAnimator(null);//去掉阴影效果
        LinearLayout.LayoutParams changeBtnparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                80);
        changeBtnparams.setMargins(20, 20, 20, 0);
        changeBtnparams.gravity = Gravity.CENTER_HORIZONTAL;
        this.changeButton.setLayoutParams(changeBtnparams);
        linearLayout.addView(this.changeButton);

        this.saveButton = new Button(this);
        this.saveButton.setText("保存");
        this.saveButton.setBackgroundColor(Color.WHITE);
        this.saveButton.setBackground(this.getResources().getDrawable(R.drawable.ripple_bg, null));
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
                AlertDialog.Builder builder = new AlertDialog.Builder(ChangeAvatarActivity.this);
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
            imageUri = FileProvider.getUriForFile(ChangeAvatarActivity.this,"com.creactism.quicktalk.fileProvider",file);

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

    private void saveAction() {
        //上传服务端
    }
}
