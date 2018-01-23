package com.creactism.quicktalk.services.account;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.components.tableview.TableEntity;
import com.creactism.quicktalk.components.tableview.TableListAdapter;
import com.facebook.drawee.view.SimpleDraweeView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class AccountSettingActivity extends BaseActivity {

    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<TableEntity> dataList;
    private TableListAdapter sectionTableListAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("帐号与安全");
        this.navigationBar.setDefaultBackAction(this);

        this.recyclerView = new RecyclerView(this);
        LinearLayout.LayoutParams viewParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);
        this.recyclerView.setLayoutParams(viewParams);
        setContentView(this.recyclerView);

        this.dataList = new ArrayList<TableEntity>();
        this.loadData();
        this.layoutManager = new LinearLayoutManager(this);
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));

        this.sectionTableListAdapter = new AccountSettingAdapter(this.dataList);
        this.recyclerView.setAdapter(this.sectionTableListAdapter);
    }

    private void loadData() {
        this.dataList.add(new TableEntity(true, "", new TableEntity.IndexPath(0, 0)));
        this.dataList.add(new TableEntity("修改手机号码", new TableEntity.IndexPath(0, 0)));
        this.dataList.add(new TableEntity("修改密码", new TableEntity.IndexPath(0, 1)));
        this.dataList.add(new TableEntity("第三方帐号管理", new TableEntity.IndexPath(0, 2)));
    }


    private class AccountSettingAdapter extends TableListAdapter {

        public AccountSettingAdapter(List<TableEntity> data) {
            super(data);
        }

        @Override
        public void cellForRowAtIndexPath(final BaseViewHolder helper, final TableEntity item, final TableEntity
                .IndexPath indexPath) {

            final SimpleDraweeView imageView = helper.getView(this.table_image_id);
            imageView.setVisibility(View.GONE);

            TextView textView = helper.getView(this.table_text_id);
            textView.setText((String)item.getObj());

            ImageView indicator = helper.getView(table_indicator_id);
            if (indexPath.section == 1 && indexPath.row == 4) {
                indicator.setVisibility(View.GONE);
            }
        }

        @Override
        public void didSelectRowAtIndexPath(final TableEntity item, final TableEntity.IndexPath indexPath) {

            if (indexPath.row == 0) {
                Intent intent = new Intent().setClass(getBaseContext(), AccountPhoneActivity.class);
                startActivity(intent);
            }
            if (indexPath.row == 1) {
                Intent intent = new Intent().setClass(getBaseContext(), AccountChangePasswordActivity.class);
                startActivity(intent);
            }
            if (indexPath.row == 2) {
                Intent intent = new Intent().setClass(getBaseContext(), AccountThirdPartActivity.class);
                startActivity(intent);
            }
        }
    }
}
