package com.creactism.quicktalk;

import android.os.Bundle;
import android.view.View;

import com.creactism.quicktalk.services.userpost.RecommendFragment;
import com.creactism.quicktalk.services.userpost.UserPostFragment;
import com.hjm.bottomtabbar.BottomTabBar;


public class MainActivity extends BaseActivity {

    private BottomTabBar tabBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        this.tabBar = (BottomTabBar) findViewById(R.id.tab_bar);
        this.tabBar.init(getSupportFragmentManager())
//                .setImgSize(90, 90)
//                .setFontSize(12)
//                .setTabPadding(4, 6, 10)
//                .setChangeColor(Color.GREEN, Color.RED)
                .isShowDivider(false)
                .addTabItem("第一项", R.mipmap.ic_launcher, UserPostFragment.class)
                .addTabItem("第二项", R.mipmap.ic_launcher, RecommendFragment.class);
        this.tabBar.setOnTabChangeListener(new BottomTabBar.OnTabChangeListener() {
            @Override
            public void onTabChange(int position, String name, View view) {
                setTitle(name);
            }
        });
        this.tabBar.setCurrentTab(1);
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
