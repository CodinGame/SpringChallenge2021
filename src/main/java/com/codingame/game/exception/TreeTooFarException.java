package com.codingame.game.exception;

@SuppressWarnings("serial")
public class TreeTooFarException extends GameException {

    public TreeTooFarException(int from, int to) {
        super(String.format("The tree on cell %d is too far from cell %d to plant a seed there", from, to));
    }

}
