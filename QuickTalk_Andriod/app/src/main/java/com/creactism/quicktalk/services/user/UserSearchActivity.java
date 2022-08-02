package com.creactism.quicktalk.services.user;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

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
import com.creactism.quicktalk.util.ColorUtil;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.StringUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 25/01/2018.
 */

public class UserSearchActivity extends BaseActivity {

    private EditText searchField;
    private Button cancelButton;
    private RecyclerView recyclerView;
    private LinearLayoutManager layoutManager;
    private List<UserModel> dataList;
    private UserStarOrFansAdapter adapter;
    private int index = 1;
    private View emptyView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.navigationBar.setVisibility(View.GONE);
        setContentView(R.layout.activity_user_search);

        this.searchField = (EditText)findViewById(R.id.activity_user_search_field);
        this.cancelButton = (Button)findViewById(R.id.activity_user_search_cancel);
        this.recyclerView = (RecyclerView)findViewById(R.id.activity_user_search_recyclerview);
        this.dataList = new ArrayList<UserModel>();

        Drawable searchEditDraw = getResources().getDrawable(R.mipmap.search);
        searchEditDraw.setBounds(0, 0, 30, 30);
        this.searchField.setCompoundDrawables(searchEditDraw, null, null, null);
        this.searchField.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                //是否是回车键
                if (keyCode == KeyEvent.KEYCODE_ENTER && event.getAction() == KeyEvent.ACTION_DOWN) {
                    //隐藏键盘
                    ((InputMethodManager) getSystemService(INPUT_METHOD_SERVICE))
                            .hideSoftInputFromWindow(UserSearchActivity.this.getCurrentFocus()
                                    .getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
                    //搜索
                    searchAction();
                }
                return false;
            }
        });

        this.cancelButton.setTextColor(ColorUtil.getColorStateList(
                ColorUtil.getResourcesColor(getBaseContext(), R.color.QuickTalk_NAVBAR_TINT_COLOR),
                ColorUtil.getResourcesColor(getBaseContext(), R.color.QuickTalk_MAIN_COLOR), 0, 0));
        this.cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        this.emptyView = getLayoutInflater().inflate(R.layout.layout_empty_view, (ViewGroup)this.recyclerView.getParent(), false);
        this.layoutManager = new LinearLayoutManager(this);
        this.recyclerView.setLayoutManager(this.layoutManager);
        this.recyclerView.addItemDecoration(new RecycleViewDivider(this,
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));

        this.adapter = new UserStarOrFansAdapter();
        this.adapter.setActivity(this);
        this.adapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                DLog.error("onLoadMoreRequested...");
                ++index;
                loadData();
            }
        }, this.recyclerView);

        this.adapter.openLoadAnimation();
        this.recyclerView.setAdapter(this.adapter);
        this.adapter.disableLoadMoreIfNotFullPage();

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
                UserModel model = dataList.get(position);
                Intent intent = new Intent().setClass(UserSearchActivity.this, UserActivity.class);
                intent.putExtra("userUUID", model.getUuid());
                intent.putExtra("nickname", model.getNickname());
                startActivity(intent);
            }
        });
    }

    private void searchAction() {
        String searchText = this.searchField.getText().toString();
        if (searchText.length() == 0) {
            return;
        }
        if (StringUtil.containsEmoji(searchText)) {
            QTToast.makeText(this, "暂不支持Emoji表情");
            return;
        }
        this.index = 1;
        this.dataList.clear();
        loadData();
    }

    private void loadData() {
        String searchText = this.searchField.getText().toString().trim();
        DLog.debug(searchText);
        if (searchText.length() == 0) {
            return;
        }
        String userUUID = UserInfo.sharedInstance().getUuid();
        QTProgressHUD.showHUD(UserSearchActivity.this);
        UserModel.requestForSearchUser(searchText, this.index, userUUID, new UserModel.CompleteHandler() {
            @Override
            public void completeHanlder(List<UserModel> list, Error error) {
                super.completeHanlder(list, error);
                QTProgressHUD.hide();
                adapter.loadMoreComplete();
                if (error != null) {
                    QTToast.makeText(UserSearchActivity.this, error.getMessage());
                } else {
                    for (UserModel model: list) {
                        if (model.getRelation() == UserModel.UserRelationStar) {
                            model.setRelation(UserModel.UserRelationStar);
                        } else {
                            model.setRelation(UserModel.UserRelationDefault);
                        }
                    }
                    if (index == 1) {
                        adapter.setNewData(list);
                        if (list.size() == 0) {
                            adapter.setEmptyView(emptyView);
                        }
                    } else {
                        adapter.addData(list);
                    }
                    if (list.size() < 10) {
                        adapter.loadMoreEnd();
                    }
                    dataList.addAll(list);
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
                    QTToast.makeText(UserSearchActivity.this, error.getMessage());
                } else {
                    if (model.getRelation() == UserModel.UserRelationStar) {
                        model.setRelation(UserModel.UserRelationDefault);
                    } else {
                        model.setRelation(UserModel.UserRelationStar);
                    }
                }
                adapter.notifyDataSetChanged();
            }
        });
    }
}
