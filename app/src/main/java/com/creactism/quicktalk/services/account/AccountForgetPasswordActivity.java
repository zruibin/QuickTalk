package com.creactism.quicktalk.services.account;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.modules.Dispatch;
import com.creactism.quicktalk.services.account.model.AccountModel;
import com.creactism.quicktalk.util.StringUtil;

import cn.smssdk.EventHandler;
import cn.smssdk.SMSSDK;

import static com.creactism.quicktalk.Marcos.QuickTalk_ACCOUNT_PHONE;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class AccountForgetPasswordActivity extends BaseActivity {

    private EditText accountField;
    private EditText passwordField;
    private EditText codeField;
    private Button getCodeButton;
    private Button submitButton;
    private static int timeNumber;
    private CountDownTimer countDownTimer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("忘记密码");
        this.navigationBar.setDefaultBackAction(this);
        setContentView(R.layout.activity_account_forget_password);

        this.accountField = (EditText)findViewById(R.id.activity_account_forget_account);
        this.passwordField = (EditText)findViewById(R.id.activity_account_forget_password);
        this.codeField = (EditText)findViewById(R.id.activity_account_forget_code);
        this.getCodeButton = (Button)findViewById(R.id.activity_account_forget_get_code);
        this.submitButton = (Button)findViewById(R.id.activity_account_forget_submit);

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
        String account = this.accountField.getText().toString();
        if (account.length() == 0) {
            QTToast.makeText(this, "请输入手机号");
            return;
        }
        if (StringUtil.isMobileNumber(account) == false) {
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
        String phone = this.accountField.getText().toString();
        // 注册一个事件回调，用于处理发送验证码操作的结果
        SMSSDK.registerEventHandler(new EventHandler() {
            public void afterEvent(int event, final int result, Object data) {
                Dispatch.dispatchAsync(Dispatch.DISPATCH_GET_MAIN_QUEUE, new Dispatch.DispatchBlock() {
                    @Override
                    public void inMainThread() {
                        if (result != SMSSDK.RESULT_COMPLETE) {
                            // 请注意，此时只是完成了发送验证码的请求，验证码短信还需要几秒钟之后才送达
                            QTToast.makeText(AccountForgetPasswordActivity.this, "发送验证码失败");
                            if (countDownTimer != null) {
                                countDownTimer.onFinish();
                                countDownTimer.cancel();
                            }
                        } else {
                            QTToast.makeText(AccountForgetPasswordActivity.this, "发送验证码成功");
                        }
                    }
                });
            }
        });
        // 触发操作
        SMSSDK.getVerificationCode("86", phone);
    }

    private void submitButtonAction() {
        String account = this.accountField.getText().toString();
        String verifyCode = this.codeField.getText().toString();
        String password = this.passwordField.getText().toString();

        if (account.length() == 0) {
            QTToast.makeText(this, "请输入手机号");
            return;
        }
        if (password.length() == 0) {
            QTToast.makeText(this, "请输入密码");
            return;
        }
        if (verifyCode.length() == 0) {
            QTToast.makeText(this, "请输入验证码");
            return;
        }
        if (StringUtil.isMobileNumber(account) == false) {
            QTToast.makeText(this, "请输入正确手机号");
            return;
        }
        if (password.length() < 6) {
            QTToast.makeText(this, "新密码长度至少6位");
            return;
        }

        // 注册一个事件回调，用于处理提交验证码操作的结果
        SMSSDK.registerEventHandler(new EventHandler() {
            public void afterEvent(int event, final int result, Object data) {
                Dispatch.dispatchAsync(Dispatch.DISPATCH_GET_MAIN_QUEUE, new Dispatch.DispatchBlock() {
                    @Override
                    public void inMainThread() {
                        if (result == SMSSDK.RESULT_COMPLETE) {
                            submitData();
                        } else{
                            QTToast.makeText(AccountForgetPasswordActivity.this, "验证码错误");
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
        SMSSDK.submitVerificationCode("86", account, verifyCode);
    }

    private void submitData() {
        String account = this.accountField.getText().toString();
        final String password = this.passwordField.getText().toString();

        QTProgressHUD.showHUD(this);
        AccountModel.requestForgetPassword(account, StringUtil.md5(password), QuickTalk_ACCOUNT_PHONE,
                new AccountModel.CompleteHandler() {
                    @Override
                    public void completeHanlder(boolean action, Error error) {
                        super.completeHanlder(action, error);
                        QTProgressHUD.hide();
                        if (action) {
                            QTToast.makeText(getBaseContext(), "修改成功，请登录");
                            finish();
                        } else {
                            QTToast.makeText(getBaseContext(), error.getMessage());
                        }
                    }
                });
    }


}
