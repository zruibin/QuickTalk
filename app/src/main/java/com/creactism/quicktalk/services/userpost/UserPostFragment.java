package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.Toast;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.Navigationbar;
import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class UserPostFragment extends Fragment {

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
//        DLog.debug("UserPostFragment onAttach: ......");
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        DLog.debug("UserPostFragment onCreate: ....");
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
//        DLog.debug(  "UserPostFragment onCreateView: .....");
        View view = inflater.inflate(R.layout.fragment_userpost, container, false);

        Navigationbar navigationbar = (Navigationbar)view.findViewById(R.id.userpost_navigationbar);
//        navigationbar.setLeftImageResource(R.mipmap.back_green);
        navigationbar.setLeftText("取消");
        navigationbar.setLeftTextColor(Color.BLACK);
        navigationbar.setLeftClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DLog.info("left click...");
                Toast.makeText(getActivity().getApplicationContext(), "取消", Toast.LENGTH_SHORT).show();
            }
        });

        return view;
//        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
//        DLog.debug(  "UserPostFragment onViewCreated: ....");
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
//        DLog.debug(  "UserPostFragment onActivityCreated: ...");
    }

    @Override
    public void onStart() {
        super.onStart();
//        DLog.debug(  "UserPostFragment onStart: ");
    }

    @Override
    public void onResume() {
        super.onResume();
//        DLog.debug(  "UserPostFragment onResume: ");
    }

    @Override
    public void onPause() {
        super.onPause();
//        DLog.debug(  "UserPostFragment onPause: ");
    }

    @Override
    public void onStop() {
        super.onStop();
//        DLog.debug(  "UserPostFragment onStop: ...");
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
//        DLog.debug(  "UserPostFragment onDestroyView: ");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
//        DLog.debug(  "UserPostFragment onDestroy: ");
    }

    @Override
    public void onDetach() {
        super.onDetach();
//        DLog.debug(  "UserPostFragment onDetach: ...");
    }
}
