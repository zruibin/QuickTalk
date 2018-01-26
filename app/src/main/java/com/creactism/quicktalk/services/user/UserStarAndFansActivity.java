package com.creactism.quicktalk.services.user;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.widget.ImageButton;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.services.user.adapter.UserStarOrFansAdapter;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DrawableUtil;
import com.kekstudio.dachshundtablayout.DachshundTabLayout;
import com.kekstudio.dachshundtablayout.HelperUtils;
import com.kekstudio.dachshundtablayout.indicators.DachshundIndicator;
import com.kekstudio.dachshundtablayout.indicators.LineFadeIndicator;
import com.kekstudio.dachshundtablayout.indicators.LineMoveIndicator;
import com.kekstudio.dachshundtablayout.indicators.PointFadeIndicator;
import com.kekstudio.dachshundtablayout.indicators.PointMoveIndicator;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class UserStarAndFansActivity extends BaseActivity {

    private static final String TABS[] = {"关注", "粉丝"};

    private ImageButton backButton;
    private ViewPager viewPager;
    private DachshundTabLayout tabLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.navigationBar.setVisibility(View.GONE);
        setContentView(R.layout.activity_user_star_and_fans);

        this.backButton = (ImageButton)findViewById(R.id.activity_user_star_and_fans_back);
        Drawable drawable = DrawableUtil.getRoundRectRippleDrawable(
                getResources().getColor(R.color.QuickTalk_NAVBAR_BG_COLOR, null), 10);
        this.backButton.setBackground(drawable);
        this.backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        this.viewPager = (ViewPager)findViewById(R.id.activity_user_star_and_fans_pager);
        this.viewPager.setAdapter(new PagerAdapter(getSupportFragmentManager()));
        this.tabLayout = (DachshundTabLayout)findViewById(R.id.activity_user_star_and_fans_tab);
        this.tabLayout.setupWithViewPager(this.viewPager);
    }


    public class PagerAdapter extends FragmentStatePagerAdapter {
        public PagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int i) {
            if (i == 0) {
                UserStarFragment userStarFragment = new UserStarFragment();
                userStarFragment.setUserUUID(UserInfo.sharedInstance().getUuid());
                return userStarFragment;
            } else {
                UserFansFragment userFansFragment = new UserFansFragment();
                userFansFragment.setUserUUID(UserInfo.sharedInstance().getUuid());
                return userFansFragment;
            }
        }

        @Override
        public int getCount() {
            return TABS.length;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            DLog.debug("position:"+position);
            return TABS[position];
        }
    }

}








