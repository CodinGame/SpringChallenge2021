package com.codingame.view;

import java.util.Arrays;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.codingame.game.Cell;
import com.codingame.game.Constants;
import com.codingame.game.CubeCoord;
import com.codingame.game.FrameType;
import com.codingame.game.Game;
import com.codingame.game.Player;
import com.codingame.game.Tree;
import com.codingame.gameengine.core.MultiplayerGameManager;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class GameDataProvider {
    @Inject private Game game;
    @Inject private MultiplayerGameManager<Player> gameManager;

    public FrameViewData getCurrentFrameData() {
        FrameViewData data = new FrameViewData();
        data.trees = game.getTrees()
            .entrySet()
            .stream()
            .map(entry -> {
                int index = entry.getKey();
                Tree tree = entry.getValue();

                TreeData treeData = new TreeData();
                treeData.index = index;
                treeData.owner = tree.getOwner().getIndex();
                treeData.isDormant = tree.isDormant();
                treeData.size = tree.getSize();

                if (game.getCurrentFrameType() == FrameType.GATHERING) {
                    int shadow = game.getShadows().getOrDefault(index, 0);
                    treeData.sunPoints = Math.max(0, tree.getSize() - shadow);
                }

                return treeData;

            })
            .collect(Collectors.toList());

        data.seeds = game.getSentSeeds()
            .stream()
            .map(seed -> {
                SeedData seedData = new SeedData();
                seedData.owner = seed.getOwner();
                seedData.sourceIndex = seed.getSourceCell();
                seedData.targetIndex = seed.getTargetCell();
                return seedData;
            })
            .collect(Collectors.toList());

        data.shadows = game.getShadows()
            .entrySet()
            .stream()
            .map(entry -> {
                int index = entry.getKey();
                int size = entry.getValue();

                ShadowData shadowData = new ShadowData();
                shadowData.index = index;
                shadowData.size = size;
                return shadowData;

            })
            .collect(Collectors.toList());

        data.players = gameManager.getPlayers()
            .stream()
            .map(player -> {

                PlayerData playerData = new PlayerData();
                playerData.score = player.getScore();
                playerData.sun = player.getSun();
                playerData.activated = game.getTrees()
                    .entrySet()
                    .stream()
                    .filter(entry -> entry.getValue().getOwner() == player && entry.getValue().isDormant())
                    .map(entry -> entry.getKey())
                    .collect(Collectors.toList());
                playerData.isWaiting = player.isWaiting();
                playerData.message = player.getMessage();
                if (!player.isWaiting()) {
                    playerData.affected = Stream.of(player.getAction().getSourceId(), player.getAction().getTargetId())
                        .filter(Objects::nonNull)
                        .collect(Collectors.toList());
                }
                return playerData;
            })
            .collect(Collectors.toList());

        data.round = game.getRound();
        data.sunOrientation = game.getSun().getOrientation();
        data.frameType = game.getCurrentFrameType().ordinal();
        data.nutrients = game.getNutrients();

        return data;
    }

    public GlobalViewData getGlobalData() {
        GlobalViewData data = new GlobalViewData();
        data.cells = game.getBoard()
            .entrySet()
            .stream()
            .map(entry -> {

                CubeCoord coord = entry.getKey();
                Cell cell = entry.getValue();

                CellData cellData = new CellData();
                cellData.q = coord.getX();
                cellData.r = coord.getZ();
                cellData.richness = cell.getRichness();
                cellData.index = cell.getIndex();
                return cellData;
            })
            .collect(Collectors.toList());

        data.nutrients = Arrays.asList(0, Constants.RICHNESS_BONUS_OK, Constants.RICHNESS_BONUS_LUSH);
        data.totalRounds = Game.MAX_ROUNDS;
        return data;
    }
}
