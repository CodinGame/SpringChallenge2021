package com.codingame.game;

public class Cell {
    public static final Cell NO_CELL = new Cell(-1) {
        @Override
        public boolean isValid() {
            return false;
        }

        @Override
        public int getIndex() {
            return -1;
        }
    };

    private int richness;
    private int index;

    public Cell(int index) {
        this.index = index;
    }

    public int getIndex() {
        return index;
    }

    public boolean isValid() {
        return true;
    }

    public void setRichness(int richness) {
        this.richness = richness;
    }

    public int getRichness() {
        return richness;
    }

}
