package com.creactism.quicktalk.components.menu;

import android.graphics.drawable.Drawable;

/**
 * Created by ruibin.chow on 25/01/2018.
 */

public class IconMenuItem {

    private Drawable icon;
    private String title;

    public IconMenuItem(Drawable icon, String title) {
        this.icon = icon;
        this.title = title;
    }

    public Drawable getIcon() {
        return icon;
    }

    public void setIcon(Drawable icon) {
        this.icon = icon;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
