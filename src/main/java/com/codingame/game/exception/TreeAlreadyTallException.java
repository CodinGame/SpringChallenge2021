package com.codingame.game.exception;

@SuppressWarnings("serial")
public class TreeAlreadyTallException extends GameException {

    public TreeAlreadyTallException(int id) {
        super("Tree on cell " + id + " cannot grow more (max size is 3).");
    }

}
