package com.creactism.quicktalk.services.userpost;

import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.creactism.quicktalk.Marcos;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.UserInfo;
import com.creactism.quicktalk.components.QTToast;
import com.creactism.quicktalk.services.userpost.model.UserPostModel;
import com.creactism.quicktalk.util.DLog;

import java.util.List;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class CollectionUserPostFragment extends UserPostListFragment {

    private View emptyView;

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.emptyView = getLayoutInflater().inflate(R.layout.layout_empty_view, (ViewGroup)this.recyclerView.getParent(), false);
        this.refreshLayout.setRefreshing(true);
        loadData();
    }

    @Override
    protected void loadData() {
        super.loadData();
        String userUUID = UserInfo.sharedInstance().getUuid();
        UserPostModel.requestCollectionData(userUUID, index, "1", new UserPostModel.CompleteHandler() {
            @Override
            public void completeHanlder(List<UserPostModel> list, Error error) {
                refreshLayout.setRefreshing(false);
                userPostAdapter.loadMoreComplete();
                if (error != null) {
                    Toast.makeText(getActivity(), error.getMessage(), Toast.LENGTH_SHORT).show();
                    return;
                }
                if (index == 1) {
                    userPostAdapter.setNewData(list);
                    if (list.size() == 0) {
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
        });
    }

    @Override
    protected void arrowHandlerAction(final UserPostModel model) {
        android.app.AlertDialog.Builder dialog = new android.app.AlertDialog.Builder(getActivity());
        dialog.setTitle("取消收藏");
        dialog.setPositiveButton("确定",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        collectionAndUnCollectionData(model);
                    }
                });
        dialog.setNegativeButton("取消", null);
        android.app.AlertDialog alertDialog = dialog.create();
        alertDialog.show();
        //属性的获取都一定是要在Dialog调用完show()方法之后，
        // 即Dialog展示出来之后。要不就会NullPointException
        alertDialog.getButton(alertDialog.BUTTON_POSITIVE).setTextColor(Color.RED);
    }

    @Override
    protected void collectionAndUnCollectionData(final UserPostModel model) {
        if (UserInfo.sharedInstance().checkLoginStatus(getActivity()) == false) {
            return;
        }
        String userUUID = UserInfo.sharedInstance().getUuid();
        UserPostModel.requestUserCollectionAction(model.getUuid(), userUUID,
                Marcos.COLLECTION_ACTION_OFF, new UserPostModel.CompleteHandler() {
            @Override
            public void completeHanlder(boolean action, Error error) {
                super.completeHanlder(action, error);
                if (action) {
                    QTToast.makeText(getActivity(), "取消收藏成功");
                    dataList.remove(model);
                    userPostAdapter.replaceData(dataList);
                    if (dataList.size() == 0) {
                        userPostAdapter.setEmptyView(emptyView);
                    }
                } else {
                    QTToast.makeText(getActivity(), error.getMessage());
                }
            }
        });
    }
}
