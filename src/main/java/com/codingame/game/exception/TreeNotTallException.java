package com.codingame.game.exception;

@SuppressWarnings("serial")
public class TreeNotTallException extends GameException {

    public TreeNotTallException(int id) {
        super("The tree on cell " + id + " is not large enough");
    }

}
