package com.creactism.quicktalk.services.user;

import android.content.Intent;
import android.os.Bundle;
import android.widget.LinearLayout;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.QTToast;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class UserStarActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("关注");
        this.navigationBar.setDefaultBackAction(this);

        Intent intent = getIntent();
        String userUUID = intent.getStringExtra("userUUID");
        if (userUUID == null) {
            QTToast.makeText(this, "用户不存在");
            finish();
            return;
        }

        UserStarFragment userStarFragment = new UserStarFragment();
        userStarFragment.setUserUUID(userUUID);

        setContentView(R.layout.activity_user_collection);
        LinearLayout linearLayout = (LinearLayout)findViewById(R.id.activity_user_collection_layout);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT));
        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.activity_user_collection_layout, userStarFragment)
                .commit();
    }
}
