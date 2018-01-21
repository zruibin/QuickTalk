package com.creactism.quicktalk.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.Minutes;
import org.joda.time.Seconds;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

/**
 * Created by ruibin.chow on 21/01/2018.
 */

public class StringUtil {

    /**32小写md5加密*/
    public static String md5(String plain) {
        String re_md5 = new String();
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(plain.getBytes());
            byte b[] = md.digest();
            int i;
            StringBuffer buf = new StringBuffer("");
            for (int offset = 0; offset < b.length; offset++) {
                i = b[offset];
                if (i < 0)
                    i += 256;
                if (i < 16)
                    buf.append("0");
                buf.append(Integer.toHexString(i));
            }
            re_md5 = buf.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return re_md5;
    }

    /**日期转换，几秒前，几分钟前，今天HH:mm，昨天HH:mm, MM月dd日 HH:mm, yyyy年MM月dd日 HH:mm*/
    public static String formatDate(String date){
        //把时区转换为东8区
        TimeZone timeZone = TimeZone.getTimeZone("GMT+8");
        DateTimeZone.setDefault(DateTimeZone.forTimeZone(timeZone));

        DateTime nowDateTime = DateTime.now();
        DateTimeFormatter format = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        DateTime dateTime = DateTime.parse(date, format);

        int seconds = Seconds.secondsBetween(dateTime,nowDateTime).getSeconds();
        if (seconds < 60) {
            return seconds + "秒前";
        }

        int minutes = Minutes.minutesBetween(dateTime,nowDateTime).getMinutes();
        if (minutes < 60) {
            return minutes + "分钟前";
        }

        int day = nowDateTime.getDayOfYear() - dateTime.getDayOfYear();
        int year = nowDateTime.getYear() - dateTime.getYear();
        if (year < 1 && day < 1) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("今天 HH:mm");
            return simpleDateFormat.format(dateTime.toDate());
        }

        if (year < 1 && day < 2) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("昨天 HH:mm");
            return simpleDateFormat.format(dateTime.toDate());
        }
        if (year < 1) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM月dd日 HH:mm");
            return simpleDateFormat.format(dateTime.toDate());
        }

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy年MM月dd日 HH:mm");
        return simpleDateFormat.format(dateTime.toDate());
    }

    private static boolean regexMatcher(String string, String regex) {
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(string);
        return m.matches();
    }

    /**是否为手机号*/
    public static boolean isMobileNumber(String mobiles) {
        String regex = "^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(17[013678])|(18[0,5-9]))\\d{8}$";
        return regexMatcher(mobiles, regex);
    }

    /**是否为email*/
    public static boolean isEmail(String email) {
        String regex = "^[A-Za-z]{1,40}@[A-Za-z0-9]{1,40}\\.[A-Za-z]{2,3}$";
        return regexMatcher(email, regex);
    }

    /**是不是网址url*/
    public static boolean isValidUrl(String url) {
        String regex = "^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
        return regexMatcher(url, regex);
    }

    /**是否是中文*/
    public static boolean isValidChinese(String string) {
        String regex = "^[\\u4e00-\\u9fa5]+$";
        return regexMatcher(string, regex);
    }

    /**提取内容中的网址*/
    public static String pickupURLString(String string) {
        String regex = "\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        Matcher m = Pattern.compile(regex).matcher(string);
        String url = null;
        while(m.find()){
            url = m.group();
        }
        return url;
    }

    /**数字转换*/
    public static String countTransition(long count) {
        if (count < 0) {
            return "0";
        }
        if (count < 10000) {
            return String.valueOf(count);
        } else {
            return String.valueOf(count/10000) + "." + String.valueOf(count%10000/10000) + "万";
        }
    }

}
