package com.creactism.quicktalk.services;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 12/01/2018.
 */

public class RecommendFragment extends Fragment {

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        DLog.debug(  "RecommendFragment on onAttach: ......");
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DLog.debug(  "RecommendFragment on onCreate: ....");
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        DLog.debug(    "RecommendFragment on onCreateView: .....");
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        DLog.debug(    "RecommendFragment on onViewCreated: ....");
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        DLog.debug(    "RecommendFragment on onActivityCreated: ...");
    }

    @Override
    public void onStart() {
        super.onStart();
        DLog.debug(    "RecommendFragment on onStart: ");
    }

    @Override
    public void onResume() {
        super.onResume();
        DLog.debug(    "RecommendFragment on onResume: ");
    }

    @Override
    public void onPause() {
        super.onPause();
        DLog.debug(    "RecommendFragment on onPause: ");
    }

    @Override
    public void onStop() {
        super.onStop();
        DLog.debug(    "RecommendFragment on onStop: ...");
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        DLog.debug(    "RecommendFragment on onDestroyView: ");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        DLog.debug(    "RecommendFragment on onDestroy: ");
    }

    @Override
    public void onDetach() {
        super.onDetach();
        DLog.debug(    "RecommendFragment on onDetach: ...");
    }
}
