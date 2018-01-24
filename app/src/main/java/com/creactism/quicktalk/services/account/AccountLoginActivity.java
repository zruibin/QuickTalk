package com.creactism.quicktalk.services.account;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.QTProgressHUD;

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
                finish();
                overridePendingTransition(0, R.anim.activity_down_close);
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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        QTProgressHUD.hide();
    }

    private void buttonAction() {
        this.registerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent().setClass(getBaseContext(), AccountRegisterActivity.class);
                startActivity(intent);
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
                QTProgressHUD.showHUD(AccountLoginActivity.this);
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


    private void loginWithPlatform(String name) {
        Platform platform = ShareSDK.getPlatform(name);
        ShareSDK.removeCookieOnAuthorize(true);
        platform.SSOSetting(false);  //设置false表示使用SSO授权方式
        //回调信息，可以在这里获取基本的授权返回的信息，
        // 但是注意如果做提示和UI操作要传到主线程handler里去执行
        platform.setPlatformActionListener(new PlatformActionListener() {

            @Override
            public void onError(Platform platform1, int arg1, Throwable arg2) {
                // TODO Auto-generated method stub
                arg2.printStackTrace();
            }

            @Override
            public void onComplete(Platform platform1, int arg1, HashMap<String, Object> arg2) {
                // TODO Auto-generated method stub
                //输出所有授权信息
                platform1.getDb().exportData();
                String uid = platform1.getDb().getUserId();
            }

            @Override
            public void onCancel(Platform arg0, int arg1) {
                // TODO Auto-generated method stub

            }
        });
        if (platform.isAuthValid()) { //如果授权就删除授权资料
            platform.removeAccount(true);
        }
        platform.showUser(null);//执行登录，登录后在回调里面获取用户资料
    }

}


