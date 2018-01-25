package com.creactism.quicktalk.services.user;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.util.ColorUtil;

/**
 * Created by ruibin.chow on 25/01/2018.
 */

public class UserSearchActivity extends BaseActivity {

    private EditText searchField;
    private Button cancelButton;
    private SwipeRefreshLayout refreshLayout;
    private RecyclerView recyclerView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.navigationBar.setVisibility(View.GONE);
        setContentView(R.layout.activity_user_search);

        this.searchField = (EditText)findViewById(R.id.activity_user_search_field);
        this.cancelButton = (Button)findViewById(R.id.activity_user_search_cancel);
        this.refreshLayout = (SwipeRefreshLayout)findViewById(R.id.activity_user_search_refresh);
        this.recyclerView = (RecyclerView)findViewById(R.id.activity_user_search_recyclerview);

        Drawable searchEditDraw = getResources().getDrawable(R.mipmap.search);
        searchEditDraw.setBounds(0, 0, 30, 30);
        this.searchField.setCompoundDrawables(searchEditDraw, null, null, null);
        this.cancelButton.setTextColor(ColorUtil.getColorStateList(
                ColorUtil.getResourcesColor(getBaseContext(), R.color.QuickTalk_NAVBAR_TINT_COLOR),
                ColorUtil.getResourcesColor(getBaseContext(), R.color.QuickTalk_MAIN_COLOR), 0, 0));
        this.cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
}
