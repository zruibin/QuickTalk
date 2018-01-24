package com.creactism.quicktalk.services.account;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class AccountInfoEditActivity extends BaseActivity {

    private EditText textField;
    private TextView warnView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("编辑昵称");
        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_account_info_edit);

        this.navigationBar.rightItem.setText("保存");
        this.navigationBar.rightItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });

        this.textField = (EditText)findViewById(R.id.activity_account_info_edit_item);
        this.warnView = (TextView)findViewById(R.id.activity_account_info_edit_warn);
    }
}
