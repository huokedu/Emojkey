// Copyright (c) Microsoft. All rights reserved.

package com.example.t_jiju.emojifacedemo.helper;

import android.app.Application;
import android.content.Context;

import com.microsoft.projectoxford.face.FaceServiceClient;
import com.example.t_jiju.emojifacedemo.R;

public class SampleApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        mContext = this;
        mFaceServiceClient = new FaceServiceClient(getString(R.string.subscription_key));
    }

    public static Context getContext() {
        return mContext;
    }

    public static FaceServiceClient getFaceServiceClient() {
        return mFaceServiceClient;
    }

    private static Context mContext;

    private static FaceServiceClient mFaceServiceClient;
}
