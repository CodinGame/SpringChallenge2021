package com.codingame.game;

import java.util.Properties;
import java.util.function.Function;

public class Config {

    public static int STARTING_SUN = 0;
    public static int MAP_RING_COUNT = 3;
    public static int STARTING_NUTRIENTS = 20;
    public static int MAX_ROUNDS = 24;
    public static int MAX_EMPTY_CELLS = 10;

    public static void load(Properties params) {
        STARTING_SUN = getFromParams(params, "STARTING_SUN", STARTING_SUN);
        MAP_RING_COUNT = getFromParams(params, "MAP_RING_COUNT", MAP_RING_COUNT);
        STARTING_NUTRIENTS = getFromParams(params, "STARTING_NUTRIENTS_LUSH", STARTING_NUTRIENTS);
        MAX_ROUNDS = getFromParams(params, "MAX_ROUNDS", MAX_ROUNDS);
        MAX_EMPTY_CELLS = getFromParams(params, "MAX_EMPTY_CELLS", MAX_EMPTY_CELLS);
    }

    public static void export(Properties params) {
    }

    private static int getFromParams(Properties params, String name, int defaultValue) {
        return getFromParams(params, name, defaultValue, Integer::valueOf);
    }

    private static <T> T getFromParams(Properties params, String name, T defaultValue, Function<String, T> convert) {
        String inputValue = params.getProperty(name);
        if (inputValue != null) {
            try {
                return convert.apply(inputValue);
            } catch (NumberFormatException e) {
                // Do naught
            }
        }
        return defaultValue;
    }

}
