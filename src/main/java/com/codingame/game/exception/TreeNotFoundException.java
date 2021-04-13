package com.codingame.game.exception;

@SuppressWarnings("serial")
public class TreeNotFoundException extends GameException {

    public TreeNotFoundException(int id) {
        super("There is no tree on cell " + id);
    }

}
