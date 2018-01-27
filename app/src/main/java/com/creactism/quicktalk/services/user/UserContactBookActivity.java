package com.creactism.quicktalk.services.user;

import android.database.Cursor;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.services.user.adapter.UserStarOrFansAdapter;
import com.creactism.quicktalk.services.user.model.UserModel;
import com.creactism.quicktalk.util.DLog;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by ruibin.chow on 25/01/2018.
 */

public class UserContactBookActivity extends BaseActivity {

    private String userUUID;
    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<UserModel> dataList;
    private UserStarOrFansAdapter adapter;
    private int index = 1;
    private View emptyView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("通讯录");
        this.navigationBar.setDefaultBackAction(this);

        setContentView(R.layout.activity_user_contact_book);
        this.dataList = new ArrayList<UserModel>();
        this.recyclerView = (RecyclerView)findViewById(R.id.activity_user_contact_book_recyclerview);
        this.layoutManager = new LinearLayoutManager(this);
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new RecycleViewDivider(this,
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));

        this.emptyView = getLayoutInflater().inflate(R.layout.layout_empty_view, (ViewGroup)this.recyclerView.getParent(), false);
        this.adapter = new UserStarOrFansAdapter();
        this.adapter.setActivity(this);
        this.adapter.openLoadAnimation();
        this.adapter.setItemHandler(new UserStarOrFansAdapter.OnUserItemHandler(){
            @Override
            public void onActionHandler(UserModel model) {
                super.onActionHandler(model);
                starOrUnStarAction(model);
            }
        });
        this.adapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {
                DLog.info("position: " + position);
            }
        });
        this.recyclerView.setAdapter(this.adapter);
        queryContactPhoneNumber();
    }

    private void queryContactPhoneNumber() {
        QTProgressHUD.showHUD(this);
        List<String> phoneList = new ArrayList<String>();
        String[] cols = {ContactsContract.PhoneLookup.DISPLAY_NAME, ContactsContract.CommonDataKinds.Phone.NUMBER};
        Cursor cursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                cols, null, null, null);
        for (int i = 0; i < cursor.getCount(); i++) {
            cursor.moveToPosition(i);
            // 取得联系人名字
            int nameFieldColumnIndex = cursor.getColumnIndex(ContactsContract.PhoneLookup.DISPLAY_NAME);
            int numberFieldColumnIndex = cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER);
            String name = cursor.getString(nameFieldColumnIndex);
            String number = cursor.getString(numberFieldColumnIndex);
//            DLog.info(name + ": " + number);
            phoneList.add(number);
        }
        if (phoneList.size() == 0) {
            QTProgressHUD.hide();
        }
        final String userUUID = UserInfo.sharedInstance().getUuid();
        UserModel.requestPhoneUserData(userUUID, phoneList, new UserModel.CompleteHandler() {
            @Override
            public void completeHanlder(final List<UserModel> list, Error error) {
                super.completeHanlder(list, error);
                if (error != null) {
                    QTProgressHUD.hide();
                    QTToast.makeText(UserContactBookActivity.this, error.getMessage());
                } else {
                    List<String> uuidList = new ArrayList<String>();
                    for (UserModel model : list) {
                        uuidList.add(model.getUuid());
                    }
                    /*查询是否已关注*/
                    UserModel.requestStarRelation(userUUID, uuidList, new UserModel.CompleteHandler() {
                        @Override
                        public void completeHanlder(Map<String, String> map, Error error) {
                            super.completeHanlder(map, error);
                            QTProgressHUD.hide();
                            if (error != null) {
                                QTToast.makeText(UserContactBookActivity.this, error.getMessage());
                            } else {
                                dataList.addAll(list);
                                Set<String> keys = map.keySet();
                                for (UserModel model: dataList) {
                                    if (keys.contains(model.getUuid())) {
                                        model.setRelation(UserModel.UserRelationStar);
                                    } else {
                                        model.setRelation(UserModel.UserRelationDefault);
                                    }
                                }
                                adapter.setNewData(dataList);
                                if (list.size() == 0) {
                                    adapter.setEmptyView(emptyView);
                                }
                            }
                        }
                    });
                }
            }
        });
    }

    private void starOrUnStarAction(final UserModel model) {
        String action = Marcos.STAR_ACTION_FOR_STAR;
        if (model.getRelation() == UserModel.UserRelationStar) {
            action = Marcos.STAR_ACTION_FOR_UNSTAR;
        }
        String userUUID = UserInfo.sharedInstance().getUuid();
        UserModel.requestForStarOrUnStar(userUUID, model.getUuid(), action,
                new UserModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (error != null) {
                    QTToast.makeText(UserContactBookActivity.this, error.getMessage());
                } else {
                    if (model.getRelation() == UserModel.UserRelationStar) {
                        model.setRelation(UserModel.UserRelationDefault);
                    } else {
                        model.setRelation(UserModel.UserRelationStarAndBeStar);
                    }
                }
                adapter.notifyDataSetChanged();
            }
        });
    }
}
