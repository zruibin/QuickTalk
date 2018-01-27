package com.creactism.quicktalk.services.userpost;

/**
 * Created by ruibin.chow on 27/01/2018.
 */

public class CollectionUserPostFragment extends UserPostListFragment {

    @Override
    protected void loadData() {
        super.loadData();
        this.refreshLayout.setRefreshing(false);
    }
}
