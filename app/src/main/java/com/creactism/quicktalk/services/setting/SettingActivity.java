package com.creactism.quicktalk.services.setting;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.tableview.TableEntity;
import com.creactism.quicktalk.components.tableview.TableListAdapter;
import com.creactism.quicktalk.services.account.AccountSettingActivity;
import com.facebook.drawee.view.SimpleDraweeView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class SettingActivity extends BaseActivity {

    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<TableEntity> dataList;
    private TableListAdapter sectionTableListAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting);
        this.setTitle("设置");
        this.navigationBar.setDefaultBackAction(this);

        this.dataList = new ArrayList<TableEntity>();
        this.loadData();
        this.recyclerView = (RecyclerView)findViewById(R.id.setting_recyclerview);
        this.layoutManager = new LinearLayoutManager(this);
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));

        this.sectionTableListAdapter = new SettingAdapter(this.dataList);
        this.recyclerView.setAdapter(this.sectionTableListAdapter);
    }

    private void loadData() {
        this.dataList.add(new TableEntity(true, "user", new TableEntity.IndexPath(0, 0)));
        this.dataList.add(new TableEntity("帐号与安全", new TableEntity.IndexPath(0, 0)));
        this.dataList.add(new TableEntity("消息通知", new TableEntity.IndexPath(0, 1)));

        this.dataList.add(new TableEntity(true, "data", new TableEntity.IndexPath(1, 0)));
        this.dataList.add(new TableEntity("欢迎页", new TableEntity.IndexPath(1, 0)));
        this.dataList.add(new TableEntity("使用指南", new TableEntity.IndexPath(1, 1)));
        this.dataList.add(new TableEntity("声明及用户协议", new TableEntity.IndexPath(1, 2)));
        this.dataList.add(new TableEntity("意见反馈", new TableEntity.IndexPath(1, 3)));
        this.dataList.add(new TableEntity("清除缓存", new TableEntity.IndexPath(1, 4)));

        this.dataList.add(new TableEntity(true, "login", new TableEntity.IndexPath(2, 0)));
        this.dataList.add(new TableEntity("退出登录", new TableEntity.IndexPath(2, 0)));
    }



    private class SettingAdapter extends TableListAdapter {

        public SettingAdapter(List<TableEntity> data) {
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

            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    Intent intent = new Intent().setClass(getBaseContext(), AccountSettingActivity.class);
                    startActivity(intent);
                }
            }

            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    Intent intent = new Intent().setClass(getBaseContext(), WelcomeActivity.class);
                    startActivity(intent);
                }
                if (indexPath.row == 2) {
                    Intent intent = new Intent().setClass(getBaseContext(), UserAgreementActivity.class);
                    startActivity(intent);
                }
            }
        }
    }


}
