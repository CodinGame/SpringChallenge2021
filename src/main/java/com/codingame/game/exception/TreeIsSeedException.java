package com.codingame.game.exception;

@SuppressWarnings("serial")
public class TreeIsSeedException extends GameException {

    public TreeIsSeedException(int id) {
        super("The seed on " + id + " cannot produce seeds");
    }

}
