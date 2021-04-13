package com.codingame.game.exception;

@SuppressWarnings("serial")
public class NotEnoughSunException extends GameException {

    public NotEnoughSunException(int cost, int sun) {
        super(String.format("Not enough sun. You need %d but have %d", cost, sun));
    }

}
