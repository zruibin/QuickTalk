package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.services.user.UserActivity;
import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class StarUserPostFragment extends BaseFragment {

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        this.getActivity().setTitle("UserPost....");
//        QTCache.sharedCache().put("testCache", "testCacheValue....");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
//        DLog.debug(  "StarUserPostFragment onCreateView: .....");
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.frag_userpost, container, false);
        TextView textView = (TextView)view.findViewById(R.id.frag_userpost_text);
        textView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(getActivity().getApplicationContext(), UserActivity.class);
                startActivity(intent);
            }
        });

//        Navigationbar navigationbar = (Navigationbar)view.findViewById(R.id.userpost_navigationbar);
//        navigationbar.setDefaulteTheme(this.getActivity());
//        navigationbar.setLeftText("取消");
//        navigationbar.setLeftClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                DLog.info("left click...");
//                Toast.makeText(getActivity().getApplicationContext(), "取消", Toast.LENGTH_SHORT).show();
//                final SVProgressHUD mSVProgressHUD = new SVProgressHUD(getActivity());
//                mSVProgressHUD.showWithStatus("加载中...");
//                new Handler().postDelayed(new Runnable() {
//                    @Override
//                    public void run() {
//                        mSVProgressHUD.dismiss();
//
//
//                    }
//                },1000);
//            }
//        });

        return view;
    }

}
