package com.creactism.quicktalk.util;

import android.net.Uri;
import android.support.annotation.IdRes;

import com.creactism.quicktalk.R;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

final public class Tools {

    public static Uri getResoucesUri(@IdRes int resourcesString) {
        Uri uri = Uri.parse("res://com.creactism.quicktalk/" + resourcesString);
        return uri;
    }

}
