package com.creactism.quicktalk.services.account;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.services.account.model.AccountModel;
import com.creactism.quicktalk.util.DLog;

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
                submitData();
            }
        });

        this.textField = (EditText)findViewById(R.id.activity_account_info_edit_item);
        this.warnView = (TextView)findViewById(R.id.activity_account_info_edit_warn);
        this.textField.addTextChangedListener(this.textWatcher);
        this.textField.setText(UserInfo.sharedInstance().getNickname());
        this.textField.setSelection(UserInfo.sharedInstance().getNickname().length());
    }

    private TextWatcher textWatcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {

        }

        @Override
        public void afterTextChanged(Editable s) {
            if (s.length() >= 12) {
                warnView.setText("不能超过12个字");
            } else {
                warnView.setText("");
            }
        }
    };

    private void submitData() {
        final String nickname = this.textField.getText().toString();
        if (nickname.length() > 12) {
            QTToast.makeText(this, "昵称不能超过12个字");
            return;
        }

        String userUUID = UserInfo.sharedInstance().getUuid();
        QTProgressHUD.showHUD(this);
        AccountModel.requestForAccountInfo(userUUID, "nickname", nickname, new AccountModel
                .CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                QTProgressHUD.hide();
                if (action) {
                    QTToast.makeText(getBaseContext(), "修改成功");
                    UserInfo.sharedInstance().setNickname(nickname);
                    finish();
                } else {
                    QTToast.makeText(getBaseContext(), error.getMessage());
                }
            }
        });
    }

}
