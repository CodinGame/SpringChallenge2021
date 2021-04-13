package com.codingame.game;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class BoardGenerator {

    static Map<CubeCoord, Cell> board;
    static int index;

    public static void generateCell(CubeCoord coord, int richness) {
        Cell cell = new Cell(index++);
        cell.setRichness(richness);
        board.put(coord, cell);
    }

    public static Board generate(Random random) {
        board = new HashMap<>();
        index = 0;
        CubeCoord centre = new CubeCoord(0, 0, 0);

        generateCell(centre, Constants.RICHNESS_LUSH);

        CubeCoord coord = centre.neighbor(0);

        for (int distance = 1; distance <= Config.MAP_RING_COUNT; distance++) {
            for (int orientation = 0; orientation < 6; orientation++) {
                for (int count = 0; count < distance; count++) {
                    if (distance == Config.MAP_RING_COUNT) {
                        generateCell(coord, Constants.RICHNESS_POOR);
                    } else if (distance == Config.MAP_RING_COUNT - 1) {
                        generateCell(coord, Constants.RICHNESS_OK);
                    } else {
                        generateCell(coord, Constants.RICHNESS_LUSH);
                    }
                    coord = coord.neighbor((orientation + 2) % 6);
                }
            }
            coord = coord.neighbor(0);
        }

        List<CubeCoord> coordList = new ArrayList<>(board.keySet());
        int coordListSize = coordList.size();
        int wantedEmptyCells = Game.ENABLE_HOLES ? random.nextInt(Config.MAX_EMPTY_CELLS + 1) : 0;
        int actualEmptyCells = 0;

        while (actualEmptyCells < wantedEmptyCells - 1) {
            int randIndex = random.nextInt(coordListSize);
            CubeCoord randCoord = coordList.get(randIndex);
            if (board.get(randCoord).getRichness() != Constants.RICHNESS_NULL) {
                board.get(randCoord).setRichness(Constants.RICHNESS_NULL);
                actualEmptyCells++;
                if (!randCoord.equals(randCoord.getOpposite())) {
                    board.get(randCoord.getOpposite()).setRichness(Constants.RICHNESS_NULL);
                    actualEmptyCells++;
                }
            }
        }
        return new Board(board);
    }
}