package com.creactism.quicktalk.services.account;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.util.DLog;
import com.facebook.drawee.view.SimpleDraweeView;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class AccountInfoActivity extends BaseActivity {

    private SimpleDraweeView avatarView;
    private TextView nicknameField;
    private TextView genderField;
    private TextView areaField;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("个人信息");
        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_account_info);

        this.avatarView = (SimpleDraweeView)findViewById(R.id.activity_account_info_avatar);
        this.nicknameField = (TextView)findViewById(R.id.activity_account_info_nickname);
        this.genderField = (TextView)findViewById(R.id.activity_account_info_gender);
        this.areaField = (TextView)findViewById(R.id.activity_account_info_area);
    }

    public void onIconItemClick(View view) {
        Intent intent = new Intent().setClass(getBaseContext(), AccountChangeAvatarActivity.class);
        startActivity(intent);
    }

    public void onNicknameItemClick(View view) {
        Intent intent = new Intent().setClass(getBaseContext(), AccountInfoEditActivity.class);
        startActivity(intent);
    }

    public void onGenderItemClick(View view) {

    }

    public void onAreaItemClick(View view) {

    }

}





