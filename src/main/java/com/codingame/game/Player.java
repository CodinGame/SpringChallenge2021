package com.codingame.game;

import com.codingame.game.action.Action;
import com.codingame.gameengine.core.AbstractMultiplayerPlayer;

public class Player extends AbstractMultiplayerPlayer {
    private String message;
    private Action action;
    private int sun;
    private boolean waiting = false;
    private int bonusScore = 0;

    public Player() {
        sun = Config.STARTING_SUN;
        action = Action.NO_ACTION;
        
    }

    @Override
    public int getExpectedOutputLines() {
        return 1;
    }

    public void addScore(int score) {
        setScore(getScore() + score);
    }

    public void reset() {
        message = null;
        action = Action.NO_ACTION;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setAction(Action action) {
        this.action = action;
    }

    public Action getAction() {
        return action;
    }

    public int getSun() {
        return sun;
    }

    public void setSun(int sun) {
        this.sun = sun;
    }

    public void addSun(int sun) {
        this.sun += sun;
    }

    public void removeSun(int amount) {
        this.sun = Math.max(0, this.sun - amount);
    }

    public boolean isWaiting() {
        return waiting;
    }

    public void setWaiting(boolean waiting) {
        this.waiting = waiting;
    }

    public String getBonusScore() {
        if (bonusScore > 0) {
            return String.format(
                "%d points and %d trees",
                getScore() - bonusScore,
                bonusScore
            );
        } else {
            return "";
        }
    }

    public void addBonusScore(int bonusScore) {
        this.bonusScore += bonusScore;
    }
}
