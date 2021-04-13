package com.codingame.game.exception;

@SuppressWarnings("serial")
public class CellNotFoundException extends GameException {

    public CellNotFoundException(int id) {
        super("Cell " + id + " not found");
    }

}
