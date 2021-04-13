package com.codingame.game.exception;

@SuppressWarnings("serial")
public class CellNotEmptyException extends GameException {

    public CellNotEmptyException(int id) {
        super("There is already a tree on cell " + id);
    }

}
