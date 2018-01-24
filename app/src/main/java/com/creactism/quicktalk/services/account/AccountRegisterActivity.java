package com.creactism.quicktalk.services.account;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class AccountRegisterActivity extends BaseActivity {

    private EditText accountField;
    private EditText passwordField;
    private EditText codeField;
    private Button getCodeButton;
    private Button submitButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("注册");
        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_account_register);

        this.accountField = (EditText)findViewById(R.id.activity_account_register_account);
        this.passwordField = (EditText)findViewById(R.id.activity_account_register_password);
        this.codeField = (EditText)findViewById(R.id.activity_account_register_code);
        this.getCodeButton = (Button)findViewById(R.id.activity_account_register_get_code);
        this.submitButton = (Button)findViewById(R.id.activity_account_register_submit);

    }
}
