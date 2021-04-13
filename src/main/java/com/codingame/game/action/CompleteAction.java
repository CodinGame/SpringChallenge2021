package com.codingame.game.action;

public class CompleteAction extends Action {

    public CompleteAction(int targetId) {
        this.targetId = targetId;
    }

    @Override
    public boolean isComplete() {
        return true;
    }
}
