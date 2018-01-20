package com.creactism.quicktalk;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.WindowManager;

import com.creactism.quicktalk.util.DLog;

import java.util.List;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class BaseActivity extends AppCompatActivity {

    public boolean wasBackground= false;    //声明一个布尔变量,记录当前的活动背景

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS,
                    WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        }

//        DLog.debug("BaseActivity onCreacte...");
        this.getWindow().setBackgroundDrawable(this.getResources().getDrawable(R.drawable.bgColor));
    }

    @Override
    protected void onStart() {
        super.onStart();
//        DLog.debug("BaseActivity onStart...");
    }

    @Override
    protected void onResume() {
        super.onResume();
//        DLog.debug("BaseActivity onResume...");
        if(wasBackground){//
            DLog.debug("从后台回到前台");
        }
        wasBackground= false;
    }

    @Override
    protected void onPause() {
        super.onPause();
//        DLog.debug("BaseActivity onPause...");
        if(isApplicationBroughtToBackground()) {
            wasBackground= true;
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
//        DLog.debug("BaseActivity onStop...");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
//        DLog.debug("BaseActivity onDestroy...");
    }


    private boolean isApplicationBroughtToBackground() {
        ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningTaskInfo> tasks = am.getRunningTasks(1);
        if (!tasks.isEmpty()) {
            ComponentName topActivity = tasks.get(0).topActivity;
            if (!topActivity.getPackageName().equals(getPackageName())) {
                return true;
            }
        }
        return false;
    }
}
