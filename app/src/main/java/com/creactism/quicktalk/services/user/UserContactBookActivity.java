package com.creactism.quicktalk.services.user;

import android.database.Cursor;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.RecyclerView;

import com.creactism.quicktalk.BaseActivity;
import com.creactism.quicktalk.R;
import com.creactism.quicktalk.util.DLog;

/**
 * Created by ruibin.chow on 25/01/2018.
 */

public class UserContactBookActivity extends BaseActivity {

    private SwipeRefreshLayout refreshLayout;
    private RecyclerView recyclerView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("通讯录");
        this.navigationBar.setDefaultBackAction(this);

        this.refreshLayout = (SwipeRefreshLayout)findViewById(R.id.activity_user_contact_book_refresh);
        this.recyclerView = (RecyclerView)findViewById(R.id.activity_user_contact_book_recyclerview);

        queryContactPhoneNumber();
    }

    private void queryContactPhoneNumber() {
        String[] cols = {ContactsContract.PhoneLookup.DISPLAY_NAME, ContactsContract.CommonDataKinds.Phone.NUMBER};
        Cursor cursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                cols, null, null, null);
        for (int i = 0; i < cursor.getCount(); i++) {
            cursor.moveToPosition(i);
            // 取得联系人名字
            int nameFieldColumnIndex = cursor.getColumnIndex(ContactsContract.PhoneLookup.DISPLAY_NAME);
            int numberFieldColumnIndex = cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER);
            String name = cursor.getString(nameFieldColumnIndex);
            String number = cursor.getString(numberFieldColumnIndex);
            DLog.info(name + ": " + number);
        }
    }
}
