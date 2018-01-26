package com.creactism.quicktalk.services.account;

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
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.components.tableview.TableEntity;
import com.creactism.quicktalk.components.tableview.TableListAdapter;
import com.creactism.quicktalk.util.Tools;
import com.facebook.drawee.view.SimpleDraweeView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class AccountThirdPartActivity extends BaseActivity {

    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<TableEntity> dataList;
    private TableListAdapter sectionTableListAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("第三方帐号管理");
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
//        this.recyclerView.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
        this.recyclerView.addItemDecoration(new RecycleViewDivider(getBaseContext(),
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));

        this.sectionTableListAdapter = new AccountThirdPartAdapter(this.dataList);
        this.recyclerView.setAdapter(this.sectionTableListAdapter);
    }

    private void loadData() {
        this.dataList.add(new TableEntity(true, "", new TableEntity.IndexPath(0, 0)));
        this.dataList.add(new TableEntity("", new TableEntity.IndexPath(0, 0)));
        this.dataList.add(new TableEntity("", new TableEntity.IndexPath(0, 1)));
        this.dataList.add(new TableEntity("", new TableEntity.IndexPath(0, 2)));
    }


    private class AccountThirdPartAdapter extends TableListAdapter {

        public AccountThirdPartAdapter(List<TableEntity> data) {
            super(data);
        }

        @Override
        public void cellForRowAtIndexPath(final BaseViewHolder helper, final TableEntity item, final TableEntity
                .IndexPath indexPath) {

//            ImageView indicator = helper.getView(table_indicator_id);
//            indicator.setVisibility(View.GONE);

            final SimpleDraweeView imageView = helper.getView(this.table_image_id);
            imageView.setPadding(4, 4, 4, 4);
            TextView textView = helper.getView(this.table_text_id);
            textView.setPadding(10, 0, 0, 0);
            TextView detailView = helper.getView(this.table_detail_id);
            if (indexPath.row == 0) {
                imageView.setImageURI(Tools.getResoucesUri(R.mipmap.wechat_bind));
                textView.setText("微信");
                detailView.setText("已绑定");
            }
            if (indexPath.row == 1) {
                imageView.setImageURI(Tools.getResoucesUri(R.mipmap.qq_bind));
                textView.setText("QQ");
                detailView.setText("已绑定");
            }
            if (indexPath.row == 2) {
                imageView.setImageURI(Tools.getResoucesUri(R.mipmap.weibo_bind));
                textView.setText("微博");
                detailView.setText("已绑定");
            }

        }

        @Override
        public void didSelectRowAtIndexPath(final TableEntity item, final TableEntity.IndexPath indexPath) {


        }
    }
}
