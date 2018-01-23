package com.creactism.quicktalk.services.account;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class AccountChangePasswordActivity extends BaseActivity {

    private EditText oldField;
    private EditText newField;
    private EditText comfirmField;
    private Button submitButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("修改密码");
        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_account_change_password);

        this.oldField = (EditText)findViewById(R.id.activity_account_chanage_password_old);
        this.newField = (EditText)findViewById(R.id.activity_account_chanage_password_new);
        this.comfirmField = (EditText)findViewById(R.id.activity_account_chanage_password_comfirm);
        this.submitButton = (Button)findViewById(R.id.activity_account_chanage_password_submit);


    }
}
