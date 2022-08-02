package com.creactism.quicktalk.components;


import android.app.ProgressDialog;
import android.content.Context;

import java.util.logging.Handler;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public final class QTProgressHUD {

    /*
    * + (void)showHUD:(UIView *)view;
+ (void)showHUDWithText:(NSString *)text;
+ (void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)timeInterval;
+ (void)showHUDSuccess;
+ (void)hide;

+ (void)showHUDText:(NSString *)text view:(UIView *)view;
    * */

    private static ProgressDialog hud = null;
    private static long DEFAULT_TIME = 0;

    public static void showHUD(Context context) {
//        hud = ProgressDialog.show(context, "", "加载中...", false, false);
        hud = new ProgressDialog(context);
        hud.setCancelable(true);// 设置是否可以通过点击Back键取消
        hud.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        hud.setCanceledOnTouchOutside(false);// 设置在点击Dialog外是否取消Dialog进度条
        hud.setMessage("加载中...");
        hud.show();
    }

    public static void showHUDSuccess() {
        showHUDWithText("加载成功");
    }

    public static void showHUDWithText(String text) {
        showHUDWithText(text, DEFAULT_TIME);
    }

    public static void showHUDWithText(String text, long timeInterval) {
        if (hud != null) {
            hud.setMessage(text);
            hide();
        }
    }

    public static void hide() {
        hide(DEFAULT_TIME);
    }

    public static void hide(long timeInterval) {
        if (hud != null) {
            new android.os.Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    hud.dismiss();
                    hud = null;
                }
            }, timeInterval);
        }
    }

}
