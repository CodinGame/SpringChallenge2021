package com.codingame.game;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.codingame.gameengine.core.AbstractPlayer.TimeoutException;
import com.codingame.gameengine.core.AbstractReferee;
import com.codingame.gameengine.core.MultiplayerGameManager;
import com.codingame.gameengine.module.endscreen.EndScreenModule;
import com.codingame.view.ViewModule;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class Referee extends AbstractReferee {

    @Inject private MultiplayerGameManager<Player> gameManager;
    @Inject private CommandManager commandManager;
    @Inject private Game game;
    @Inject private EndScreenModule endScreenModule;
    @Inject private ViewModule viewModule;
    @Inject private GameSummaryManager gameSummaryManager;

    long seed;

    int maxFrames;

    @Override
    public void init() {
        this.seed = gameManager.getSeed();

        try {
            Config.load(gameManager.getGameParameters());
            Config.export(gameManager.getGameParameters());
            gameManager.setFirstTurnMaxTime(1000);
            gameManager.setTurnMaxTime(100);

            gameManager.setFrameDuration(500);

            game.init(seed);
            sendGlobalInfo();

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Referee failed to initialize");
            abort();
        }
    }

    private void abort() {
        System.err.println("Unexpected game end");
        gameManager.endGame();
    }

    private void sendGlobalInfo() {
        for (Player player : gameManager.getActivePlayers()) {
            for (String line : game.getGlobalInfoFor(player)) {
                player.sendInputLine(line);
            }
        }
    }

    @Override
    public void gameTurn(int turn) {
        game.resetGameTurnData();

        if (game.getCurrentFrameType() == FrameType.ACTIONS) {
            // Give input to players
            for (Player player : gameManager.getActivePlayers()) {
                if (!player.isWaiting()) {
                    for (String line : game.getCurrentFrameInfoFor(player)) {
                        player.sendInputLine(line);
                    }
                    player.execute();
                }
            }
            // Get output from players
            handlePlayerCommands();
        }

        game.performGameUpdate();
    }

    private void handlePlayerCommands() {
        for (Player player : gameManager.getActivePlayers()) {
            if (!player.isWaiting()) {
                try {
                    commandManager.parseCommands(player, player.getOutputs(), game);
                } catch (TimeoutException e) {
                    commandManager.deactivatePlayer(player, "Timeout!");
                    gameSummaryManager.addPlayerTimeout(player);
                    gameSummaryManager.addPlayerDisqualified(player);
                }
            }
        }

    }

    @Override
    public void onEnd() {
        endScreenModule.setTitleRankingsSprite("logo.png");

        game.onEnd();

        int scores[] = gameManager.getPlayers().stream()
            .mapToInt(Player::getScore)
            .toArray();
        
        String displayedText[] = gameManager.getPlayers().stream()
            .map(Player::getBonusScore)
            .toArray(String[]::new);
     
        endScreenModule.setScores(scores, displayedText);
    }

}
