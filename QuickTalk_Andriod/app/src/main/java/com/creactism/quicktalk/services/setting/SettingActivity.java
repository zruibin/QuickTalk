package com.creactism.quicktalk.services.setting;

import android.app.ActivityOptions;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.components.tableview.TableEntity;
import com.creactism.quicktalk.components.tableview.TableListAdapter;
import com.creactism.quicktalk.services.account.AccountSettingActivity;
import com.facebook.drawee.view.SimpleDraweeView;

import java.util.ArrayList;
import java.util.List;

import static com.creactism.quicktalk.Marcos.QTLoginStatusChangeNotification;

/**
 * Created by ruibin.chow on 23/01/2018.
 */

public class SettingActivity extends BaseActivity {

    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<TableEntity> dataList;
    private TableListAdapter sectionTableListAdapter;
    private BroadcastReceiver broadcastReceiver;

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
//        this.recyclerView.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
        this.recyclerView.addItemDecoration(new RecycleViewDivider(getBaseContext(),
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));

        this.sectionTableListAdapter = new SettingAdapter(this.dataList);
        this.recyclerView.setAdapter(this.sectionTableListAdapter);

        View footerView = getFooterView();
        this.sectionTableListAdapter.setFooterView(footerView);
        this.broadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                View footerView = getFooterView();
                sectionTableListAdapter.setFooterView(footerView);
            }
        };
        registerReceiver(this.broadcastReceiver, new IntentFilter(QTLoginStatusChangeNotification));
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(this.broadcastReceiver);
    }

    private View getFooterView() {
        /**haderView中子类不能是View类型*/
        View footerView = getLayoutInflater().
                inflate(R.layout.activity_setting_footer, (ViewGroup)this.recyclerView.getParent(), false);
        Button button = (Button)footerView.findViewById(R.id.activity_setting_footer_button);
        if (UserInfo.sharedInstance().isLogin) {
            button.setText("退出登录");
        } else {
            button.setText("登录");
        }
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (UserInfo.sharedInstance().isLogin) {
                    AlertDialog.Builder dialog = new AlertDialog.Builder(SettingActivity.this);
                    dialog.setTitle("确定要退出登录吗？");
                    dialog.setPositiveButton("确定",
                            new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    UserInfo.sharedInstance().logout();
                                }
                            });
                    dialog.setNegativeButton("取消", null);

                    AlertDialog alertDialog = dialog.create();
                    alertDialog.show();
                    //属性的获取都一定是要在Dialog调用完show()方法之后，
                    // 即Dialog展示出来之后。要不就会NullPointException
                    alertDialog.getButton(alertDialog.BUTTON_POSITIVE).setTextColor(Color.RED);
                } else {
                    UserInfo.sharedInstance().checkLoginStatus(SettingActivity.this);
                }
            }
        });
        return footerView;
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
                    if (UserInfo.sharedInstance().checkLoginStatus(SettingActivity.this) == true) {
                        Intent intent = new Intent().setClass(getBaseContext(), AccountSettingActivity.class);
                        startActivity(intent);
                    }
                }
                if (indexPath.row == 1) {
                    if (UserInfo.sharedInstance().checkLoginStatus(SettingActivity.this) == true) {
                        Intent intent = new Intent().setClass(getBaseContext(), NotificationSettingActivity.class);
                        startActivity(intent);
                    }
                }
            }

            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    Intent intent = new Intent().setClass(getBaseContext(), WelcomeActivity.class);
                    startActivity(intent);
//                    overridePendingTransition(R.anim.activity_up_open, 0);
                    overridePendingTransition(android.R.anim.fade_in, 0);
                }
                if (indexPath.row == 2) {
                    Intent intent = new Intent().setClass(getBaseContext(), UserAgreementActivity.class);
                    startActivity(intent);
                }
            }
        }
    }


}
