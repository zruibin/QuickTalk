package com.creactism.quicktalk.services.setting;

import android.os.Bundle;
import android.widget.CompoundButton;
import android.widget.Switch;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class NotificationSettingActivity extends BaseActivity {

    private Switch commentSwitch;
    private Switch likeSwitch;
    private Switch starSwitch;
    private Switch shareSwitch;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("新消息通知");
        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_notification_setting);

        this.commentSwitch = (Switch)findViewById(R.id.activity_notification_setting_comment);
        this.likeSwitch = (Switch)findViewById(R.id.activity_notification_setting_like);
        this.starSwitch = (Switch)findViewById(R.id.activity_notification_setting_star);
        this.shareSwitch = (Switch)findViewById(R.id.activity_notification_setting_share);



        this.commentSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked){
                    DLog.info("开启");
                }else {
                    DLog.info("关闭");
                }
            }
        });

        this.likeSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked){
                    DLog.info("开启");
                }else {
                    DLog.info("关闭");
                }
            }
        });

        this.starSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked){
                    DLog.info("开启");
                }else {
                    DLog.info("关闭");
                }
            }
        });

        this.shareSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked){
                    DLog.info("开启");
                }else {
                    DLog.info("关闭");
                }
            }
        });

    }


}
