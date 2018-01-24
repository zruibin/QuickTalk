package com.creactism.quicktalk.components;


import android.app.ProgressDialog;
import android.content.Context;

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
//    private static SVProgressHUD hud = null;


    public static void showHUD(Context context) {
//        hud = new SVProgressHUD(context);
//        hud.showSuccessWithStatus("");
//        hud.showWithStatus("加载中...");
        hud = new ProgressDialog(context);
        hud.setMessage("加载中...");
        hud.show();
    }

    public static void showHUDWithText(String text) {
        if (hud != null) {
//            hud.setText(text);
        }
    }

    public static void hide() {
        if (hud != null) {
            hud.dismiss();
            hud = null;
        }
    }

}
