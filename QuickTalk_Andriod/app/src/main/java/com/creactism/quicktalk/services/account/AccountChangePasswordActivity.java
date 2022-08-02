package com.creactism.quicktalk.services.account;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.services.account.model.AccountModel;
import com.creactism.quicktalk.util.StringUtil;

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

        this.submitButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                submitAction();
            }
        });
    }

    private void submitAction() {
        String oldPassword = this.oldField.getText().toString();
        String newPassword = this.newField.getText().toString();
        String comfirPassword = this.comfirmField.getText().toString();
        if (newPassword.length() == 0) {
            QTToast.makeText(this, "新密码不能为空");
            return;
        }
        if (comfirPassword.length() == 0) {
            QTToast.makeText(this, "新密码确认不能为空");
            return;
        }
        if (oldPassword.equals(newPassword)) {
            QTToast.makeText(this, "新密码不能与旧密码一样");
            return;
        }
        if (newPassword.length() < 6) {
            QTToast.makeText(this, "新密码不能少于6位");
            return;
        }
        if (comfirPassword.equals(newPassword) == false) {
            QTToast.makeText(this, "新密码与确认密码必须一样");
            return;
        }

        String userUUID = UserInfo.sharedInstance().getUuid();
        QTProgressHUD.showHUD(this);
        AccountModel.requestForChangePassword(userUUID, StringUtil.md5(oldPassword),
                StringUtil.md5(newPassword), new AccountModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                QTProgressHUD.hide();
                if (action) {
                    QTToast.makeText(getBaseContext(), "修改成功，请重新登录");
                    UserInfo.sharedInstance().logout();
                    new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            final Intent intent = getPackageManager().getLaunchIntentForPackage(getPackageName());
                            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                            startActivity(intent);
                        }
                    }, 500);
                } else {
                    QTToast.makeText(getBaseContext(), error.getMessage());
                }
            }
        });

    }

}
