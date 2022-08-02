package com.creactism.quicktalk.services.user;

import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ClickableSpan;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.services.user.model.UserModel;
import com.creactism.quicktalk.services.userpost.LikeUserPostFragment;
import com.creactism.quicktalk.services.userpost.MainUserPostFragment;
import com.creactism.quicktalk.services.userpost.UserPostListFragment;
import com.creactism.quicktalk.util.DLog;
import com.facebook.drawee.view.SimpleDraweeView;
import com.kekstudio.dachshundtablayout.DachshundTabLayout;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
    private UserModel userModel;
    private Button messageButton;
    private SimpleDraweeView avatarView;
    private Button nicknameButton;
    private ImageView genderView;
    private TextView areaView;
    private Button actionButton;
    private TextView countView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_user);

        Intent intent = getIntent();
        this.userUUID = intent.getStringExtra("userUUID").trim();
        this.nickname = intent.getStringExtra("nickname").trim();

        if (this.userUUID == null) {
            QTToast.makeText(this, "用户不存在");
            finish();
            return;
        }
        this.setTitle(this.nickname);
        this.messageButton = (Button)findViewById(R.id.activity_user_header_message);
        this.avatarView = (SimpleDraweeView)findViewById(R.id.activity_user_header_avatar);
        this.nicknameButton = (Button)findViewById(R.id.activity_user_header_nickname);
        this.genderView = (ImageView)findViewById(R.id.activity_user_header_gender);
        this.areaView = (TextView)findViewById(R.id.activity_user_header_area);
        this.countView = (TextView)findViewById(R.id.activity_user_header_count);
        this.actionButton = (Button)findViewById(R.id.activity_user_header_action);
        this.actionButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                starOrUnStarAction();
            }
        });
        this.headerLayout = (LinearLayout)findViewById(R.id.activity_user_header);
        this.headerLayout.setVisibility(View.GONE);
        QTProgressHUD.showHUD(this);
        UserModel.requestUserInfo(this.userUUID, new UserModel.CompleteHandler() {
            @Override
            public void completeHanlder(UserModel model, Error error) {
                super.completeHanlder(model, error);
                QTProgressHUD.hide();
                if (error != null) {
                    QTToast.makeText(UserActivity.this, error.getMessage());
                    finish();
                } else {
                    userModel = model;
                    initHeaderView();
                    if (UserInfo.sharedInstance().isLogin) {
                        List<String> uuidList = new ArrayList<String >();
                        uuidList.add(userModel.getUuid());
                        UserModel.requestStarRelation(UserInfo.sharedInstance().getUuid(), uuidList,
                                new UserModel.CompleteHandler() {
                            @Override
                            public void completeHanlder(Map<String, String> map, Error error) {
                                super.completeHanlder(map, error);
                                if (error == null) {
                                    if (map.keySet().contains(userModel.getUuid())) {
                                        userModel.setRelation(UserModel.UserRelationStar);
                                    } else {
                                        userModel.setRelation(UserModel.UserRelationDefault);
                                    }
                                }
                                makeStarActionView();
                            }
                        });
                    } else {
                        makeStarActionView();
                    }
                }
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        this.messageButton.setVisibility(View.GONE);
    }

    private void initHeaderView() {
        if (this.userModel.getAvatar() != null) {
            this.avatarView.setImageURI(Uri.parse(this.userModel.getAvatar()));
        }
        this.nicknameButton.setText(this.userModel.getNickname());
        this.areaView.setText(this.userModel.getArea());
        if (this.userModel.getGender() == Marcos.QuickTalk_GENDER_FEMALE) {
            this.genderView.setImageDrawable(getResources().getDrawable(R.mipmap.female));
        } else if (this.userModel.getGender() == Marcos.QuickTalk_GENDER_MALE) {
            this.genderView.setImageDrawable(getResources().getDrawable(R.mipmap.male));
        } else {
            this.genderView.setVisibility(View.GONE);
        }

        /**
         * 参考：
         *        http://blog.csdn.net/abc6368765/article/details/51567845
         *        https://www.cnblogs.com/zimengfang/p/5527259.html
         * */
        String fowllowString = this.userModel.getFollowCount() + " 关注";
        String fowllowingString = this.userModel.getFollowingCount() + " 粉丝";
        String userPostLikeString = this.userModel.getUserPostLikeCount() + " 获赞数";
        String countStr = fowllowString + "   " + fowllowingString + "   " + userPostLikeString;
        int followStart = countStr.indexOf("关注");
        int followEnd = followStart + 2;
        int followingStart = countStr.indexOf("粉丝");
        int followingEnd = followingStart + 2;
        int likeStart = countStr.indexOf("获赞数");
        int likeEnd = likeStart + 3;
        SpannableString textSpan = new SpannableString(countStr);
        //设置字体大小（绝对值,单位：像素）
        textSpan.setSpan(new AbsoluteSizeSpan(22), followStart, followEnd, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        textSpan.setSpan(new AbsoluteSizeSpan(22), followingStart, followingEnd, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        textSpan.setSpan(new AbsoluteSizeSpan(22), likeStart, likeEnd, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        //设置字体前景色
        textSpan.setSpan(new ForegroundColorSpan(Color.GRAY), followStart, followEnd, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        textSpan.setSpan(new ForegroundColorSpan(Color.GRAY), followingStart, followingEnd, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        textSpan.setSpan(new ForegroundColorSpan(Color.GRAY), likeStart, likeEnd, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        //区域点击
        textSpan.setSpan(new ClickableSpan() {
                             @Override
                             public void updateDrawState(TextPaint ds) {
                                 super.updateDrawState(ds);
//                   ds.setColor(Color.RED);       //设置文件颜色
                                 ds.setUnderlineText(false);      //设置下划线
                             }

                             @Override
                             public void onClick(View widget) {
                                 Intent intent = new Intent().setClass(UserActivity.this, UserStarActivity.class);
                                 intent.putExtra("userUUID", userModel.getUuid());
                                 startActivity(intent);
                             }
        }, countStr.indexOf(fowllowString), countStr.indexOf(fowllowString)+fowllowString.length(),
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        textSpan.setSpan(new ClickableSpan() {
                             @Override
                             public void updateDrawState(TextPaint ds) {
                                 super.updateDrawState(ds);
                                 ds.setUnderlineText(false);      //设置下划线
                             }
                             @Override
                             public void onClick(View widget) {
                                 Intent intent = new Intent().setClass(UserActivity.this, UserFansActivity.class);
                                 intent.putExtra("userUUID", userModel.getUuid());
                                 startActivity(intent);
                             }
        }, countStr.indexOf(fowllowingString), countStr.indexOf(fowllowingString)+fowllowString.length(),
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        textSpan.setSpan(new ClickableSpan() {
                             @Override
                             public void updateDrawState(TextPaint ds) {
                                 super.updateDrawState(ds);
                                 ds.setUnderlineText(false);      //设置下划线
                             }
                             @Override
                             public void onClick(View widget) {
                                 DLog.debug("获赞数。。。");
                             }
        }, countStr.indexOf(userPostLikeString), countStr.indexOf(userPostLikeString)+userPostLikeString.length(),
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        this.countView.setHighlightColor(Color.TRANSPARENT); //设置点击后的颜色为透明，否则会一直出现高亮
        this.countView.setText(textSpan);
        this.countView.setMovementMethod(LinkMovementMethod.getInstance());//开始响应点击事件

        this.tabs = new ArrayList<String>();
        if (this.userModel.getUserPostCount() > 0) {
            this.tabs.add("快言("+this.userModel.getUserPostCount()+")");
        } else {
            this.tabs.add("快言");
        }
        if (this.userModel.getLikedCount() > 0) {
            this.tabs.add("赞("+this.userModel.getLikedCount()+")");
        } else {
            this.tabs.add("赞");
        }
        headerLayout.setVisibility(View.VISIBLE);
        viewPager = (ViewPager)findViewById(R.id.activity_user_pager);
        viewPager.setAdapter(new PagerAdapter(getSupportFragmentManager()));
        tabLayout = (DachshundTabLayout)findViewById(R.id.activity_user_tab);
        tabLayout.setupWithViewPager(viewPager);
    }

    private void makeStarActionView() {
        if (this.userModel.getUuid().equals(UserInfo.sharedInstance().getUuid())) {
            this.actionButton.setVisibility(View.GONE);
        } else {
            this.actionButton.setVisibility(View.VISIBLE);
            if (this.userModel.getRelation() == UserModel.UserRelationStar) { //
                this.actionButton.setText("已关注");
                int color = getResources().getColor(R.color.QuickTalk_SECOND_FONT_COLOR);
                this.actionButton.setTextColor(color);
                this.actionButton.setBackground(getResources().getDrawable(R.drawable.user_button_style2, null));
            } else {
                this.actionButton.setText("关注");
                int color = getResources().getColor(R.color.QuickTalk_MAIN_COLOR);
                this.actionButton.setTextColor(color);
                this.actionButton.setBackground(getResources().getDrawable(R.drawable.user_button_style1, null));
            }
        }
    }

    private void starOrUnStarAction() {
        String action = Marcos.STAR_ACTION_FOR_STAR;
        if (this.userModel.getRelation() == UserModel.UserRelationStar) {
            action = Marcos.STAR_ACTION_FOR_UNSTAR;
        }
        String userUUID = UserInfo.sharedInstance().getUuid();
        UserModel.requestForStarOrUnStar(userUUID, this.userModel.getUuid(), action,
                new UserModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (error != null) {
                    QTToast.makeText(UserActivity.this, error.getMessage());
                } else {
                    if (userModel.getRelation() == UserModel.UserRelationStar) {
                        userModel.setRelation(UserModel.UserRelationDefault);
                    } else {
                        userModel.setRelation(UserModel.UserRelationStar);
                    }
                }
                makeStarActionView();
            }
        });
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
