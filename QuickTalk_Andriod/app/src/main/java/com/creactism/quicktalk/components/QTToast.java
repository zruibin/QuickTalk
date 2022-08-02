package com.creactism.quicktalk.components;

import android.content.Context;
import android.widget.Toast;

/**
 * Created by ruibin.chow on 25/01/2018.
 */

public class QTToast {

    private static int DEFAULT_DURATION = Toast.LENGTH_SHORT;

    public static void makeText(Context context, String text) {
        Toast.makeText(context, text, DEFAULT_DURATION).show();
    }

    public static void makeText(Context context, String text, int duration) {
        Toast.makeText(context, text, duration).show();
    }

}
