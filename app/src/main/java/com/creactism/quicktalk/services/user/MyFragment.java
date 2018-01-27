package com.creactism.quicktalk.services.user;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.components.tableview.TableEntity;
import com.creactism.quicktalk.components.tableview.TableListAdapter;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.DensityUtil;
import com.creactism.quicktalk.util.StringUtil;
import com.creactism.quicktalk.util.Tools;
import com.facebook.drawee.view.SimpleDraweeView;

import java.util.ArrayList;
import java.util.List;

import static com.creactism.quicktalk.Marcos.QTLoginStatusChangeNotification;

/**
 * Created by ruibin.chow on 22/01/2018.
 */

public class MyFragment extends BaseFragment {

    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<TableEntity> dataList;
    private TableListAdapter sectionTableListAdapter;
    private BroadcastReceiver receiver;

    @Override
    public void onDestroy() {
        super.onDestroy();
        getActivity().unregisterReceiver(receiver);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle
            savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.frag_my, null);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.my_recyclerview);
        this.dataList = new ArrayList<TableEntity>();
        initSubView(view);

        this.receiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                loadData();
            }
        };
        getActivity().registerReceiver(this.receiver, new IntentFilter(QTLoginStatusChangeNotification));

        loadData();
        return view;
    }

    private void initSubView(View view) {
        this.recyclerView = (RecyclerView) view.findViewById(R.id.my_recyclerview);
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
//        this.recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(),DividerItemDecoration.VERTICAL));
        this.recyclerView.addItemDecoration(new RecycleViewDivider(getActivity(),
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));
    }

    protected void loadData() {

        List<String> user = new ArrayList<String>();
        user.add(UserInfo.sharedInstance().getAvatar());
        user.add(UserInfo.sharedInstance().getNickname());
        user.add("com.creactism.quicktalk.services.account.AccountInfoActivity");

        List<String> unLogin = new ArrayList<String>();
        unLogin.add(String.valueOf(R.mipmap.avatar_default));
        unLogin.add("尚未登录");
        unLogin.add("null");

        List<String> users = new ArrayList<String>();
        users.add(String.valueOf(R.mipmap.users));
        users.add("关注与粉丝");
        users.add("com.creactism.quicktalk.services.user.UserStarAndFansActivity");

        List<String> userPost = new ArrayList<String>();
        userPost.add(String.valueOf(R.mipmap.userpost));
        userPost.add("我的快言");
        userPost.add("com.creactism.quicktalk.services.user.UserActivity");

        List<String> collection = new ArrayList<String>();
        collection.add(String.valueOf(R.mipmap.collection));
        collection.add("收藏");
        collection.add("com.creactism.quicktalk.services.user.UserActivity");

        List<String> share = new ArrayList<String>();
        share.add(String.valueOf(R.mipmap.share));
        share.add("分享快言App");
        share.add("com.creactism.quicktalk.services.user.UserActivity");

        List<String> setting = new ArrayList<String>();
        setting.add(String.valueOf(R.mipmap.setting));
        setting.add("设置");
        setting.add("com.creactism.quicktalk.services.setting.SettingActivity");

        this.dataList.clear();
        if (UserInfo.sharedInstance().isLogin) {
            this.dataList.add(new TableEntity(true, "user", new TableEntity.IndexPath(0, 0)));
            this.dataList.add(new TableEntity(user, new TableEntity.IndexPath(0, 0)));

            this.dataList.add(new TableEntity(true, "data", new TableEntity.IndexPath(1, 0)));
            this.dataList.add(new TableEntity(users, new TableEntity.IndexPath(1, 0)));
            this.dataList.add(new TableEntity(userPost, new TableEntity.IndexPath(1, 1)));
            this.dataList.add(new TableEntity(collection, new TableEntity.IndexPath(1, 2)));
            this.dataList.add(new TableEntity(share, new TableEntity.IndexPath(1, 3)));

            this.dataList.add(new TableEntity(true, "setting", new TableEntity.IndexPath(2, 0)));
            this.dataList.add(new TableEntity(setting, new TableEntity.IndexPath(2, 0)));
        } else {
            this.dataList.add(new TableEntity(true, "user", new TableEntity.IndexPath(0, 0)));
            this.dataList.add(new TableEntity(unLogin, new TableEntity.IndexPath(0, 0)));

            this.dataList.add(new TableEntity(true, "data", new TableEntity.IndexPath(1, 0)));
            this.dataList.add(new TableEntity(share, new TableEntity.IndexPath(1, 0)));

            this.dataList.add(new TableEntity(true, "setting", new TableEntity.IndexPath(2, 0)));
            this.dataList.add(new TableEntity(setting, new TableEntity.IndexPath(2, 0)));
        }

        this.sectionTableListAdapter = new MyAdapter(this.dataList);
        this.recyclerView.setAdapter(this.sectionTableListAdapter);
    }


    private class MyAdapter extends TableListAdapter {

        public MyAdapter(List<TableEntity> data) {
            super(data);
        }

        @Override
        public void cellForRowAtIndexPath(final BaseViewHolder helper, final TableEntity item, final TableEntity
                .IndexPath indexPath) {
            LinearLayout linearLayout = helper.getView(this.table_layout_id);
            LinearLayout.LayoutParams lp;
            if (item.getIndexPath().section == 0 && item.getIndexPath().row == 0) {
                lp = new LinearLayout.LayoutParams(LinearLayout
                        .LayoutParams.MATCH_PARENT, DensityUtil.dip2px(80));

            } else {
                lp = new LinearLayout.LayoutParams(LinearLayout
                        .LayoutParams.MATCH_PARENT, DensityUtil.dip2px(40));
            }
            linearLayout.setLayoutParams(lp);

            final SimpleDraweeView imageView = helper.getView(this.table_image_id);
            ViewTreeObserver vto2 = imageView.getViewTreeObserver();
            vto2.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                @Override
                public void onGlobalLayout() {
                    DLog.debug("width:"+String.valueOf(imageView.getWidth())+" height:"+String.valueOf(imageView.getHeight()));
                    imageView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    RelativeLayout.LayoutParams imageLP = (RelativeLayout.LayoutParams)imageView.getLayoutParams();
                    imageLP.width = imageView.getHeight();
                    imageLP.height = imageView.getHeight();
                    if (indexPath.section != 0) {
                        int margins = DensityUtil.dip2px(2);
                        imageLP.setMargins(margins, margins, margins, margins);
                    }
                    imageView.setLayoutParams(imageLP);
                }
            });

            List<String> data = (List<String>)item.getObj();
            String imageUrl = data.get(0);
            if (imageUrl != null && imageUrl.length() > 0) {
                if (StringUtil.isValidUrl(data.get(0))) {
                    imageView.setImageURI(Uri.parse(data.get(0)));
                } else {
                    imageView.setImageURI(Tools.getResoucesUri(Integer.parseInt(data.get(0))));
                }
            }

            TextView textView = helper.getView(this.table_text_id);
            textView.setText(data.get(1));
            if (indexPath.section == 0) {
                textView.setTextSize(18);
            }

            ImageView indicator = helper.getView(table_indicator_id);
            if (data.get(0).equals(String.valueOf(R.mipmap.share))) {
                indicator.setVisibility(View.GONE);
            } else {
                indicator.setVisibility(View.VISIBLE);
            }

        }

        @Override
        public void didSelectRowAtIndexPath(final TableEntity item, final TableEntity.IndexPath indexPath) {
            List<String> data = (List<String>)item.getObj();
            DLog.debug("section: "+data.get(2));

            if (indexPath.section == 0 && indexPath.row ==0) {
//                Intent intent = new Intent();
//                try {
//                    intent.setClass(getActivity().getApplicationContext(),
//                            Class.forName("com.creactism.quicktalk.services.account.AccountInfoActivity"));
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//                startActivity(intent);
                if (UserInfo.sharedInstance().checkLoginStatus(getActivity()) == false) {return;}
            }

            Intent intent = new Intent();
            try {
                intent.setClass(getActivity().getApplicationContext(), Class.forName(data.get(2)));
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
            startActivity(intent);
        }
    }

}
