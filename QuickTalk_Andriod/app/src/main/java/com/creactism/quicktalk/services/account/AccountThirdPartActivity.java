package com.creactism.quicktalk.services.account;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.components.tableview.TableEntity;
import com.creactism.quicktalk.components.tableview.TableListAdapter;
import com.creactism.quicktalk.services.account.model.AccountModel;
import com.creactism.quicktalk.util.StringUtil;
import com.creactism.quicktalk.util.Tools;
import com.facebook.drawee.view.SimpleDraweeView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;

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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        QTProgressHUD.hide();
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

            ImageView indicator = helper.getView(table_indicator_id);
            indicator.setVisibility(View.GONE);

            final SimpleDraweeView imageView = helper.getView(this.table_image_id);
            imageView.setPadding(4, 4, 4, 4);
            TextView textView = helper.getView(this.table_text_id);
            textView.setPadding(10, 0, 0, 0);
            TextView detailView = helper.getView(this.table_detail_id);
            if (indexPath.row == 0) {
                textView.setText("微信");
                if (UserInfo.sharedInstance().getWechat().length() > 0) {
                    imageView.setImageURI(Tools.getResoucesUri(R.mipmap.wechat_bind));
                    detailView.setText("已绑定");
                } else {
                    imageView.setImageURI(Tools.getResoucesUri(R.mipmap.wechat_unbind));
                    detailView.setText("未绑定");
                }
            }
            if (indexPath.row == 1) {
                textView.setText("QQ");
                if (UserInfo.sharedInstance().getQq().length() > 0) {
                    imageView.setImageURI(Tools.getResoucesUri(R.mipmap.qq_bind));
                    detailView.setText("已绑定");
                } else {
                    imageView.setImageURI(Tools.getResoucesUri(R.mipmap.qq_unbind));
                    detailView.setText("未绑定");
                }

            }
            if (indexPath.row == 2) {
                textView.setText("微博");
                if (UserInfo.sharedInstance().getWeibo().length() > 0) {
                    imageView.setImageURI(Tools.getResoucesUri(R.mipmap.weibo_bind));
                    detailView.setText("已绑定");
                } else  {
                    imageView.setImageURI(Tools.getResoucesUri(R.mipmap.weibo_unbind));
                    detailView.setText("未绑定");
                }
            }
        }

        @Override
        public void didSelectRowAtIndexPath(final TableEntity item, final TableEntity.IndexPath indexPath) {
            if (indexPath.row == 0) { //微信
                if (UserInfo.sharedInstance().getWechat().length() == 0) {
                    bindWithPlatform(Wechat.NAME);
                } else {
                    if (checkingBindOnlyOneCount()) {
                        QTToast.makeText(getBaseContext(), "无法解除当前绑定");
                        return;
                    }
                    showAlertDialog(Marcos.QuickTalk_ACCOUNT_WECHAT);
                }
            }

            if (indexPath.row == 1) { //QQ
                if (UserInfo.sharedInstance().getQq().length() == 0) {
                    bindWithPlatform(QQ.NAME);
                } else {
                    if (checkingBindOnlyOneCount()) {
                        QTToast.makeText(getBaseContext(), "无法解除当前绑定");
                        return;
                    }
                    showAlertDialog(Marcos.QuickTalk_ACCOUNT_QQ);
                }
            }

            if (indexPath.row == 2) { //微博
                if (UserInfo.sharedInstance().getWeibo().length() == 0) {
                    bindWithPlatform(SinaWeibo.NAME);
                } else {
                    if (checkingBindOnlyOneCount()) {
                        QTToast.makeText(getBaseContext(), "无法解除当前绑定");
                        return;
                    }
                    showAlertDialog(Marcos.QuickTalk_ACCOUNT_WEIBO);
                }
            }
        }
    }

    private boolean checkingBindOnlyOneCount() {
        int count = 0;
        if (UserInfo.sharedInstance().getWeibo().length() > 0) {
            ++count;
        }
        if (UserInfo.sharedInstance().getQq().length() > 0) {
            ++count;
        }
        if (UserInfo.sharedInstance().getWechat().length() > 0) {
            ++count;
        }
        if (count == 1) {
            return true;
        } else {
            return false;
        }
    }

    private void unBindThirdPart(final String type) {
        String userUUID = UserInfo.sharedInstance().getUuid();
        AccountModel.requestForThirdPart(userUUID, type, "2", "", new AccountModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (action == true) {
                    if (type.equals(Marcos.QuickTalk_ACCOUNT_WECHAT)) {
                        UserInfo.sharedInstance().setWechat(null);
                    }
                    if (type.equals(Marcos.QuickTalk_ACCOUNT_WEIBO)) {
                        UserInfo.sharedInstance().setWeibo(null);
                    }
                    if (type.equals(Marcos.QuickTalk_ACCOUNT_QQ)) {
                        UserInfo.sharedInstance().setQq(null);
                    }
                    sectionTableListAdapter.notifyDataSetChanged();
                } else {
                    QTToast.makeText(AccountThirdPartActivity.this, error.getMessage());
                }
            }
        });
    }

    private void bindThirdPart(final String type, final String openId) {
        String userUUID = UserInfo.sharedInstance().getUuid();
        AccountModel.requestForThirdPart(userUUID, type, "1", openId, new AccountModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (action == true) {
                    if (type.equals(Marcos.QuickTalk_ACCOUNT_WECHAT)) {
                        UserInfo.sharedInstance().setWechat(openId);
                    }
                    if (type.equals(Marcos.QuickTalk_ACCOUNT_WEIBO)) {
                        UserInfo.sharedInstance().setWeibo(openId);
                    }
                    if (type.equals(Marcos.QuickTalk_ACCOUNT_QQ)) {
                        UserInfo.sharedInstance().setQq(openId);
                    }
                    sectionTableListAdapter.notifyDataSetChanged();
                } else {
                    QTToast.makeText(AccountThirdPartActivity.this, error.getMessage());
                }
            }
        });
    }

    private void bindWithPlatform(String platformName) {
        String type = Marcos.QuickTalk_ACCOUNT_WECHAT;
        if (platformName.equals(SinaWeibo.NAME)) {
            type = Marcos.QuickTalk_ACCOUNT_WEIBO;
        }
        if (platformName.equals(QQ.NAME)) {
            type = Marcos.QuickTalk_ACCOUNT_QQ;
        }
        QTProgressHUD.showHUD(this);
        Platform platform = ShareSDK.getPlatform(platformName);
        ShareSDK.removeCookieOnAuthorize(true);
        platform.SSOSetting(false);  //设置false表示使用SSO授权方式
        //回调信息，可以在这里获取基本的授权返回的信息，
        // 但是注意如果做提示和UI操作要传到主线程handler里去执行
        final String finalType = type;
        platform.setPlatformActionListener(new PlatformActionListener() {

            @Override
            public void onError(Platform platform1, int arg1, Throwable arg2) {
                arg2.printStackTrace();
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        QTToast.makeText(AccountThirdPartActivity.this,"第三方授权失败");
                    }
                });
            }

            @Override
            public void onComplete(Platform platform1, int arg1, HashMap<String, Object> arg2) {
                //输出所有授权信息
                platform1.getDb().exportData();
                final String uid = platform1.getDb().getUserId();
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        QTProgressHUD.hide();
                        QTToast.makeText(AccountThirdPartActivity.this,"第三方授权成功");
                        bindThirdPart(finalType, StringUtil.md5(uid));
                    }
                });
            }

            @Override
            public void onCancel(Platform arg0, int arg1) {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        QTToast.makeText(AccountThirdPartActivity.this,"取消第三方授权");
                    }
                });
            }
        });
        if (platform.isAuthValid()) { //如果授权就删除授权资料
            platform.removeAccount(true);
        }
        platform.showUser(null);//执行登录，登录后在回调里面获取用户资料
    }

    private void showAlertDialog(final String type) {
        String title = null;
        if (type.equals(Marcos.QuickTalk_ACCOUNT_WECHAT)) {
            title = "解除微信绑定";
        }
        if (type.equals(Marcos.QuickTalk_ACCOUNT_QQ)) {
            title = "解除QQ绑定";
        }
        if (type.equals(Marcos.QuickTalk_ACCOUNT_WEIBO)) {
            title = "解除微博绑定";
        }
        AlertDialog.Builder dialog = new AlertDialog.Builder(AccountThirdPartActivity.this);
        dialog.setTitle(title);
        dialog.setPositiveButton("确定",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        unBindThirdPart(type);
                    }
                });
        dialog.setNegativeButton("取消", null);

        AlertDialog alertDialog = dialog.create();
        alertDialog.show();
        alertDialog.getButton(alertDialog.BUTTON_POSITIVE).setTextColor(Color.RED);
    }

}
