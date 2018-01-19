package com.creactism.quicktalk.util;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.RippleDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.StateListDrawable;
import android.graphics.drawable.shapes.RectShape;
import android.graphics.drawable.shapes.RoundRectShape;

/**
 * Created by ruibin.chow on 19/01/2018.
 */

public final class DrawableUtil {

    public static RippleDrawable getRippleDrawable(Drawable drawable, int rippleColor) {
        RippleDrawable rippleDrawable = new RippleDrawable(ColorStateList.valueOf(rippleColor), drawable, null);
        return rippleDrawable;
    }

    public static Drawable getRectRippleDrawable() {
        return getRectRippleDrawable(Color.WHITE);
    }

    public static Drawable getRectRippleDrawable(int tintColor) {
        return getRectRippleDrawable(tintColor, Color.GRAY);
    }

    public static Drawable getRectRippleDrawable(int tintColor, int rippleColor) {
        ShapeDrawable rectDrawable = new ShapeDrawable(new RectShape());
        rectDrawable.getPaint().setColor(tintColor);
        rectDrawable.getPaint().setStyle(Paint.Style.FILL); //填充
        return getRippleDrawable(rectDrawable, rippleColor);
    }

    public static Drawable getRoundRectRippleDrawable(int cornerRadius) {
        return getRoundRectRippleDrawable(Color.WHITE, Color.GRAY, cornerRadius);
    }

    public static Drawable getRoundRectRippleDrawable(int tintColor, int cornerRadius) {
        return getRoundRectRippleDrawable(tintColor, Color.GRAY, cornerRadius);
    }

    public static Drawable getRoundRectRippleDrawable(int tintColor, int rippleColor, int cornerRadius) {
        // 外部矩形弧度
        float[] outerR = new float[] { cornerRadius, cornerRadius, cornerRadius, cornerRadius,
                cornerRadius, cornerRadius, cornerRadius, cornerRadius };
        // 内部矩形与外部矩形的距离
        RectF inset = new RectF(100, 100, 50, 50);
        // 内部矩形弧度
        float[] innerRadii = new float[] { 20, 20, 20, 20, 20, 20, 20, 20 };
        RoundRectShape roundRectShape = new RoundRectShape(outerR, inset, null); //无内矩形

        ShapeDrawable rectDrawable = new ShapeDrawable(roundRectShape);
        rectDrawable.getPaint().setColor(tintColor);
        rectDrawable.getPaint().setStyle(Paint.Style.FILL); //填充
        return getRippleDrawable(rectDrawable, rippleColor);
    }

    public static Drawable getRectDrawable() {
        return getRectDrawable(Color.WHITE);
    }

    public static Drawable getRectDrawable(int tintColor) {
        ShapeDrawable rectDrawable = new ShapeDrawable(new RectShape());
        rectDrawable.getPaint().setColor(tintColor);
        rectDrawable.getPaint().setStyle(Paint.Style.FILL); //填充
        return rectDrawable;
    }

    public static Drawable getRoundRectDrawable(int cornerRadius) {
        return getRoundRectDrawable(Color.WHITE, cornerRadius);
    }

    public static Drawable getRoundRectDrawable(int tintColor, int cornerRadius) {
        // 外部矩形弧度
        float[] outerR = new float[] { cornerRadius, cornerRadius, cornerRadius, cornerRadius,
                cornerRadius, cornerRadius, cornerRadius, cornerRadius };
        // 内部矩形与外部矩形的距离
        RectF inset = new RectF(100, 100, 50, 50);
        // 内部矩形弧度
        float[] innerRadii = new float[] { 20, 20, 20, 20, 20, 20, 20, 20 };
        RoundRectShape roundRectShape = new RoundRectShape(outerR, inset, null); //无内矩形

        ShapeDrawable roundRectDrawable = new ShapeDrawable(roundRectShape);
        roundRectDrawable.getPaint().setColor(tintColor);
        roundRectDrawable.getPaint().setStyle(Paint.Style.FILL); //填充
        return roundRectDrawable;
    }

    /** 设置不同状态时其文字颜色。 */
    public static ColorStateList getColorStateList(int normal, int pressed, int focused, int unable) {
        int[] colors = new int[] { pressed, focused, normal, focused, unable, normal };
        int[][] states = new int[6][];
        states[0] = new int[] { android.R.attr.state_pressed, android.R.attr.state_enabled };
        states[1] = new int[] { android.R.attr.state_enabled, android.R.attr.state_focused };
        states[2] = new int[] { android.R.attr.state_enabled };
        states[3] = new int[] { android.R.attr.state_focused };
        states[4] = new int[] { android.R.attr.state_window_focused };
        states[5] = new int[] {};
        ColorStateList colorList = new ColorStateList(states, colors);
        return colorList;
    }

    /** 设置Selector。 */
    public static StateListDrawable getSelector(Context context,
                                                int idNormal, int idPressed, int idFocused, int idUnable) {
        StateListDrawable bg = new StateListDrawable();
        Drawable normal = (idNormal == -1) ? null : context.getResources().getDrawable(idNormal);
        Drawable pressed = idPressed == -1 ? null : context.getResources().getDrawable(idPressed);
        Drawable focused = idFocused == -1 ? null : context.getResources().getDrawable(idFocused);
        Drawable unable = idUnable == -1 ? null : context.getResources().getDrawable(idUnable);
        // View.PRESSED_ENABLED_STATE_SET
        bg.addState(new int[] { android.R.attr.state_pressed, android.R.attr.state_enabled }, pressed);
        // View.ENABLED_FOCUSED_STATE_SET
        bg.addState(new int[] { android.R.attr.state_enabled, android.R.attr.state_focused }, focused);
        // View.ENABLED_STATE_SET
        bg.addState(new int[] { android.R.attr.state_enabled }, normal);
        // View.FOCUSED_STATE_SET
        bg.addState(new int[] { android.R.attr.state_focused }, focused);
        // View.WINDOW_FOCUSED_STATE_SET
        bg.addState(new int[] { android.R.attr.state_window_focused }, unable);
        // View.EMPTY_STATE_SET
        bg.addState(new int[] {}, normal);
        return bg;
    }
}
