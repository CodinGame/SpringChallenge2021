package com.codingame.game.action;

public class SeedAction extends Action {

    public SeedAction(int sourceId, int targetId) {
        this.sourceId = sourceId;
        this.targetId = targetId;
    }

    @Override
    public boolean isSeed() {
        return true;
    }
}
