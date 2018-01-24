package com.creactism.quicktalk.services.user.adapter;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.creactism.quicktalk.R;

/**
 * Created by ruibin.chow on 24/01/2018.
 */

public class UserStarOrFansAdapter extends BaseQuickAdapter <String, BaseViewHolder>  {

    public UserStarOrFansAdapter() {
        super(R.layout.frag_user_item, null);
    }

    @Override
    protected void convert(BaseViewHolder helper, final String model) {

    }
}
