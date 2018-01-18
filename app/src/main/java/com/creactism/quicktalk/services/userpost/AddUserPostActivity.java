package com.creactism.quicktalk.services.userpost;

import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.components.Navigationbar;
import com.creactism.quicktalk.modules.NotificationCenter;
import com.creactism.quicktalk.util.DLog;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class AddUserPostActivity extends BaseActivity {

//    @BindView(R.id.add_userpost_navigationbar)
    public Navigationbar navigationbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        DLog.info("AddUserPostActivity onCreate....");
//        this.setContentView(R.layout.activity_add_userpost);
//        ButterKnife.bind(this);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS,
                    WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        }


        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);
        LinearLayout lineLayout = new LinearLayout(this);
        lineLayout.setOrientation(LinearLayout.VERTICAL);
        lineLayout.setLayoutParams(params);
        lineLayout.setGravity(Gravity.TOP);
        this.addView(lineLayout);
        setContentView(lineLayout);

        NotificationCenter.defaultCenter().addObserver(this, "testNotification", new NotificationCenter.SelectorHandler(){
            @Override
            public void handler(Object object) {
                DLog.warn("NotificationCenter handler3: " + (String)object);
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        NotificationCenter.defaultCenter().removeObserver(this, "testNotification");
    }

    private void addView(final LinearLayout lineLayout) {

        /*
    <android.support.v7.widget.Toolbar android:id="@+id/toolbar"
        xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:background="@color/tuna"
        android:minHeight="?attr/actionBarSize"
        app:popupTheme="@style/ThemeOverlay.AppCompat.Light"
        app:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar">
    </android.support.v7.widget.Toolbar>
    */
        final Toolbar toolbar = new Toolbar(this);
        toolbar.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT));
//        toolbar.setBackgroundColor(this.getResources().getColor(R.color.tuna));
        toolbar.setBackgroundColor(Color.parseColor("#38383C"));
        TypedValue typedValue = new TypedValue();
        this.getTheme().resolveAttribute(R.attr.actionBarSize, typedValue, true);
        DLog.debug("density: " + String.valueOf(typedValue.density));
        toolbar.setMinimumHeight(44);
        toolbar.setPopupTheme(R.style.ThemeOverlay_AppCompat_Light);
        lineLayout.addView(toolbar);


        this.navigationbar = new Navigationbar(this);
        this.navigationbar.setTitle("添加userpost(动态添加view)");
        this.navigationbar.setDefaultBackAction(this);
        this.navigationbar.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT));
        lineLayout.addView(this.navigationbar);

        final TextView showText = new TextView(this);
        showText.setTextColor(Color.GREEN);
        showText.setTextSize(30);
        showText.setId(10001);//设置 id
        showText.setText("我是在程序中添加的第一个文本");
        showText.setBackgroundColor(Color.GRAY);
        // set 文本大小
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        //set 四周距离
        params.setMargins(10, 10, 10, 10);

        showText.setLayoutParams(params);

        //添加文本到主布局
        lineLayout.addView(showText);

        //创建按钮
        Button btn = new Button(this);
        btn.setText("点击删除文本");
        btn.setBackgroundColor(Color.GRAY);
        LinearLayout.LayoutParams btn_params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        btn_params.setMargins(0, 60, 60, 0);
        btn_params.gravity = Gravity.CENTER_HORIZONTAL;
        btn.setLayoutParams(btn_params);
        // 动态添加按钮到主布局
        lineLayout.addView(btn);

        //点击按钮 动态删除文本
        btn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                if (null != lineLayout.findViewById(10001)) {
                    lineLayout.removeView(showText);
                } else {
//                    Toast.makeText(AddUserPostActivity.this, "文本已被删除", Toast.LENGTH_SHORT).show();
                }

                NotificationCenter.defaultCenter().postNotification("testNotification", "stringObject...");
            }
        });

        //动态创建一个相对布局
        RelativeLayout relaLayout = new RelativeLayout(this);
        relaLayout.setBackgroundColor(Color.BLUE);
        RelativeLayout.LayoutParams lp11 = new RelativeLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, 120);

        relaLayout.setLayoutParams(lp11);
        //动态创建一个文本
        final TextView RelaText = new TextView(this);
        RelaText.setTextColor(Color.GREEN);
        RelaText.setTextSize(20);
        RelaText.setText("我是在程序中添加的第二个文本，在相对布局中");
        RelaText.setBackgroundColor(Color.GRAY);

        //设置文本的布局
        RelativeLayout.LayoutParams lp2 = new RelativeLayout.LayoutParams(
                ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);

        lp2.addRule(RelativeLayout.CENTER_IN_PARENT, RelativeLayout.TRUE);
        lp2.setMargins(10, 10, 10, 10);
        //将文本添加到相对布局中
        relaLayout.addView(RelaText, lp2);
        //将这个布局添加到主布局中
        lineLayout.addView(relaLayout);
    }
}
