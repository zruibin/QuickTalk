package com.creactism.quicktalk.services.userpost;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.components.Navigationbar;
import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class RecommendFragment extends Fragment {

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
//        DLog.debug(  "RecommendFragment on onAttach: ......");
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        DLog.debug(  "RecommendFragment on onCreate: ....");
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
//        DLog.debug(    "RecommendFragment on onCreateView: .....");

        View view = inflater.inflate(R.layout.fragment_recommend, container, false);

        Navigationbar navigationbar = (Navigationbar)view.findViewById(R.id.recommend_navigationbar);
        navigationbar.setTitle("第二项");
        navigationbar.setTitleSize(16);
        navigationbar.setTitleColor(Color.BLACK);
        navigationbar.setCenterClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getActivity().getApplicationContext(), "第二项", Toast.LENGTH_SHORT).show();
            }
        });


        navigationbar.setActionTextColor(Color.BLACK);
        navigationbar.addAction(new Navigationbar.TextAction("发布") {
            @Override
            public void performAction(View view) {
                Toast.makeText(getActivity().getApplicationContext(), "点击了发布", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent();
                intent.setClass(getActivity().getApplicationContext(), AddUserPostActivity.class);
                startActivity(intent);
            }
        });

        return view;
//        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
//        DLog.debug(    "RecommendFragment on onViewCreated: ....");
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
//        DLog.debug(    "RecommendFragment on onActivityCreated: ...");
    }

    @Override
    public void onStart() {
        super.onStart();
//        DLog.debug(    "RecommendFragment on onStart: ");
    }

    @Override
    public void onResume() {
        super.onResume();
//        DLog.debug(    "RecommendFragment on onResume: ");
    }

    @Override
    public void onPause() {
        super.onPause();
//        DLog.debug(    "RecommendFragment on onPause: ");
    }

    @Override
    public void onStop() {
        super.onStop();
//        DLog.debug(    "RecommendFragment on onStop: ...");
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
//        DLog.debug(    "RecommendFragment on onDestroyView: ");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
//        DLog.debug(    "RecommendFragment on onDestroy: ");
    }

    @Override
    public void onDetach() {
        super.onDetach();
//        DLog.debug(    "RecommendFragment on onDetach: ...");
    }
}
