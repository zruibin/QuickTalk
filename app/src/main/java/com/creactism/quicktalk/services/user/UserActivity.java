package com.creactism.quicktalk.services.user;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.services.userpost.LikeUserPostFragment;
import com.creactism.quicktalk.services.userpost.MainUserPostFragment;
import com.creactism.quicktalk.services.userpost.UserPostListFragment;
import com.creactism.quicktalk.util.DLog;
import com.kekstudio.dachshundtablayout.DachshundTabLayout;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public class UserActivity extends BaseActivity {

    private String userUUID;
    private String nickname;

    private List<String> tabs;

    private LinearLayout headerLayout;
    private ViewPager viewPager;
    private DachshundTabLayout tabLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("我的快言");
        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_user);

        Intent intent = getIntent();
        this.userUUID = intent.getStringExtra("userUUID");
        this.nickname = intent.getStringExtra("nickname");
        DLog.debug(this.userUUID);
        DLog.debug(this.nickname);

        this.headerLayout = (LinearLayout)findViewById(R.id.activity_user_header);
        this.headerLayout.setVisibility(View.GONE);

        QTProgressHUD.showHUD(this);
        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                QTProgressHUD.hide();
                headerLayout.setVisibility(View.VISIBLE);

                tabs = new ArrayList<String>();
                tabs.add("快言");
                tabs.add("赞");
                viewPager = (ViewPager)findViewById(R.id.activity_user_pager);
                viewPager.setAdapter(new PagerAdapter(getSupportFragmentManager()));
                tabLayout = (DachshundTabLayout)findViewById(R.id.activity_user_tab);
                tabLayout.setupWithViewPager(viewPager);
            }
        }, 2000);


    }

    private class PagerAdapter extends FragmentStatePagerAdapter {
        public PagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int i) {
            if (i == 0) {
                MainUserPostFragment mainUserPostFragment = new MainUserPostFragment();
                mainUserPostFragment.setUserUUID(userUUID);
                return mainUserPostFragment;
            } else {
                LikeUserPostFragment likeUserPostFragment = new LikeUserPostFragment();
                likeUserPostFragment.setUserUUID(userUUID);
                return likeUserPostFragment;
            }
        }

        @Override
        public int getCount() {
            return tabs.size();
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return tabs.get(position);
        }
    }
}
