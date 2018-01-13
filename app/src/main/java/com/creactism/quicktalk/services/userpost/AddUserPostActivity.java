package com.creactism.quicktalk.services.userpost;

import android.os.Bundle;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.components.Navigationbar;
import com.creactism.quicktalk.util.DLog;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class AddUserPostActivity extends BaseActivity {

    @BindView(R.id.add_userpost_navigationbar)
    public Navigationbar navigationbar;

    @Override
    protected void onCreate(Bundle savedInstanceState)  {
        super.onCreate(savedInstanceState);
        DLog.info("AddUserPostActivity onCreate....");
        this.setContentView(R.layout.activity_add_userpost);
        ButterKnife.bind(this);

        this.navigationbar.setTitle("添加userpost");
        this.navigationbar.setDefaultBackAction(this);
    }
}
