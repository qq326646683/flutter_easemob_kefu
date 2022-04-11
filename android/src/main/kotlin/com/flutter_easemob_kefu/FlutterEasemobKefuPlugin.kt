package com.flutter_easemob_kefu

import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.text.TextUtils
import androidx.annotation.NonNull
import com.hyphenate.chat.ChatClient
import com.hyphenate.helpdesk.Error
import com.hyphenate.helpdesk.callback.Callback
import com.hyphenate.helpdesk.easeui.UIProvider
import com.hyphenate.helpdesk.easeui.util.IntentBuilder
import com.hyphenate.helpdesk.model.ContentFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


public class FlutterEasemobKefuPlugin : FlutterPlugin, MethodCallHandler {
    val TAG = "FlutterEasemobKefuPlugin-->"
    private lateinit var channel: MethodChannel
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "flutter_easemob_kefu"
        )
        channel.setMethodCallHandler(this)
        PluginContext.context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "init" -> initKefu(
                call.argument<String>("appKey")!!,
                call.argument<String>("tenantId")!!
            )
            "register" -> register(
                call.argument<String>("username")!!,
                call.argument<String>("password")!!,
                result
            )
            "login" -> login(
                call.argument<String>("username")!!,
                call.argument<String>("password")!!,
                result
            )
            "isLogin" -> result.success(ChatClient.getInstance().isLoggedInBefore)
            "logout" -> logout(result)
            "jumpToPage" -> jumpToPage(
                call.argument<String>("imNumber")!!,
                call.argument<String>("email")!!,
                call.argument<String>("queueName")!!,
                call.argument<String>("titleName")!!,
                call.argument<Boolean>("showUserNick")!!
            )
            else -> result.notImplemented()
        }
    }

    private fun initKefu(@NonNull appKey: String, @NonNull tenantId: String) {
        PluginContext.context?.let {
            ChatClient.getInstance()
                .init(it, ChatClient.Options().setAppkey(appKey).setTenantId(tenantId))
            // Kefu EaseUI的初始化
            UIProvider.getInstance().init(it)
        }

    }

    private fun register(
        @NonNull username: String,
        @NonNull password: String,
        @NonNull result: Result
    ) {
        ChatClient.getInstance().register(username, password, object : Callback {
            override fun onSuccess() {
                backDataToFlutter(result, true)
            }

            override fun onError(code: Int, error: String?) {
                println("$TAG register username:$username code:$code, error: $error")
                backDataToFlutter(result, code == Error.USER_ALREADY_EXIST)
            }

            override fun onProgress(progress: Int, status: String?) {
            }

        })
    }

    private fun login(
        @NonNull username: String,
        @NonNull password: String,
        @NonNull result: Result
    ) {
        ChatClient.getInstance().login(username, password, object : Callback {
            override fun onSuccess() {
                backDataToFlutter(result, true)
            }

            override fun onError(code: Int, error: String?) {
                println("$TAG login username:$username code:$code, error: $error")
                backDataToFlutter(result, code == Error.USER_ALREADY_LOGIN)
            }

            override fun onProgress(progress: Int, status: String?) {
            }

        })
    }

    private fun logout(@NonNull result: Result) {
        ChatClient.getInstance().logout(true, object : Callback {
            override fun onSuccess() {
                backDataToFlutter(result, true)
            }

            override fun onError(code: Int, error: String?) {
                println("$TAG logout code:$code, error: $error")
                backDataToFlutter(result, false)
            }

            override fun onProgress(progress: Int, status: String?) {
            }

        })
    }

    private fun jumpToPage(
        @NonNull imNumber: String,
        email: String,
        queueName: String,
        titleName: String,
        showUserNick: Boolean
    ) {
        val intentBuilder = IntentBuilder(PluginContext.context)
        intentBuilder.setServiceIMNumber(imNumber)////获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
        intentBuilder.setShowUserNick(showUserNick)
        if (!TextUtils.isEmpty(email)) {
            intentBuilder.setScheduleAgent(ContentFactory.createAgentIdentityInfo(email)) //需填写正确的客服的邮箱地址
        }
        if (!TextUtils.isEmpty(queueName)) {
            intentBuilder.setScheduleQueue(ContentFactory.createQueueIdentityInfo(queueName)) //需填写正确的技能组名称
        }
        if (!TextUtils.isEmpty(titleName)) {
            intentBuilder.setTitleName(titleName)
        }
        val intent: Intent = intentBuilder.build().setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        PluginContext.context?.startActivity(intent)
    }

    private fun backDataToFlutter(@NonNull result: Result, data: Any) {
        uiThreadHandler.post {
            result.success(data)
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
