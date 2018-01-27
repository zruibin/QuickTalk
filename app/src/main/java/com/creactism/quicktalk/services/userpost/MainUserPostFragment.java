package com.creactism.quicktalk.services.userpost;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class MainUserPostFragment extends UserPostListFragment {

    private String userUUID;

    public void setUserUUID(String userUUID) {
        this.userUUID = userUUID;
    }

    @Override
    protected void loadData() {
        super.loadData();
        this.refreshLayout.setRefreshing(false);
    }
}
