package com.creactism.quicktalk.services.account;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;

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
    }




}


