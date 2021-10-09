package com.cclw.scheduler;

import android.os.Environment;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.channels.FileChannel;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private String CHANNEL = "exportDbChannel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((methodCall, result) -> {
                    if(methodCall.method.equals("exportDb")){
                        String content = methodCall.argument("content");
                        try{
                            exportDb(content);
                            result.success(true);
                        }catch (Exception e){
                            result.success(false);
                            Log.e("####ExportFail: ", e.getMessage());
                        }
                    }
                });
    }

    private void exportDb(String content) throws IOException {
        FileOutputStream fos = new FileOutputStream(
                new File(Environment.getExternalStoragePublicDirectory(
                        Environment.DIRECTORY_DOWNLOADS), "scheduler.txt"));
        OutputStreamWriter os = new OutputStreamWriter(fos);
        os.write(content);
        os.close();
    }
}
