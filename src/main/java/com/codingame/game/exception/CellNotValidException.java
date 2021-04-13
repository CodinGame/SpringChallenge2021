package com.codingame.game.exception;

@SuppressWarnings("serial")
public class CellNotValidException extends GameException {

    public CellNotValidException(int id) {
        super("You can't plant a seed on cell " + id);
    }

}
