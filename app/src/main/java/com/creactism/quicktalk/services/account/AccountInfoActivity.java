package com.creactism.quicktalk.services.account;

import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.services.account.adapter.AddressPickTask;
import com.creactism.quicktalk.util.DLog;
import com.facebook.drawee.view.SimpleDraweeView;

import cn.qqtheme.framework.entity.City;
import cn.qqtheme.framework.entity.County;
import cn.qqtheme.framework.entity.Province;
import cn.qqtheme.framework.picker.OptionPicker;
import cn.qqtheme.framework.widget.WheelView;

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

    @Override
    protected void onResume() {
        super.onResume();
        loadData();
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
        OptionPicker picker = new OptionPicker(this, new String[]{"男", "女"});
        picker.setTitleText("性别");
        picker.setTitleTextColor(Color.BLACK);
        picker.setTextSize(14);
        picker.setTopLineColor(Color.BLACK);
        picker.setSubmitTextColor(Color.BLACK);
        picker.setCanceledOnTouchOutside(true);
        picker.setDividerRatio(WheelView.DividerConfig.FILL);
        picker.setDividerColor(Color.parseColor("#999999"));
        picker.setCancelTextColor(Color.RED);
        picker.setSelectedIndex(1);
        picker.setLineSpaceMultiplier(3);
        picker.setTextPadding(2);
        picker.setCycleDisable(true);
        picker.setTextSize(15);
        picker.setTextColor(Color.BLACK);
        picker.setOnOptionPickListener(new OptionPicker.OnOptionPickListener() {
            @Override
            public void onOptionPicked(int index, String item) {
                DLog.info("index: " + index + " item:" + item);
            }
        });
        picker.show();
    }

    public void onAreaItemClick(View view) {
        AddressPickTask task = new AddressPickTask(this);
        task.setHideCounty(true);
        task.setCallback(new AddressPickTask.Callback() {
            @Override
            public void onAddressInitFailed() {
                DLog.info("数据初始化失败");
            }

            @Override
            public void onAddressPicked(Province province, City city, County county) {
                DLog.info(province.getAreaName() + " " + city.getAreaName());
            }
        });
        task.execute("四川", "阿坝");
    }

    private void loadData() {
        if (UserInfo.sharedInstance().getAvatar() != null) {
            this.avatarView.setImageURI(Uri.parse(UserInfo.sharedInstance().getAvatar()));
        }
        this.nicknameField.setText(UserInfo.sharedInstance().getNickname());
        if (UserInfo.sharedInstance().getGender() == 1) {
            this.genderField.setText("男");
        } else if (UserInfo.sharedInstance().getGender() == 2) {
            this.genderField.setText("女");
        } else {
            this.genderField.setText("");
        }
        if (UserInfo.sharedInstance().getArea() != null) {
            this.areaField.setText(UserInfo.sharedInstance().getArea());
        } else {
            this.areaField.setText("");
        }
    }
}





