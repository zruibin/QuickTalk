package com.creactism.quicktalk.services.account;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class AccountPhoneActivity extends BaseActivity {

    private EditText phoneField;
    private EditText codeField;
    private Button getCodeButton;
    private Button submitButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("修改手机号码");
        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_account_phone);

        this.phoneField = (EditText)findViewById(R.id.activity_account_phone_phone);
        this.codeField = (EditText)findViewById(R.id.activity_account_phone_code);
        this.getCodeButton = (Button)findViewById(R.id.activity_account_phone_get_code);
        this.submitButton = (Button)findViewById(R.id.activity_account_phone_submit);

    }
}





