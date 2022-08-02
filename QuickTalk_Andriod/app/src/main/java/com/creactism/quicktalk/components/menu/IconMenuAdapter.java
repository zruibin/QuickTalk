package com.creactism.quicktalk.components.menu;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.creactism.quicktalk.R;
import com.creactism.quicktalk.util.DensityUtil;
import com.creactism.quicktalk.util.DrawableUtil;
import com.skydoves.powermenu.MenuBaseAdapter;

/**
 * Created by ruibin.chow on 25/01/2018.
 */

public class IconMenuAdapter extends MenuBaseAdapter<IconMenuItem> {

    @Override
    public View getView(int index, View view, ViewGroup viewGroup) {
        final Context context = viewGroup.getContext();

        if(view == null) {
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inflater.inflate(R.layout.layout_menu_item, viewGroup, false);
        }

        IconMenuItem item = (IconMenuItem)getItem(index);
        final ImageView icon = view.findViewById(R.id.layout_menu_item_icon);
        Drawable iconDrawable = item.getIcon();
        iconDrawable = DrawableUtil.tintDrawable(iconDrawable, Color.BLACK);
        icon.setImageDrawable(iconDrawable);
        final TextView title = view.findViewById(R.id.layout_menu_item_text);
        title.setText(item.getTitle());
        return view;
    }
}
