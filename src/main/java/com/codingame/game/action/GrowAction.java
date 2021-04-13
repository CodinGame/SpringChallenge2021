package com.codingame.game.action;

public class GrowAction extends Action {

    public GrowAction(int targetId) {
        this.targetId = targetId;
    }

    @Override
    public boolean isGrow() {
        return true;
    }
}
