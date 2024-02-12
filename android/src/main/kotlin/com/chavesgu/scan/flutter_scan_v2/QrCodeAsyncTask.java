package com.chavesgu.scan.flutter_scan_v2;

import static android.content.Context.VIBRATOR_SERVICE;

import android.os.AsyncTask;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;

import java.lang.ref.WeakReference;

public class QrCodeAsyncTask extends AsyncTask<String, Integer, String> {
    private final WeakReference<FlutterScanV2Plugin> mWeakReference;
    private final String path;

    public QrCodeAsyncTask(FlutterScanV2Plugin plugin, String path) {
        super();
        mWeakReference = new WeakReference<>(plugin);
        this.path = path;
    }

    @Override
    protected String doInBackground(String... strings) {
        // 解析二维码/条码
        return QRCodeDecoder.decodeQRCode(mWeakReference.get().getFlutterPluginBinding().getApplicationContext(), path);
    }

    @Override
    protected void onPostExecute(String s) {
        super.onPostExecute(s);
        //识别出图片二维码/条码，内容为s
        FlutterScanV2Plugin plugin = (FlutterScanV2Plugin) mWeakReference.get();
        plugin.endOfTask(s);

        Vibrator myVib = (Vibrator) plugin.getFlutterPluginBinding().getApplicationContext().getSystemService(VIBRATOR_SERVICE);
        if (myVib != null) {
            if (Build.VERSION.SDK_INT >= 26) {
                myVib.vibrate(VibrationEffect.createOneShot(50, VibrationEffect.DEFAULT_AMPLITUDE));
            } else {
                myVib.vibrate(50);
            }
        }
    }
}
