package com.codingame.game;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.codingame.game.action.CompleteAction;
import com.codingame.game.action.GrowAction;
import com.codingame.game.action.SeedAction;
import com.codingame.game.action.WaitAction;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class CommandManager {
    @Inject private GameSummaryManager gameSummaryManager;

    static final Pattern PLAYER_WAIT_PATTERN = Pattern.compile(
        "^WAIT(?:\\s+(?<message>.*))?"
    );

    static final Pattern PLAYER_SEED_PATTERN = Pattern.compile(
        "^SEED (?<sourceId>\\d+) (?<targetId>\\d+)(?:\\s+(?<message>.*))?"
    );
    static final Pattern PLAYER_GROW_PATTERN = Pattern.compile(
        "^GROW (?<targetId>\\d+)(?:\\s+(?<message>.*))?"
    );

    static final Pattern PLAYER_COMPLETE_PATTERN = Pattern.compile(
        "^COMPLETE (?<targetId>\\d+)(?:\\s+(?<message>.*))?"
    );

    public void parseCommands(Player player, List<String> lines, Game game) {
        String command = lines.get(0);

        if (player.isWaiting()) {
            return;
        }

        try {
            Matcher match;

            match = PLAYER_WAIT_PATTERN.matcher(command);
            if (match.matches()) {
                player.setAction(new WaitAction());
                matchMessage(player, match);
                return;
            }

            if (Game.ENABLE_GROW) {
                match = PLAYER_GROW_PATTERN.matcher(command);
                if (match.matches()) {
                    int targetId = Integer.parseInt(match.group("targetId"));
                    player.setAction(new GrowAction(targetId));
                    matchMessage(player, match);
                    return;
                }
            }

            match = PLAYER_COMPLETE_PATTERN.matcher(command);
            if (match.matches()) {
                int targetId = Integer.parseInt(match.group("targetId"));
                player.setAction(new CompleteAction(targetId));
                matchMessage(player, match);
                return;
            }

            if (Game.ENABLE_SEED) {
                match = PLAYER_SEED_PATTERN.matcher(command);
                if (match.matches()) {
                    int sourceId = Integer.parseInt(match.group("sourceId"));
                    int targetId = Integer.parseInt(match.group("targetId"));
                    player.setAction(new SeedAction(sourceId, targetId));
                    matchMessage(player, match);
                    return;
                }
            }

            throw new InvalidInputException(Game.getExpected(), command);

        } catch (InvalidInputException e) {
            deactivatePlayer(player, e.getMessage());
            gameSummaryManager.addPlayerBadCommand(player, e);
            gameSummaryManager.addPlayerDisqualified(player);
        } catch (Exception e) {
            InvalidInputException invalidInputException = new InvalidInputException(Game.getExpected(), e.toString());
            deactivatePlayer(player, invalidInputException.getMessage());
            gameSummaryManager.addPlayerBadCommand(player, invalidInputException);
            gameSummaryManager.addPlayerDisqualified(player);
        }
    }

    public void deactivatePlayer(Player player, String message) {
        player.deactivate(escapeHTMLEntities(message));
        player.setScore(-1);
    }

    private String escapeHTMLEntities(String message) {
        return message
            .replace("&lt;", "<")
            .replace("&gt;", ">");
    }

    private void matchMessage(Player player, Matcher match) {
        String message = match.group("message");
        if (message != null) {
            String trimmed = message.trim();
            if (trimmed.length() > 48) {
                trimmed = trimmed.substring(0, 46) + "...";
            }
            player.setMessage(trimmed);
        }
    }
}
