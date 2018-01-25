package com.creactism.quicktalk.services.account;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.services.account.model.AccountModel;
import com.creactism.quicktalk.util.StringUtil;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class AccountLoginActivity extends BaseActivity {

    private EditText accountField;
    private EditText passwordField;
    private Button submitButton;
    private Button registerButton;
    private Button forgetButton;
    private ImageButton qqButton;
    private ImageButton wechatButton;
    private ImageButton weiboButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.setTitle("登录");
        this.navigationBar.showBack(true);
        this.navigationBar.backItem.setImageDrawable(getResources().getDrawable(R.mipmap.cancel));
        this.navigationBar.backItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                backAction();
            }
        });

        setContentView(R.layout.activity_account_login);
        this.accountField = (EditText)findViewById(R.id.activity_account_login_account);
        this.passwordField = (EditText)findViewById(R.id.activity_account_login_password);
        this.submitButton = (Button)findViewById(R.id.activity_account_login_submit);
        this.registerButton = (Button)findViewById(R.id.activity_account_login_register);
        this.forgetButton = (Button)findViewById(R.id.activity_account_login_forget);
        this.qqButton = (ImageButton)findViewById(R.id.activity_account_login_qq);
        this.wechatButton = (ImageButton)findViewById(R.id.activity_account_login_wechat);
        this.weiboButton = (ImageButton)findViewById(R.id.activity_account_login_weibo);

        buttonAction();
    }

    // 回调方法，从第二个页面回来的时候会执行这个方法
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 1010 && data != null) {
            String finishStr = data.getStringExtra("finish");
            if (finishStr != null) { backAction(); }
        }
    }

    private void buttonAction() {
        this.registerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent().setClass(getBaseContext(), AccountRegisterActivity.class);
                startActivityForResult(intent, 1010);
            }
        });
        this.forgetButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent().setClass(getBaseContext(), AccountForgetPasswordActivity.class);
                startActivity(intent);
            }
        });
        this.submitButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loginButtonAction();
            }
        });

        this.qqButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loginWithPlatform(QQ.NAME);
            }
        });
        this.wechatButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loginWithPlatform(Wechat.NAME);
            }
        });
        this.weiboButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loginWithPlatform(SinaWeibo.NAME);
            }
        });

    }

    private void backAction() {
        finish();
        overridePendingTransition(0, R.anim.activity_down_close);
    }

    private void loginWithPlatform(String name) {
        Platform platform = ShareSDK.getPlatform(name);
        ShareSDK.removeCookieOnAuthorize(true);
        platform.SSOSetting(false);  //设置false表示使用SSO授权方式
        //回调信息，可以在这里获取基本的授权返回的信息，
        // 但是注意如果做提示和UI操作要传到主线程handler里去执行
        platform.setPlatformActionListener(new PlatformActionListener() {

            @Override
            public void onError(Platform platform1, int arg1, Throwable arg2) {
                arg2.printStackTrace();
            }

            @Override
            public void onComplete(Platform platform1, int arg1, HashMap<String, Object> arg2) {
                //输出所有授权信息
                platform1.getDb().exportData();
                String uid = platform1.getDb().getUserId();
            }

            @Override
            public void onCancel(Platform arg0, int arg1) {

            }
        });
        if (platform.isAuthValid()) { //如果授权就删除授权资料
            platform.removeAccount(true);
        }
        platform.showUser(null);//执行登录，登录后在回调里面获取用户资料
    }

    private void loginButtonAction() {

        String account = this.accountField.getText().toString();
        final String password = this.passwordField.getText().toString();

        if (account.length() == 0) {
            QTToast.makeText(this, "请输入手机号");
            return;
        }
        if (password.length() == 0) {
            QTToast.makeText(this, "请输入密码");
            return;
        }

        if (StringUtil.isMobileNumber(account) == false) {
            QTToast.makeText(this, "请输入正确手机号");
        } else {
            QTProgressHUD.showHUD(this);
            AccountModel.requestLogin(account, StringUtil.md5(password), Marcos.QuickTalk_ACCOUNT_PHONE,
                    new AccountModel.CompleteHandler(){
                        @Override
                        public void completeHanlder(AccountModel accountModel, Error error) {
                            super.completeHanlder(accountModel, error);
                            QTProgressHUD.hide();
                            if (error != null) {
                                QTToast.makeText(getBaseContext(), error.getMessage());
                            } else {
                                QTToast.makeText(getBaseContext(), "登录成功");
                                UserInfo.sharedInstance().login(accountModel, password, Marcos.QuickTalk_ACCOUNT_PHONE);
                                backAction();
                            }
                        }
                    });
        }
    }

}


