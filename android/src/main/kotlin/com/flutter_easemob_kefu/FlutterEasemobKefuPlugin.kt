package com.flutter_easemob_kefu

import android.content.Intent
import androidx.annotation.NonNull;
import com.hyphenate.chat.ChatClient
import com.hyphenate.helpdesk.easeui.UIProvider
import com.hyphenate.helpdesk.easeui.util.IntentBuilder

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import javax.security.auth.callback.Callback

public class FlutterEasemobKefuPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_easemob_kefu")
        channel.setMethodCallHandler(this)
        PluginContext.context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "init" -> initKefu(call.argument<String>("appKey"), call.argument<String>("tenantId"))
            "register" -> ChatClient.getInstance().register(call.argument<String>("username"), call.argument<String>("password"), null)
            "login" -> ChatClient.getInstance().login(call.argument<String>("username"), call.argument<String>("password"), null)
            "isLogin" -> result.success(ChatClient.getInstance().isLoggedInBefore)
            "logout" -> ChatClient.getInstance().logout(true, null)
            "jumpToPage" -> {
                val intent: Intent = IntentBuilder(PluginContext.context).setServiceIMNumber(call.argument<String>("imNumber")).build().setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                PluginContext.context?.startActivity(intent)
            }
            else -> result.notImplemented()
        }
    }

    private fun initKefu(appKey: String?, tenantId: String?) {
        PluginContext.context?.let {
            ChatClient.getInstance().init(it, ChatClient.Options().setAppkey(appKey).setTenantId(tenantId))
            // Kefu EaseUI的初始化
            UIProvider.getInstance().init(it)
        }

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
