package com.example.maleem

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.Intent
import android.app.PendingIntent
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class MaleemWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            // Read data saved from Flutter
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName,R.layout.maleem_widget).apply{
                val textFromFlutterApp = widgetData.getString("text_from_flutter_app",null)
                val balance = textFromFlutterApp ?: "0.0"
                setTextViewText(R.id.text_id, "Total Balance: $$balance")
                // open Flutter app
                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
                }
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(R.id.text_id, pendingIntent)

            }

            //update widget
            appWidgetManager.updateAppWidget(appWidgetId,views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}