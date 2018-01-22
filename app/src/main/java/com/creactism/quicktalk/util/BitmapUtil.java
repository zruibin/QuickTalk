package com.creactism.quicktalk.util;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;

/**
 * Created by ruibin.chow on 22/01/2018.
 */

public class BitmapUtil {

    public static Bitmap roateBitmap(Bitmap bitmap, float degrees) {
        // 定义矩阵对象
        Matrix matrix = new Matrix();
        // 缩放原图
//        matrix.postScale(1f, 1f);
        // 参数为正则向右旋转
        matrix.postRotate(degrees);
        //bmp.getWidth(), 500分别表示重绘后的位图宽高
        Bitmap dstbmp = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(),
                matrix, true);
        return dstbmp;
    }

    public static Bitmap tintBitmap(Bitmap inBitmap , int tintColor) {
        if (inBitmap == null) {
            return null;
        }
        Bitmap outBitmap = Bitmap.createBitmap (inBitmap.getWidth(), inBitmap.getHeight() , inBitmap.getConfig());
        Canvas canvas = new Canvas(outBitmap);
        Paint paint = new Paint();
        paint.setColorFilter( new PorterDuffColorFilter(tintColor, PorterDuff.Mode.SRC_IN)) ;
        canvas.drawBitmap(inBitmap , 0, 0, paint) ;
        return outBitmap ;
    }
}
