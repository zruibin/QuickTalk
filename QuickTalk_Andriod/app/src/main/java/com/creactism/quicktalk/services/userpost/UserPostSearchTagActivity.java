package com.creactism.quicktalk.services.userpost;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class UserPostSearchTagActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_userpost_search_tag);

        Intent intent = getIntent();
        String tag = intent.getStringExtra("tag");

        UserPostSearchTagFragment userPostSearchTagFragment = new UserPostSearchTagFragment();
        if (tag != null && tag.length() != 0) {
            tag = tag.trim();
            userPostSearchTagFragment.setSearchText(tag);
            userPostSearchTagFragment.setShowSearchHeader(false);
            this.setTitle(tag);
            this.navigationBar.setDefaultBackAction(this);
        } else { //显示搜索
            userPostSearchTagFragment.setShowSearchHeader(true);
            this.navigationBar.setVisibility(View.GONE);
        }

        setContentView(R.layout.activity_user_collection);
        LinearLayout linearLayout = (LinearLayout)findViewById(R.id.activity_userpost_search_tag_layout);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT));
        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.activity_userpost_search_tag_layout, userPostSearchTagFragment)
                .commit();
    }


}
