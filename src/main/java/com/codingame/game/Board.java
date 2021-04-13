package com.codingame.game;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

public class Board {

    public final Map<CubeCoord, Cell> map;
    public final List<CubeCoord> coords;

    public Board(Map<CubeCoord, Cell> map) {
        this.map = map;
        coords = map.entrySet()
            .stream()
            .sorted(
                (a, b) -> a.getValue().getIndex() - b.getValue().getIndex()
            )
            .map(Entry::getKey)
            .collect(Collectors.toList());
    }

}
