package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.components.RecycleViewDivider;
import com.creactism.quicktalk.services.user.UserActivity;
import com.creactism.quicktalk.services.userpost.adapter.UserPostAdapter;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.DLog;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class UserPostListFragment extends BaseFragment {

    private LinearLayoutManager layoutManager;
    protected RecyclerView recyclerView;
    protected SwipeRefreshLayout refreshLayout;
    protected List<UserPostModel> dataList;
    protected UserPostAdapter userPostAdapter;
    protected int index = 1;
    protected boolean showHeader = false;
    protected boolean showFooter = false;
    protected View headerView = null;
    protected View footerView = null;

    @Override
    public void onDestroy() {
        super.onDestroy();
        DLog.error("UserPostListFragment->onDestroy...");

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle
            savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.frag_userpost_list, null);
        this.recyclerView = (RecyclerView)view.findViewById(R.id.frag_userpost_list_recyclerview);
        this.refreshLayout = (SwipeRefreshLayout)view.findViewById(R.id.frag_userpost_list_refresh);
        this.dataList = new ArrayList<UserPostModel>();

        initSubView(view);

        return view;
    }

    private void initSubView(View view) {
        this.layoutManager = new LinearLayoutManager(getActivity());
        this.recyclerView.setLayoutManager(this.layoutManager);
//        this.recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(),DividerItemDecoration.VERTICAL));
        this.recyclerView.addItemDecoration(new RecycleViewDivider(getActivity(),
                LinearLayoutManager.VERTICAL, 1, getResources().getColor(R.color.QuickTalk_VIEW_BG_COLOR)));
        this.refreshLayout.setColorSchemeColors(this.getActivity().getResources().getColor(R.color.QuickTalk_NAVBAR_BG_COLOR));
        this.refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            public void onRefresh() {
                userPostAdapter.setEnableLoadMore(false);//这里的作用是防止下拉刷新的时候还可以上拉加载
                index = 1;
                dataList.clear();
                loadData();
            }
        });

        this.userPostAdapter = new UserPostAdapter();
        this.userPostAdapter.setActivity(this.getActivity());
        if (this.showHeader) {
            this.headerView = getHeaderView();
            this.userPostAdapter.addHeaderView(this.headerView);
        }
        if (this.showFooter) {

        }
        this.userPostAdapter.setItemHandler(new UserPostAdapter.OnUserPostItemHandler() {
            public void onInfoHandler(UserPostModel model) {
                DLog.debug(model.getNickname());
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserActivity.class);
                intent.putExtra("userUUID", model.getUserUUID());
                intent.putExtra("nickname", model.getNickname());
                startActivity(intent);
            }
            public void onArrowHandler(UserPostModel model) {
                arrowHandlerAction(model);
            }
            public void onHrefHandler(UserPostModel model) {
                DLog.debug(model.getTitle());
                addReadCountAction(model);
            }
            public void onLikeActionHandler(UserPostModel model) {
                likeOrUnLikeAction(model);
            }
            public void onCommentHandler(UserPostModel model) {
                DLog.debug(model.getTitle());
                addReadCountAction(model);
            }
            public void onTagActionHandler(UserPostModel model, int tagIndex) {
                String tag = model.getTagList().get(tagIndex);
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserPostSearchTagActivity.class);
                intent.putExtra("tag", tag);
                startActivity(intent);
            }
            public void onLikeIconActionHandler(UserPostModel model, int likeIndex) {
                UserPostModel.UserPostLikeModel likeModel = model.getLikeList().get(likeIndex);
                Intent intent = new Intent().setClass(getActivity().getBaseContext(), UserActivity.class);
                intent.putExtra("userUUID", likeModel.getUserUUID());
                intent.putExtra("nickname", likeModel.getNickname());
                startActivity(intent);
            }
        });

        this.userPostAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                ++index;
                loadData();
            }
        }, this.recyclerView);

        this.userPostAdapter.openLoadAnimation(); // 一行代码搞定（默认为渐显效果）
        // 默认提供5种方法（渐显、缩放、从下到上，从左到右、从右到左）
//        this.userPostAdapter.openLoadAnimation(BaseQuickAdapter.SLIDEIN_LEFT);
        this.recyclerView.setAdapter(this.userPostAdapter);
        this.userPostAdapter.disableLoadMoreIfNotFullPage();

        this.userPostAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {

            }
        });

        this.recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
//                DLog.debug("offsetY: " + String.valueOf(recyclerView.computeVerticalScrollOffset()));
            }
        });

    }

    protected void loadData() {}

    private View getHeaderView() {
        /**haderView中子类不能是View类型*/
        View headerView = getLayoutInflater().
                inflate(R.layout.frag_userpost_list_header, (ViewGroup)this.recyclerView.getParent(), false);
        return headerView;
    }

    private void likeOrUnLikeAction(final UserPostModel model) {
        if (UserInfo.sharedInstance().checkLoginStatus(getActivity()) == false) {
            return;
        }

        String action = Marcos.LIKE_ACTION_AGREE;
        if (model.isLiked() == true) {
            action = Marcos.LIKE_ACTION_DISAGREE;
        }

        String userUUID = UserInfo.sharedInstance().getUuid();
        UserPostModel.requestForUserPostLikeOrUnLike(userUUID, model.getUuid(), action,
                new UserPostModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (error != null) {
                    QTToast.makeText(getActivity(), error.getMessage());
                } else {
                    List<UserPostModel.UserPostLikeModel> likeModelList = model.getLikeList();
                    if (model.isLiked()) {
                        for (UserPostModel.UserPostLikeModel likeModel : likeModelList) {
                            if (likeModel.getUserUUID().equals(UserInfo.sharedInstance().getUuid())) {
                                likeModelList.remove(likeModel);
                            }
                        }
                    } else {
                        UserPostModel.UserPostLikeModel likeModel = new UserPostModel.UserPostLikeModel();
                        likeModel.setUserId(UserInfo.sharedInstance().getId());
                        likeModel.setUserUUID(UserInfo.sharedInstance().getUuid());
                        likeModel.setAvatar(UserInfo.sharedInstance().getAvatar());
                        likeModel.setNickname(UserInfo.sharedInstance().getNickname());
                        likeModelList.add(likeModel);
                    }
                    model.setLiked(!model.isLiked());
                    userPostAdapter.notifyDataSetChanged();
                }
            }
        });
    }

    protected void arrowHandlerAction(final UserPostModel model) {
        if (model.getUserUUID().equals(UserInfo.sharedInstance().getUuid())) {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setTitle("");
            String[] items = {"删除","收藏"};
            builder.setNegativeButton("取消",null);
            builder.setItems(items, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int which) {
                    switch (which){
                        case 0:
                            deleteData(model);
                            break;
                        case 1:
                            collectionAndUnCollectionData(model);
                            break;
                    }
                }
            });
            builder.show();
        } else {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setTitle("");
            String[] items = {"举报","收藏"};
            builder.setNegativeButton("取消",null);
            builder.setItems(items, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int which) {
                    switch (which){
                        case 0:
                            QTToast.makeText(getActivity(), "举报成功");
                            break;
                        case 1:
                            collectionAndUnCollectionData(model);
                            break;
                    }
                }
            });
            builder.show();
        }
    }

    protected void deleteData(final UserPostModel model) {
        DLog.debug("deleteData..");
        if (UserInfo.sharedInstance().checkLoginStatus(getActivity()) == false) {
            return;
        }
    }

    protected void collectionAndUnCollectionData(final UserPostModel model) {
        if (UserInfo.sharedInstance().checkLoginStatus(getActivity()) == false) {
            return;
        }
        String userUUID = UserInfo.sharedInstance().getUuid();
        UserPostModel.requestUserCollectionAction(model.getUuid(), userUUID,
                Marcos.COLLECTION_ACTION_ON, new UserPostModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (action) {
                    QTToast.makeText(getActivity(), "收藏成功");
                } else {
                    QTToast.makeText(getActivity(), error.getMessage());
                }
            }
        });
    }

    private void addReadCountAction(final UserPostModel model) {
        UserPostModel.requestAddUserPostReadCount(model.getUuid(), UserInfo.sharedInstance().getUuid(), null);
    }




}


