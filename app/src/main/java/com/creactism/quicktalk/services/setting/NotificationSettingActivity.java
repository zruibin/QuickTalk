package com.creactism.quicktalk.services.setting;

import android.os.Bundle;
import android.widget.CompoundButton;
import android.widget.Switch;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.services.account.model.AccountModel;
import com.creactism.quicktalk.util.DLog;

import java.util.Map;

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

        this.commentSwitch.setId(new Integer(Marcos.NOTIFICATION_FOR_COMMENT));
        this.likeSwitch.setId(new Integer(Marcos.NOTIFICATION_FOR_LIKE));
        this.starSwitch.setId(new Integer(Marcos.NOTIFICATION_FOR_NEW_STAR));
        this.shareSwitch.setId(new Integer(Marcos.NOTIFICATION_FOR_NEW_SHARE));

        if (UserInfo.sharedInstance().isLogin) {
            loadData();
        }

        this.commentSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (buttonView.isPressed()) {
                    updateSwitch(commentSwitch, isChecked);
                }
            }
        });

        this.likeSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (buttonView.isPressed()) {
                    updateSwitch(likeSwitch, isChecked);
                }
            }
        });

        this.starSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (buttonView.isPressed()) {
                    updateSwitch(starSwitch, isChecked);
                }
            }
        });

        this.shareSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (buttonView.isPressed()) {
                    updateSwitch(shareSwitch, isChecked);
                }
            }
        });
    }

    private void loadData() {
        String userUUID = UserInfo.sharedInstance().getUuid();
        AccountModel.requestForSettingList(userUUID, new AccountModel.CompleteHandler() {
            @Override
            public void completeHanlder(Map<String, Boolean> map, Error error) {
                super.completeHanlder(map, error);
                if (error != null) {
                    QTToast.makeText(getBaseContext(), error.getMessage());
                } else {
                    commentSwitch.setChecked(map.get(Marcos.NOTIFICATION_FOR_COMMENT));
                    likeSwitch.setChecked(map.get(Marcos.NOTIFICATION_FOR_LIKE));
                    starSwitch.setChecked(map.get(Marcos.NOTIFICATION_FOR_NEW_STAR));
                    shareSwitch.setChecked(map.get(Marcos.NOTIFICATION_FOR_NEW_SHARE));
                }
            }
        });
    }

    private void updateSwitch(final Switch tSwitch, final Boolean status) {
        String userUUID = UserInfo.sharedInstance().getUuid();
        String type = String.valueOf(tSwitch.getId());
        AccountModel.requestForSetting(userUUID, type, status, new AccountModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (action == false) {
                    tSwitch.setChecked(!status);
                    QTToast.makeText(getBaseContext(), "修改失败");
                }
            }
        });
    }

}
