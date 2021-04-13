package com.codingame.game.action;

public abstract class Action {
    public Integer sourceId;
    public Integer targetId;

    public static final Action NO_ACTION = new Action() {
    };

    public boolean isGrow() {
        return false;
    }

    public boolean isComplete() {
        return false;
    }

    public boolean isSeed() {
        return false;
    }

    public boolean isWait() {
        return false;
    }

    public Integer getSourceId() {
        return sourceId;
    }

    public Integer getTargetId() {
        return targetId;
    }

}
