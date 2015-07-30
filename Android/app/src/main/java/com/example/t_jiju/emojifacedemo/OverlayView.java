package com.example.t_jiju.emojifacedemo;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.microsoft.projectoxford.face.contract.Face;
import com.microsoft.projectoxford.face.contract.FaceLandmarks;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;


/**
 * Created by t-jiju on 7/29/2015.
 */
public class OverlayView {
    public static final String TAG = "OverlayView";

    private final Activity activity;
    private ImageView view;
    private boolean isUpperView;
    private List<Integer> imageIds;
    private final Index index;
    private Bitmap bitmapBackground;
    private Face[] faces;
    private ImageView currentEmojiView;
    private OnSwipeTouchListener swipeTouchListener;

    public OverlayView(final Activity activity, int id, final boolean isUpperView) {
        this.activity = activity;
        this.isUpperView = isUpperView;
        this.view = (ImageView) activity.findViewById(id);

        this.imageIds = new ArrayList<Integer>();
        this.index = new Index();
        fillImages();

        currentEmojiView = new ImageView(activity);
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(0, 0);

        // add view to layout
        RelativeLayout rl = (RelativeLayout) activity.findViewById(R.id.image_layout);
        rl.addView(currentEmojiView, params);

        swipeTouchListener = new OnSwipeTouchListener(activity) {
            public void onSwipeTop() {
                Toast.makeText(activity, "top " + isUpperView, Toast.LENGTH_SHORT).show();
            }

            public void onSwipeRight() {
                index.increment();
                draw();
                String a = isUpperView ? "eye" : "mouth";
                Log.d(TAG, a + " " + index.getIndex());
                Toast.makeText(activity, "right " + isUpperView, Toast.LENGTH_SHORT).show();
            }

            public void onSwipeLeft() {
                index.decrement();
                draw();
                String a = isUpperView ? "eye" : "mouth";
                Log.d(TAG, a + " " + index.getIndex());
                Toast.makeText(activity, "left " + isUpperView, Toast.LENGTH_SHORT).show();
            }

            public void onSwipeBottom() {
                Toast.makeText(activity, "bottom " + isUpperView, Toast.LENGTH_SHORT).show();
            }
        };
        view.setOnTouchListener(swipeTouchListener);
    }

    public void setVisibility(int state) {
        view.setVisibility(state);
    }

    public void fillImages() {
        final R.drawable drawableResources = new R.drawable();
        final Class<R.drawable> c = R.drawable.class;
        final Field[] fields = c.getDeclaredFields();

        for (int i = 0, max = fields.length; i < max; i++) {

            /* make use of resourceId for accessing Drawables here */
            final int resourceId;
            try {
                resourceId = fields[i].getInt(drawableResources);
                String name = fields[i].getName();
                addId(resourceId, name);
            } catch (Exception e) {
                continue;
            }
        }
    }

    private void addId(int id, String name) {
        if ((isUpperView && name.startsWith("eyes")) ||
            (!isUpperView && name.startsWith("mouth")) ) {
            imageIds.add(id);
        }
    }

    public void setDrawingResource(Bitmap bitmapBackground, Face[] faces) {
        this.bitmapBackground = bitmapBackground;
        this.faces = faces;
        draw();
    }

    public void draw() {
        FaceLandmarks fl = faces[0].faceLandmarks;
        CoordinateInfo info = new CoordinateInfo(fl);
        DisplayMetrics metrics = view.getContext().getResources().getDisplayMetrics();
        double width = (double) info.width / bitmapBackground.getWidth();
        double left = (double) info.left / bitmapBackground.getWidth();
        double top = (double) info.top / bitmapBackground.getHeight();
        double height = (double) info.height / bitmapBackground.getHeight();

        makeEmoji((int) (metrics.widthPixels * width),
                (int) (metrics.heightPixels * height),
                (int) (metrics.widthPixels * left),
                (int) (metrics.heightPixels * top));
    }

    private void makeEmoji(int width, int height, int left, int top) {
        // remove emoji
        ViewGroup parent = (ViewGroup) currentEmojiView.getParent();
        int index = parent.indexOfChild(currentEmojiView);
        parent.removeView(currentEmojiView);

        currentEmojiView = (ImageView) (isUpperView ?
        activity.findViewById(R.id.upper_emoji) :
        activity.findViewById(R.id.lower_emoji));

        Log.d(TAG, "heght = " + currentEmojiView.getHeight()
                + ", width = " + currentEmojiView.getWidth());

        // get emoji bitmap
        int id = imageIds.get(this.index.getIndex());
        Bitmap bitmapEmoji = BitmapFactory.decodeResource(view.getResources(), id);
        currentEmojiView = new ImageView(activity);
        currentEmojiView.setImageBitmap(bitmapEmoji);

        // set params
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(width, height);
        params.leftMargin = left;
        params.topMargin = top;

        // add view to layout
        RelativeLayout rl = (RelativeLayout) activity.findViewById(R.id.image_layout);
        rl.addView(currentEmojiView, index, params);
    }

    private class CoordinateInfo {
        int width;
        int height;
        int left;
        int top;
        FaceLandmarks fl;

        public CoordinateInfo(FaceLandmarks fl) {
            this.fl = fl;

            // HARD CODED FOR DEMO
            if (isUpperView) {
                // COORDINATE SYSTEM ARE DIFFERENT BETWEEN
                // BITMAP AND VIEW
                float eyebrowLeftOuterX = (float) fl.eyebrowLeftOuter.x;
                float eyebrowRightOuterX = (float) fl.eyeRightOuter.x;
                this.width = (int) Math.abs(eyebrowLeftOuterX - eyebrowRightOuterX) + 90;

                float yTop1 = (float) fl.eyeLeftBottom.y;
                float yTop2 = (float) fl.eyeRightBottom.y;
                float upperY = (yTop1 + yTop2) / 2;

                float yBottom1 = (float) fl.noseLeftAlarTop.y;
                float yBottom2 = (float) fl.noseRightAlarTop.y;
                float lowerY = (yBottom1 + yBottom2) / 2;

                this.height = (int) Math.abs((upperY - lowerY) / 2) + 80;
                this.left = (int) (eyebrowLeftOuterX);
                //this.top = (int) ((fl.eyebrowLeftOuter.y + fl.eyeRightOuter.y) / 2);
                this.top = (int) fl.eyebrowLeftOuter.y - 40;
                /*this.left = 300;
                this.width = 450;
                this.top = 550;
                this.height = 400;*/

            } else {
                this.left = (int) fl.mouthLeft.x;
                this.width = (int) Math.abs(fl.mouthLeft.x - fl.mouthRight.x) + 20;
                this.height = (int) ((fl.noseTip.y + fl.underLipTop.y) / 2) + 15;
                this.top = (int) fl.underLipBottom.y / 3 + 20;
                /*this.left = 350;
                this.width = 400;
                this.top = 775;
                this.height = 400;*/
                Log.d(TAG, this.toString() + "-------");
            }
        }

        public String toString() {
            return "width = " + width + ", " +
                    "height = " + height + ", " +
                    "left = " + left +  ", " +
                    "top = " + top;
        }
    }
    private class Index {
        private int index;
        public Index() {
            this.index = 0;
        }

        public void increment() {
            index = (index + 1) % imageIds.size();
        }

        public void decrement() {
            index = (index - 1);
            if (index == -1) {
                index = imageIds.size() - 1;
            }
        }

        public int getIndex() {
            return index;
        }
    }
}
