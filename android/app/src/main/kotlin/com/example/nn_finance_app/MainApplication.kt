package com.example.nn_finance_app

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setApiKey("bea398bc-3613-4ef4-ab35-2a230e727134")
        MapKitFactory.setLocale("ru_RU")
    }
}
