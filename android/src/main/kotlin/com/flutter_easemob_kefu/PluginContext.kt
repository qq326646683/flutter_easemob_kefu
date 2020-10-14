package com.flutter_easemob_kefu

import android.app.Activity
import android.content.Context
import java.lang.ref.WeakReference

internal object PluginContext {

    private var weakReferenceContext: WeakReference<Context?> = WeakReference(null)
    var context: Context?
        get() = weakReferenceContext.get()
        set(value) {
            weakReferenceContext = WeakReference(value)
        }
}