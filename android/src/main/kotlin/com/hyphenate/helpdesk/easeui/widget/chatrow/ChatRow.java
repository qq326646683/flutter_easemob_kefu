package com.hyphenate.helpdesk.easeui.widget.chatrow;


import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.flutter_easemob_kefu.R;
import com.hyphenate.chat.ChatClient;
import com.hyphenate.chat.Message;
import com.hyphenate.helpdesk.Error;
import com.hyphenate.helpdesk.callback.Callback;
import com.hyphenate.helpdesk.easeui.UIProvider;
import com.hyphenate.helpdesk.easeui.adapter.MessageAdapter;
import com.hyphenate.helpdesk.easeui.util.UserUtil;
import com.hyphenate.helpdesk.easeui.widget.MessageList;
import com.hyphenate.helpdesk.easeui.widget.ToastHelper;
import com.hyphenate.util.DateUtils;
import com.hyphenate.util.TimeInfo;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public abstract class ChatRow extends LinearLayout {

    protected static final String TAG = ChatRow.class.getSimpleName();

    protected LayoutInflater inflater;
    protected Context context;
    protected BaseAdapter adapter;
    protected Message message;
    protected int position;

    protected TextView timeStampView;
    protected ImageView userAvatarView;
    protected View bubbleLayout;
    protected TextView usernickView;

    protected TextView percentageView;
    protected ProgressBar progressBar;
    protected ImageView statusView;
    protected Activity activity;

//    protected TextView ackedView;
//    protected TextView deliveredView;

    protected Callback messageSendCallback;
    protected Callback messageReceiveCallback;

    protected MessageList.MessageListItemClickListener itemClickListener;

    public ChatRow(Context context, Message message, int position, BaseAdapter adapter) {
        super(context);
        this.context = context;
        this.activity = (Activity) context;
        this.message = message;
        this.position = position;
        this.adapter = adapter;
        inflater = LayoutInflater.from(context);

        initView();
    }

    private void initView() {
        onInflatView();
        timeStampView = (TextView) findViewById(R.id.timestamp);
        userAvatarView = (ImageView) findViewById(R.id.iv_userhead);
        bubbleLayout = findViewById(R.id.bubble);
        usernickView = (TextView) findViewById(R.id.tv_userid);

        progressBar = (ProgressBar) findViewById(R.id.progress_bar);
        statusView = (ImageView) findViewById(R.id.msg_status);
//        ackedView = (TextView) findViewById(R.id.tv_ack);
//        deliveredView = (TextView) findViewById(R.id.tv_delivered);

        onFindViewById();
    }

    /**
     * 根据当前message和position设置控件属性等
     *
     * @param message
     * @param position
     */
    public void setUpView(Message message, int position,
                          MessageList.MessageListItemClickListener itemClickListener) {
        this.message = message;
        this.position = position;
        this.itemClickListener = itemClickListener;

        setUpBaseView();
        onSetUpView();
        setClickListener();
    }

    private void setUpBaseView() {
        // 设置用户昵称头像，bubble背景等
        TextView timestamp = (TextView) findViewById(R.id.timestamp);
        if (timestamp != null) {
            if (position == 0) {
                timestamp.setText(getTimestampString(new Date(message.messageTime())));
                timestamp.setVisibility(View.VISIBLE);
            } else {
                // 两条消息时间离得如果稍长，显示时间
                Message prevMessage = (Message) adapter.getItem(position - 1);
                if (prevMessage != null && DateUtils.isCloseEnough(message.messageTime(), prevMessage.messageTime())) {
                    timestamp.setVisibility(View.GONE);
                } else {
                    timestamp.setText(getTimestampString(new Date(message.messageTime())));
                    timestamp.setVisibility(View.VISIBLE);
                }
            }
        }
        //设置头像和nick

        UIProvider.UserProfileProvider userInfoProvider = UIProvider.getInstance().getUserProfileProvider();

        if (userInfoProvider != null) {
            userInfoProvider.setNickAndAvatar(context, message, userAvatarView, usernickView);
        }else{
            if (message.direct() == Message.Direct.RECEIVE) {
                if (usernickView != null){
                    UserUtil.setAgentNickAndAvatar(context, message, userAvatarView, usernickView);
                }
            } else {
                UserUtil.setCurrentUserNickAndAvatar(context, userAvatarView, usernickView);
            }
        }


        if (adapter instanceof MessageAdapter) {
            if (userAvatarView != null){
                if (((MessageAdapter) adapter).isShowAvatar() && message.direct() == Message.Direct.RECEIVE){
                    userAvatarView.setVisibility(View.VISIBLE);
                }
                else{
                    userAvatarView.setVisibility(View.GONE);
                }
            }


            if (usernickView != null) {
                if (((MessageAdapter) adapter).isShowUserNick() && message.direct() == Message.Direct.RECEIVE)
                    usernickView.setVisibility(View.VISIBLE);
                else
                    usernickView.setVisibility(View.GONE);
            }
            if (bubbleLayout != null) {
                if (message.direct() == Message.Direct.SEND) {
                    if (((MessageAdapter) adapter).getMyBubbleBg() != null)
                        bubbleLayout.setBackgroundDrawable(((MessageAdapter) adapter).getMyBubbleBg());
                } else if (message.direct() == Message.Direct.RECEIVE) {
                    if (((MessageAdapter) adapter).getOtherBuddleBg() != null)
                        bubbleLayout.setBackgroundDrawable(((MessageAdapter) adapter).getOtherBuddleBg());
                }

            }

        }
    }

    public static String getTimestampString(Date var0) {
        String var1 = null;
//        String var2 = Locale.getDefault().getLanguage();
        boolean var3 = false; //var2.startsWith("zh");
        long var4 = var0.getTime();
        if (isSameDay(var4)) {
            if (var3) {
                var1 = "aa hh:mm";
            } else {
                var1 = "hh:mm aa";
            }
        } else if (isYesterday(var4)) {
            if (!var3) {
                return "Yesterday " + (new SimpleDateFormat("hh:mm aa", Locale.ENGLISH)).format(var0);
            }

            var1 = "昨天aa hh:mm";
        } else if (var3) {
            var1 = "M月d日aa hh:mm";
        } else {
            var1 = "MMM dd hh:mm aa";
        }

        return var3 ? (new SimpleDateFormat(var1, Locale.CHINESE)).format(var0) : (new SimpleDateFormat(var1, Locale.ENGLISH)).format(var0);
    }

    private static boolean isSameDay(long var0) {
        TimeInfo var2 = getTodayStartAndEndTime();
        return var0 > var2.getStartTime() && var0 < var2.getEndTime();
    }

    private static boolean isYesterday(long var0) {
        TimeInfo var2 = getYesterdayStartAndEndTime();
        return var0 > var2.getStartTime() && var0 < var2.getEndTime();
    }


    public static TimeInfo getTodayStartAndEndTime() {
        Calendar var0 = Calendar.getInstance();
        var0.set(11, 0);
        var0.set(12, 0);
        var0.set(13, 0);
        var0.set(14, 0);
        Date var1 = var0.getTime();
        long var2 = var1.getTime();
        Calendar var4 = Calendar.getInstance();
        var4.set(11, 23);
        var4.set(12, 59);
        var4.set(13, 59);
        var4.set(14, 999);
        Date var5 = var4.getTime();
        long var6 = var5.getTime();
        TimeInfo var8 = new TimeInfo();
        var8.setStartTime(var2);
        var8.setEndTime(var6);
        return var8;
    }

    public static TimeInfo getYesterdayStartAndEndTime() {
        Calendar var0 = Calendar.getInstance();
        var0.add(5, -1);
        var0.set(11, 0);
        var0.set(12, 0);
        var0.set(13, 0);
        var0.set(14, 0);
        Date var1 = var0.getTime();
        long var2 = var1.getTime();
        Calendar var4 = Calendar.getInstance();
        var4.add(5, -1);
        var4.set(11, 23);
        var4.set(12, 59);
        var4.set(13, 59);
        var4.set(14, 999);
        Date var5 = var4.getTime();
        long var6 = var5.getTime();
        TimeInfo var8 = new TimeInfo();
        var8.setStartTime(var2);
        var8.setEndTime(var6);
        return var8;
    }

    /**
     * 设置消息发送callback
     */
    protected void setMessageSendCallback() {
        if (messageSendCallback == null && message.messageStatusCallback() == null) {
            messageSendCallback = new Callback() {
                @Override
                public void onSuccess() {
                    updateView();
                }

                @Override
                public void onError(int i, String s) {
                    updateView();
                }

                @Override
                public void onProgress(final int progress, String status) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (percentageView != null && progress < 100) {
                                percentageView.setTag(progress);
                                percentageView.setText(progress + "%");
                            }

                        }
                    });
                }
            };

        }
        message.setMessageStatusCallback(messageSendCallback);
    }

    /**
     * 设置消息接收callback
     */
    protected void setMessageReceiveCallback() {
        if (messageReceiveCallback == null) {
            messageReceiveCallback = new Callback() {
                @Override
                public void onSuccess() {
                    updateView();
                }

                @Override
                public void onError(int i, String s) {
                    updateView();
                }

                @Override
                public void onProgress(final int progress, String s) {
                    activity.runOnUiThread(new Runnable() {
                        public void run() {
                            if (percentageView != null && progress < 100) {
                                percentageView.setText(progress + "%");
                            }
                        }
                    });
                }
            };
        }
        message.setMessageStatusCallback(messageReceiveCallback);
    }


    private void setClickListener() {
        if (bubbleLayout != null) {
            bubbleLayout.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    if (itemClickListener != null) {
                        if (!itemClickListener.onBubbleClick(message)) {
                            //如果listener返回false不处理这个事件，执行lib默认的处理
                            onBubbleClick();
                        }
                    }
                }
            });

            bubbleLayout.setOnLongClickListener(new OnLongClickListener() {

                @Override
                public boolean onLongClick(View v) {
                    if (itemClickListener != null) {
                        itemClickListener.onBubbleLongClick(message);
                    }
                    return true;
                }
            });
        }

        if (statusView != null) {
            statusView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    if (itemClickListener != null) {
                        itemClickListener.onResendClick(message);
                    }
                }
            });
        }

        if (userAvatarView != null) {
            userAvatarView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    if (itemClickListener != null) {
                        if (message.direct() == Message.Direct.SEND) {
                            itemClickListener.onUserAvatarClick(ChatClient.getInstance().currentUserName());
                        } else {
                            itemClickListener.onUserAvatarClick(message.from());
                        }
                    }
                }
            });
        }

    }


    protected void updateView() {
        activity.runOnUiThread(new Runnable() {
            public void run() {
                if (message.status() == Message.Status.FAIL) {
                    if (message.error() == Error.MESSAGE_INCLUDE_ILLEGAL_CONTENT) {
                        ToastHelper.show(activity, R.string.send_fail);
                    } else {
                        ToastHelper.show(activity, activity.getString(R.string.send_fail) + activity.getString(R.string.connect_failuer_toast));
                    }
                }

                onUpdateView();
            }
        });

    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        message.setMessageStatusCallback(null);
    }

    /**
     * 填充layout
     */
    protected abstract void onInflatView();

    /**
     * 查找chatrow里的控件
     */
    protected abstract void onFindViewById();

    /**
     * 消息状态改变，刷新listview
     */
    protected abstract void onUpdateView();

    /**
     * 设置更新控件属性
     */
    protected abstract void onSetUpView();

    /**
     * 聊天气泡被点击事件
     */
    protected abstract void onBubbleClick();

}