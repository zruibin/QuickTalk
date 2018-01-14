package com.creactism.quicktalk.services.user;

import android.os.Bundle;
import android.widget.LinearLayout;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.services.userpost.RecommendFragment;
import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 14/01/2018.
 */

public class UserActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user);
        DLog.info("UserActivity onCreate...");

        LinearLayout linearLayout = (LinearLayout)findViewById(R.id.user_linearlayout);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT));

        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.user_linearlayout, new RecommendFragment())
                .commit();
    }


}
