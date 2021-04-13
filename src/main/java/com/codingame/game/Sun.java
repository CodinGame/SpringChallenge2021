package com.codingame.game;

public class Sun {
    private int orientation;

    public Sun() {
    }

    public int getOrientation() {
        return orientation;
    }

    public void setOrientation(int orientation) {
        this.orientation = (orientation) % 6;
    }

    public void move() {
        orientation = (orientation + 1) % 6;
    }
}
