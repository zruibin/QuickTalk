package com.creactism.quicktalk;

import android.app.Activity;
import android.content.Intent;

import com.creactism.quicktalk.services.account.AccountLoginActivity;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public final class UserInfo extends Object {

    private static UserInfo instance = new UserInfo();

    private UserInfo(){}

    public static UserInfo sharedInstance() {
        return instance;
    }

    public boolean isLogin;
    public boolean hiddenData;
    public String id;
    public String uuid;
    public String avatar;
    public String nickname;
    public String detail;
    public String email;
    public String phone;
    public String qq;
    public String wechat;
    public String weibo;
    public String area;
    public int gender;
    public String deviceId;
    public String token;

//    public void login()
    public void logout() {

    }

    public void loginInBackground() {

    }

    public boolean checkLoginStatus(Activity activity) {
        if (this.isLogin == false) {
            Intent intent = new Intent().setClass(activity.getBaseContext(), AccountLoginActivity.class);
            activity.startActivity(intent);
            activity.overridePendingTransition(R.anim.activity_up_open, 0);
        }
        return this.isLogin;
    }

    /*检查登录是否过时*/
    public void checkingObsolescence() {

    }

    /*
- (void)login:(QTAccountInfo *)userInfo password:(NSString *)password type:(NSString *)type;
- (void)loginWithThirdPart:(QTAccountInfo *)userInfo openId:(NSString *)openId type:(NSString *)type;
    * */

}
