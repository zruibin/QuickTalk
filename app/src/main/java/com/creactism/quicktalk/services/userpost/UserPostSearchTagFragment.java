package com.creactism.quicktalk.services.userpost;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTProgressHUD;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.ColorUtil;
import com.creactism.quicktalk.util.DLog;
import com.creactism.quicktalk.util.StringUtil;

import java.util.List;

import static android.content.Context.INPUT_METHOD_SERVICE;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class UserPostSearchTagFragment extends UserPostListFragment {

    private EditText searchField;
    private Button cancelButton;
    private View emptyView;
    private String searchText;
    private boolean showSearchHeader = true;

    public void setSearchText(String searchText) {
        this.searchText = searchText;
    }

    public void setShowSearchHeader(boolean showSearchHeader) {
        this.showSearchHeader = showSearchHeader;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View parentView = super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.frag_userpost_search_tag, null);
        LinearLayout linearLayout = (LinearLayout)view.findViewById(R.id.frag_userpost_search_tag_layout);
        linearLayout.addView(parentView);

        this.searchField = (EditText)view.findViewById(R.id.frag_userpost_search_tag_field);
        this.cancelButton = (Button)view.findViewById(R.id.frag_userpost_search_tag_cancel);

        Drawable searchEditDraw = getResources().getDrawable(R.mipmap.search);
        searchEditDraw.setBounds(0, 0, 30, 30);
        this.searchField.setCompoundDrawables(searchEditDraw, null, null, null);
        this.searchField.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                //是否是回车键
                if (keyCode == KeyEvent.KEYCODE_ENTER && event.getAction() == KeyEvent.ACTION_DOWN) {
                    //隐藏键盘
                    ((InputMethodManager)getActivity().getSystemService(INPUT_METHOD_SERVICE))
                            .hideSoftInputFromWindow(getActivity().getCurrentFocus()
                                    .getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
                    //搜索
                    searchAction();
                }
                return false;
            }
        });

        this.cancelButton.setTextColor(ColorUtil.getColorStateList(
                ColorUtil.getResourcesColor(getActivity().getBaseContext(), R.color.QuickTalk_NAVBAR_TINT_COLOR),
                ColorUtil.getResourcesColor(getActivity().getBaseContext(), R.color.QuickTalk_MAIN_COLOR), 0, 0));
        this.cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().finish();
            }
        });

        this.emptyView = getLayoutInflater().inflate(R.layout.layout_empty_view, (ViewGroup)this.recyclerView.getParent(), false);

        RelativeLayout relativeLayout = (RelativeLayout)view.findViewById(R.id.frag_userpost_search_tag_header);
        if (this.showSearchHeader) {
            relativeLayout.setVisibility(View.VISIBLE);
        } else {
            relativeLayout.setVisibility(View.GONE);
        }

        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        if (this.showSearchHeader == false) {
            loadData();
        } else { //搜索则不可下拉刷新
            this.refreshLayout.setEnabled(false);
        }
    }

    private void searchAction() {
        this.searchText = this.searchField.getText().toString();
        if (this.searchText.length() == 0) {
            return;
        }
        if (StringUtil.containsEmoji(this.searchText)) {
            QTToast.makeText(getActivity(), "暂不支持Emoji表情");
            return;
        }
        this.index = 1;
        this.dataList.clear();
        loadData();
    }

    @Override
    protected void loadData() {
        super.loadData();
        if (searchText.length() == 0) {
            return;
        }
        String userUUID = UserInfo.sharedInstance().getUuid();
        QTProgressHUD.showHUD(getActivity());
        UserPostModel.requestTagForUserPostData(index, searchText, userUUID, new UserPostModel.CompleteHandler() {
            @Override
            public void completeHanlder(List<UserPostModel> list, Error error) {
                super.completeHanlder(list, error);
                QTProgressHUD.hide();
                refreshLayout.setRefreshing(false);
                userPostAdapter.loadMoreComplete();
                if (error != null) {
                    QTToast.makeText(getActivity(), error.getMessage());
                } else {
                    if (index == 1) {
                        userPostAdapter.setNewData(list);
                        if (list.size() == 0 && showSearchHeader) {
                            userPostAdapter.setEmptyView(emptyView);
                        }
                    } else {
                        userPostAdapter.addData(list);
                    }
                    if (list.size() < 10) {
                        userPostAdapter.loadMoreEnd();
                    }
                    dataList.addAll(list);
                }
            }
        });


    }
}
