package com.creactism.quicktalk.services.user;

import android.os.Bundle;
import android.widget.LinearLayout;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.services.userpost.CollectionUserPostFragment;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class UserCollectionActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("我的收藏");
        this.navigationBar.setDefaultBackAction(this);

        setContentView(R.layout.activity_user_collection);
        LinearLayout linearLayout = (LinearLayout)findViewById(R.id.activity_user_collection_layout);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT));
        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.activity_user_collection_layout, new CollectionUserPostFragment())
                .commit();
    }
}
