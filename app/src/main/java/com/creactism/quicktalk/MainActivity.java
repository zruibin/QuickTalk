package com.creactism.quicktalk;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.View;

import com.creactism.quicktalk.components.menu.IconMenuAdapter;
import com.creactism.quicktalk.components.menu.IconMenuItem;
import com.creactism.quicktalk.services.user.MyFragment;
import com.creactism.quicktalk.services.user.UserSearchActivity;
import com.creactism.quicktalk.services.userpost.RecommendUserPostFragment;
import com.creactism.quicktalk.services.userpost.StarUserPostFragment;
import com.creactism.quicktalk.util.ColorUtil;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.creactism.quicktalk.util.DrawableUtil;
import com.hjm.bottomtabbar.BottomTabBar;
import com.skydoves.powermenu.CustomPowerMenu;
import com.skydoves.powermenu.MenuAnimation;
import com.skydoves.powermenu.OnMenuItemClickListener;


public class MainActivity extends BaseActivity {

    private BottomTabBar tabBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        this.tabBar = (BottomTabBar)findViewById(R.id.tab_bar);
        this.tabBar.init(getSupportFragmentManager())
//                .setImgSize(90, 90)
//                .setFontSize(12)
//                .setTabPadding(4, 6, 10)
//                .setChangeColor(Color.GREEN, Color.RED)
//                .isShowDivider(false)
                .addTabItem("快言", R.mipmap.news_unselect, StarUserPostFragment.class)
                .addTabItem("发现", R.mipmap.circle_unselect, RecommendUserPostFragment.class)
                .addTabItem("我", R.mipmap.my_unselect, MyFragment.class);
        this.tabBar.setOnTabChangeListener(new BottomTabBar.OnTabChangeListener() {
            @Override
            public void onTabChange(int position, String name, View view) {
                setTitle(name);
                showRightItem(position);
            }
        });
        this.tabBar.setCurrentTab(1);

        Drawable drawable = getResources().getDrawable(R.mipmap.add);
        drawable = DrawableUtil.tintDrawable(drawable,
                ColorUtil.getResourcesColor(getBaseContext(), R.color.QuickTalk_NAVBAR_TINT_COLOR));
        drawable.setBounds(0, 0, 34, 34);
        this.navigationBar.rightItem.setCompoundDrawables(null, null, drawable, null);

        this.navigationBar.rightItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                initMenu();
            }
        });
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

    private void showRightItem(int position) {
        if (position == 2) {
            this.navigationBar.rightItem.setVisibility(View.GONE);
        } else {
            this.navigationBar.rightItem.setVisibility(View.VISIBLE);
        }
    }

    private void initMenu() {
        final CustomPowerMenu customPowerMenu = new CustomPowerMenu.Builder<>(this.getBaseContext(),
                new IconMenuAdapter())
                .addItem(new IconMenuItem(getResources().getDrawable(R.mipmap.link), "发表分享"))
                .addItem(new IconMenuItem(getResources().getDrawable(R.mipmap.search), "搜索标签"))
                .addItem(new IconMenuItem(getResources().getDrawable(R.mipmap.search_user), "搜索用户"))
                .setAnimation(MenuAnimation.FADE)
                .setMenuRadius(2f)
                .setMenuShadow(10f)
                .setWith(DensityUtil.dip2px(130))
                .build();
        customPowerMenu.showAsDropDown(this.navigationBar.rightItem);
        customPowerMenu.setOnMenuItemClickListener(new OnMenuItemClickListener() {
            @Override
            public void onItemClick(int position, Object item) {
                DLog.debug("position: " + position);
                customPowerMenu.dismiss();
                if (position == 2) { //搜索
                    Intent intent = new Intent().setClass(MainActivity.this, UserSearchActivity.class);
                    startActivity(intent);
                }
            }
        });
    }

}
