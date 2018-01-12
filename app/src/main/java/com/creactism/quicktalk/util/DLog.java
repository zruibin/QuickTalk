package com.creactism.quicktalk.util;

import android.util.Log;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public final class DLog extends Object {

    private final  static String TAG = "QuickTalk";

    public static void debug (String msg) {
        Log.d(TAG, msg);
    }

    public static void info (String msg) {
        Log.i(TAG, msg);
    }

    public static void  warn (String msg) {
        Log.w(TAG, msg);
    }

    public static void error (String msg) {
        Log.e(TAG, msg);
    }
}
