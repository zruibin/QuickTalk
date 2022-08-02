package com.creactism.quicktalk.services.account;

import android.os.Bundle;
import android.os.CountDownTimer;
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

import cn.smssdk.EventHandler;
import cn.smssdk.SMSSDK;

import static com.creactism.quicktalk.Marcos.QuickTalk_ACCOUNT_PHONE;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class AccountPhoneActivity extends BaseActivity {

    private EditText phoneField;
    private EditText codeField;
    private Button getCodeButton;
    private Button submitButton;

    private static int timeNumber;
    private CountDownTimer countDownTimer;

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

        this.getCodeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onGetCodeButtonAction();
            }
        });
        this.submitButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                submitButtonAction();
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (this.countDownTimer != null) {
            this.countDownTimer.cancel();
        }
        SMSSDK.unregisterAllEventHandler();
    }


    private void onGetCodeButtonAction() {
        String phone = this.phoneField.getText().toString();
        if (phone.length() == 0) {
            QTToast.makeText(this, "请输入手机号");
            return;
        }
        if (StringUtil.isMobileNumber(phone) == false) {
            QTToast.makeText(this, "请输入正确手机号");
            return;
        }

        this.getCodeButton.setEnabled(false);
        timeNumber = 60;

        if (this.countDownTimer != null) {
            this.countDownTimer.cancel();
        }
        /*每隔1000毫秒执行onTick中的方法一次
        * 直到执行完1000*60/1000次为止，最后会执行onFinish()中的方法
        * */
        this.countDownTimer = new CountDownTimer(1000*timeNumber, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                --timeNumber;
                getCodeButton.setText(timeNumber+"秒后再次获取");
            }
            @Override
            public void onFinish() {
                getCodeButton.setEnabled(true);
                getCodeButton.setText("获取验证码");
            }
        };
        this.countDownTimer.start();
        sendVerifyCodeEvent();
    }

    private void sendVerifyCodeEvent() {
        String phone = this.phoneField.getText().toString();
        // 注册一个事件回调，用于处理发送验证码操作的结果
        SMSSDK.registerEventHandler(new EventHandler() {
            public void afterEvent(int event, final int result, Object data) {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        if (result != SMSSDK.RESULT_COMPLETE) {
                            // 请注意，此时只是完成了发送验证码的请求，验证码短信还需要几秒钟之后才送达
                            QTToast.makeText(AccountPhoneActivity.this, "发送验证码失败");
                            if (countDownTimer != null) {
                                countDownTimer.onFinish();
                                countDownTimer.cancel();
                            }
                        } else {
                            QTToast.makeText(AccountPhoneActivity.this, "发送验证码成功");
                        }
                    }
                });
            }
        });
        // 触发操作
        SMSSDK.getVerificationCode("86", phone);
    }

    private void submitButtonAction() {
        String phone = this.phoneField.getText().toString();
        String verifyCode = this.codeField.getText().toString();

        if (phone.length() == 0) {
            QTToast.makeText(this, "请输入手机号");
            return;
        }
        if (verifyCode.length() == 0) {
            QTToast.makeText(this, "请输入验证码");
            return;
        }
        if (StringUtil.isMobileNumber(phone) == false) {
            QTToast.makeText(this, "请输入正确手机号");
            return;
        }
//         注册一个事件回调，用于处理提交验证码操作的结果
        SMSSDK.registerEventHandler(new EventHandler() {
            public void afterEvent(int event, final int result, Object data) {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        if (result == SMSSDK.RESULT_COMPLETE) {
                            submitData();
                        } else{
                            QTToast.makeText(AccountPhoneActivity.this, "验证码错误");
                            if (countDownTimer != null) {
                                countDownTimer.onFinish();
                                countDownTimer.cancel();
                            }
                        }
                    }
                });
            }
        });
        // 触发操作
        SMSSDK.submitVerificationCode("86", phone, verifyCode);
    }

    private void submitData() {
        final String phone = this.phoneField.getText().toString();
        String userUUID = UserInfo.sharedInstance().getUuid();
        QTProgressHUD.showHUD(this);
        AccountModel.requestForAccountInfo(userUUID, "phone", phone, new AccountModel
                .CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                QTProgressHUD.hide();
                if (action) {
                    QTToast.makeText(getBaseContext(), "修改成功");
                    UserInfo.sharedInstance().setPhone(phone);
                    finish();
                } else {
                    QTToast.makeText(getBaseContext(), error.getMessage());
                }
            }
        });
    }



}





