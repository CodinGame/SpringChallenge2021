package com.codingame.game.exception;

import com.codingame.game.Player;

@SuppressWarnings("serial")
public class NotOwnerOfTreeException extends GameException {

    public NotOwnerOfTreeException(int id, Player player) {
        super("The tree on cell " + id + " is owned by opponent");
    }

}
