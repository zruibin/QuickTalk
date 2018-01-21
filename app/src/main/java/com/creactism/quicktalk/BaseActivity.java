package com.creactism.quicktalk;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.LinearLayout;

import com.creactism.quicktalk.components.NavigationBar;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.creactism.quicktalk.util.DrawableUtil;

import java.util.List;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class BaseActivity extends AppCompatActivity {

    public boolean wasBackground= false;    //声明一个布尔变量,记录当前的活动背景
    private LinearLayout rootLayout;
    protected Toolbar statusBar;
    protected NavigationBar navigationBar;
    protected String title;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS,
                    WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        }

//        DLog.debug("BaseActivity onCreacte...");
//        this.getWindow().setBackgroundDrawable(this.getResources().getDrawable(R.drawable.bgColor));
        super.setContentView(R.layout.activity_base);
        initNavigationBar();
        this.setTitle("base...");
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

    private void initNavigationBar() {
        statusBar = (Toolbar) findViewById(R.id.activity_base_toolbar);
        navigationBar = (NavigationBar)findViewById(R.id.activity_base_navigationbar);

        navigationBar.setBackgroundColor(getResources().getColor(R.color.QuickTalk_NAVBAR_BG_COLOR, null));
        Drawable drawable = DrawableUtil.getRoundRectRippleDrawable(
                getResources().getColor(R.color.QuickTalk_NAVBAR_BG_COLOR, null), 10);
        navigationBar.setItemBackground(drawable);
    }

    @Override
    public void setContentView(int layoutId) {
        setContentView(View.inflate(this, layoutId, null));
    }

    @Override
    public void setContentView(View view) {
        rootLayout = (LinearLayout)findViewById(R.id.root_layout);
        if (rootLayout == null) return;
        rootLayout.addView(view, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        initNavigationBar();
    }

    public void setTitle(String title) {
        this.title = title;
        this.navigationBar.titleView.setText(title);
    }
}
