package com.codingame.game.exception;

@SuppressWarnings("serial")
public class AlreadyActivatedTree extends GameException {

    public AlreadyActivatedTree(int id) {
        super("Tree on cell " + id + " is dormant (has already been used this round)");
    }

}
