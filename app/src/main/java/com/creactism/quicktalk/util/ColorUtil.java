package com.creactism.quicktalk.util;

import android.content.Context;
import android.graphics.Color;

import java.util.regex.Pattern;

/**
 * Created by ruibin.chow on 19/01/2018.
 */

public final class ColorUtil {

    /**获取资源中的颜色*/
    public static int getResourcesColor(Context ctx, int colorId) {

        int ret = 0x00ffffff;
        try {
            ret = ctx.getResources().getColor(colorId);
        } catch (Exception e) {
        }

        return ret;
    }

    /**将十六进制颜色代码转换为 int*/
    public static int hexToColor(String color) {
        return Color.parseColor(color);
    }

    /**修改颜色透明度*/
    public static int changeAlpha(int color, int alpha) {
        int red = Color.red(color);
        int green = Color.green(color);
        int blue = Color.blue(color);

        return Color.argb(alpha, red, green, blue);
    }

    /**将十六进制颜色代码转换为带alpha的int, alpha: 0.0~1.0*/
    public static int hexToAlphaColor(String hexColor, double alpha) {
        int value = new Double(alpha * 255).intValue();
        int color = hexToColor(hexColor);
        color = changeAlpha(color, value);
        return color;
    }
}
