package com.runs.www;

import java.util.Timer;
import java.util.TimerTask;

public class DelayComponentImp implements IDelayComponent {

    private Timer timer = new Timer();
    private IDelayComponentCallback callback;


    private TimerTask timerTask = new TimerTask() {
        @Override
        public void run() {
            timer.cancel();
            callback.onFinish();
        }
    };

    @Override
    public void delay(long delay, IDelayComponentCallback callback) {
        this.callback = callback;
        timer.schedule(timerTask, delay);
    }

    @Override
    public void cancel() {
        if (null != timer) {
            timer.cancel();
            timer = null;
        }

        if (null != timerTask) {
            timerTask = null;
        }
    }
}
