package com.creactism.quicktalk;

import android.os.Bundle;
import android.view.View;

import com.creactism.quicktalk.services.userpost.MyFragment;
import com.creactism.quicktalk.services.userpost.UserPostListFragment;
import com.creactism.quicktalk.services.userpost.StarUserPostFragment;
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
//                .isShowDivider(false)
                .addTabItem("快言", R.mipmap.news_unselect, StarUserPostFragment.class)
                .addTabItem("发现", R.mipmap.circle_unselect, UserPostListFragment.class)
                .addTabItem("我", R.mipmap.my_unselect, MyFragment.class);
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
