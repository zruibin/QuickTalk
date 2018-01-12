package com.creactism.quicktalk;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.creactism.quicktalk.components.BaseActivity;
import com.creactism.quicktalk.services.userpost.RecommendFragment;
import com.creactism.quicktalk.services.userpost.UserPostFragment;
import com.creactism.quicktalk.util.DLog;
import com.hjm.bottomtabbar.BottomTabBar;


public class MainActivity extends BaseActivity {

    private BottomTabBar tabBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        this.tabBar = (BottomTabBar) findViewById(R.id.tab_bar);
        this.tabBar.init(getSupportFragmentManager())
                .addTabItem("第一项", R.mipmap.ic_launcher, UserPostFragment.class)
                .addTabItem("第二项", R.mipmap.ic_launcher, RecommendFragment.class);
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
