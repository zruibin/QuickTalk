package com.creactism.quicktalk;

import android.app.Activity;
import android.content.Intent;

import com.creactism.quicktalk.modules.cache.QTCache;
import com.creactism.quicktalk.services.account.AccountLoginActivity;
import com.creactism.quicktalk.services.account.model.AccountModel;
import com.creactism.quicktalk.util.StringUtil;

import static com.creactism.quicktalk.Marcos.QTLoginStatusChangeNotification;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public final class UserInfo extends Object {

    private static final String QTLoginAccount = "kQTLoginAccount";
    private static final String QTLoginPassword = "kQTLoginPassword";
    private static final String QTLoginOpenId = "kQTLoginOpenId";
    private static final String QTLoginType = "kQTLoginType";

    private static UserInfo instance = new UserInfo();
    private App app;

    public void initApp(App app) {this.app = app;}

    private UserInfo(){}

    public static UserInfo sharedInstance() {
        return instance;
    }

    public boolean isLogin;
    public boolean hiddenData;
    private String id;
    private String uuid;
    private String avatar;
    private String nickname;
    private String detail;
    private String email;
    private String phone;
    private String qq;
    private String wechat;
    private String weibo;
    private String area;
    private int gender;
    private String deviceId;
    private String token;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getNickname() {
        if (this.nickname == null || this.nickname.length() == 0) {
            nickname = "用户"+this.id;
        }
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getQq() {
        return qq;
    }

    public void setQq(String qq) {
        this.qq = qq;
    }

    public String getWechat() {
        return wechat;
    }

    public void setWechat(String wechat) {
        this.wechat = wechat;
    }

    public String getWeibo() {
        return weibo;
    }

    public void setWeibo(String weibo) {
        this.weibo = weibo;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public void login(AccountModel accountModel, String password, String type) {
        this.id = accountModel.getId();
        this.uuid = accountModel.getUuid();
        this.nickname = accountModel.getNickname();
        this.avatar = accountModel.getAvatar();
        this.detail = accountModel.getDetail();
        this.email = accountModel.getEmail();
        this.phone = accountModel.getPhone();
        this.qq = accountModel.getQq();
        this.wechat = accountModel.getWechat();
        this.weibo = accountModel.getWeibo();
        this.area = accountModel.getArea();
        this.gender = accountModel.getGender();
        this.token = accountModel.getToken();
        this.isLogin = true;

        String phone = accountModel.getPhone();
        if (phone != null && phone.length() > 0) {
            QTCache.sharedCache().put(QTLoginAccount, accountModel.getPhone());
        }
        if (password != null) {
            QTCache.sharedCache().put(QTLoginPassword, StringUtil.md5(password));
        }
        QTCache.sharedCache().put(QTLoginType, type);
        this.app.sendBroadcast(new Intent(QTLoginStatusChangeNotification));
    }

    public void loginWithThirdPart(AccountModel accountModel, String openId, String type) {
        QTCache.sharedCache().put(QTLoginOpenId, StringUtil.md5(openId));
        login(accountModel, null, type);
    }

    public void logout() {
        this.isLogin = false;
        QTCache.sharedCache().remove(QTLoginAccount);
        QTCache.sharedCache().remove(QTLoginPassword);
        QTCache.sharedCache().remove(QTLoginType);
        QTCache.sharedCache().remove(QTLoginOpenId);
        this.id = null;
        this.uuid = null;
        this.nickname = null;
        this.avatar = null;
        this.app.sendBroadcast(new Intent(QTLoginStatusChangeNotification));
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




}
