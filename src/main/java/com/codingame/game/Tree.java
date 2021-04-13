package com.codingame.game;

public class Tree {
    private int size;
    private Player owner;
    private int fatherIndex = -1;
    private boolean isDormant;

    public int getFatherIndex() {
        return fatherIndex;
    }

    public void setFatherIndex(int fatherIndex) {
        this.fatherIndex = fatherIndex;
    }

    public Player getOwner() {
        return owner;
    }

    public void setOwner(Player owner) {
        this.owner = owner;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public void grow() {
        size++;
    }

    public boolean isDormant() {
        return isDormant;
    }

    public void setDormant() {
        this.isDormant = true;
    }
    
    public void reset() {
        this.isDormant = false;
    }

}
