package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.bigkoo.svprogresshud.SVProgressHUD;
import com.creactism.quicktalk.BaseFragment;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.Navigationbar;
import com.creactism.quicktalk.modules.NotificationCenter;
import com.creactism.quicktalk.services.user.UserActivity;
import com.creactism.quicktalk.util.DLog;

import static com.creactism.quicktalk.modules.NotificationCenter.*;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class UserPostFragment extends BaseFragment {

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        NotificationCenter.defaultCenter().addObserver(this, "testNotification", new NotificationCenter.SelectorHandler(){
            @Override
            public void handler(Object object) {
                DLog.warn("NotificationCenter handler: " + (String)object);
            }
        });
    }

    @Override
    public void onDetach() {
        super.onDetach();
        NotificationCenter.defaultCenter().removeObserver(this.getActivity(), "testNotification");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
//        DLog.debug(  "UserPostFragment onCreateView: .....");
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.frag_userpost, container, false);

        Navigationbar navigationbar = (Navigationbar)view.findViewById(R.id.userpost_navigationbar);
//        navigationbar.setLeftImageResource(R.mipmap.back_green);
        navigationbar.setLeftText("取消");
        navigationbar.setLeftTextColor(Color.BLACK);
        navigationbar.setLeftClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DLog.info("left click...");
                Toast.makeText(getActivity().getApplicationContext(), "取消", Toast.LENGTH_SHORT).show();
                final SVProgressHUD mSVProgressHUD = new SVProgressHUD(getActivity());
                mSVProgressHUD.showWithStatus("加载中...");
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        mSVProgressHUD.dismiss();

                        Intent intent = new Intent();
                        intent.setClass(getActivity().getApplicationContext(), UserActivity.class);
                        startActivity(intent);

                    }
                },1000);
            }
        });

        return view;
    }

}
