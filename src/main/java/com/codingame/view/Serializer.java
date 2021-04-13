package com.codingame.view;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Serializer {

    static public String serialize(FrameViewData frameViewData) {
        List<String> lines = new ArrayList<>();
        lines.add(
            join(
                frameViewData.round,
                frameViewData.sunOrientation,
                frameViewData.nutrients,
                frameViewData.frameType
            )
        );

        lines.add(String.valueOf(frameViewData.trees.size()));
        frameViewData.trees.stream().forEach(treeData -> {
            lines.add(
                join(
                    treeData.index,
                    treeData.owner,
                    treeData.isDormant ? 1 : 0,
                    treeData.size,
                    treeData.sunPoints
                )
            );
        });
        lines.add(String.valueOf(frameViewData.seeds.size()));
        frameViewData.seeds.stream().forEach(seedData -> {
            lines.add(
                join(
                    seedData.owner,
                    seedData.sourceIndex,
                    seedData.targetIndex
                )
            );
        });
        lines.add(String.valueOf(frameViewData.shadows.size()));
        frameViewData.shadows.stream().forEach(shadowData -> {
            lines.add(
                join(
                    shadowData.index,
                    shadowData.size
                )
            );
        });
        frameViewData.players.stream().forEach(playerData -> {
            lines.add(
                join(
                    playerData.score,
                    playerData.sun,
                    playerData.isWaiting ? 1 : 0
                )
            );
            lines.add(
                playerData.activated.stream()
                    .map(String::valueOf)
                    .collect(Collectors.joining(" "))
            );
            lines.add(
                playerData.message == null ? "" : playerData.message
            );
            lines.add(
                playerData.affected == null ? "" : playerData.affected.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(" "))
            );
        });
        return lines.stream().collect(Collectors.joining("\n"));
    }

    static public String serialize(GlobalViewData globalViewData) {
        List<String> lines = new ArrayList<>();
        lines.add(
            String.valueOf(globalViewData.totalRounds)
        );
        lines.add(
            globalViewData.nutrients
                .stream()
                .map(String::valueOf)
                .collect(Collectors.joining(" "))
        );

        globalViewData.cells.stream().forEach(cellData -> {
            lines.add(
                join(
                    cellData.q,
                    cellData.r,
                    cellData.richness,
                    cellData.index
                )
            );
        });

        return lines.stream().collect(Collectors.joining("\n"));
    }

    static public String join(Object... args) {
        return Stream.of(args)
            .map(String::valueOf)
            .collect(Collectors.joining(" "));
    }

}
