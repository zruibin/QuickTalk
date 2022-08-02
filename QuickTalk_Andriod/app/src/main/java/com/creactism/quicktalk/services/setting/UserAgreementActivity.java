package com.creactism.quicktalk.services.setting;

import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;

import java.io.IOException;
import java.io.InputStream;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class UserAgreementActivity extends BaseActivity {

    private TextView textView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("声明与用户协议");
        this.navigationBar.setDefaultBackAction(this);


        this.textView = new TextView(this);
        this.textView.setMaxLines(Integer.MAX_VALUE);
        textView.setMovementMethod(new ScrollingMovementMethod(){});
        LinearLayout.LayoutParams viewParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);
        this.textView.setLayoutParams(viewParams);
        this.textView.setPadding(10, 10, 10,10);
        setContentView(this.textView);

        loadData();
    }

    private void loadData() {
        String content = null;
        InputStream inputStream=null;
        try {
            inputStream = this.getResources().openRawResource(R.raw.user_agreement);
            byte buffer[]=new byte[inputStream.available()];
            inputStream.read(buffer);
            content=new String(buffer);
        } catch(IOException e) {
            ;
        } finally {
            if(inputStream!=null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    ;
                }
            }
        }
        this.textView.setText(content);
    }


}
