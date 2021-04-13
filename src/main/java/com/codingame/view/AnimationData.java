package com.codingame.view;

public class AnimationData {
    public static final int SHORT = 100;
    public static final int QUICK = 300;
    public static final int LONG = 500;

    int start, end;
    Integer trigger;
    Integer triggerEnd;

    public AnimationData(int start, int duration) {
        this.start = start;
        this.end = start + duration;
        this.trigger = null;
        this.triggerEnd = null;
    }

    public AnimationData(int start, int duration, Integer triggerAfter, Integer triggerDuration) {
        this.start = start;
        this.end = start + duration;
        this.trigger = triggerAfter == null ? null : start + triggerAfter;
        this.triggerEnd = triggerDuration == null ? null : start + triggerAfter + triggerDuration;
    }
}
