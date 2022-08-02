package com.creactism.quicktalk;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.creactism.quicktalk.util.DLog;


/**
 * Created by ruibin.chow on 14/01/2018.
 */

public class BaseFragment extends Fragment {

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
//        DLog.debug("BaseFragment onAttach: ......");
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        DLog.debug("BaseFragment onCreate: ....");
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
//        DLog.debug(  "BaseFragment onCreateView: .....");
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
//        DLog.debug(  "BaseFragment onViewCreated: ....");
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
//        DLog.debug(  "BaseFragment onActivityCreated: ...");
    }

    @Override
    public void onStart() {
        super.onStart();
//        DLog.debug(  "BaseFragment onStart: ");
    }

    @Override
    public void onResume() {
        super.onResume();
//        DLog.debug(  "BaseFragment onResume: ");
    }

    @Override
    public void onPause() {
        super.onPause();
//        DLog.debug(  "BaseFragment onPause: ");
    }

    @Override
    public void onStop() {
        super.onStop();
//        DLog.debug(  "BaseFragment onStop: ...");
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
//        DLog.debug(  "BaseFragment onDestroyView: ");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
//        DLog.debug(  "BaseFragment onDestroy: ");
    }

    @Override
    public void onDetach() {
        super.onDetach();
//        DLog.debug(  "BaseFragment onDetach: ...");
    }

}
