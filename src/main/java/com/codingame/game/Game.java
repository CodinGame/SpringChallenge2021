
package com.codingame.game;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.TreeMap;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.codingame.game.action.Action;
import com.codingame.game.exception.AlreadyActivatedTree;
import com.codingame.game.exception.CellNotEmptyException;
import com.codingame.game.exception.CellNotFoundException;
import com.codingame.game.exception.CellNotValidException;
import com.codingame.game.exception.GameException;
import com.codingame.game.exception.NotEnoughSunException;
import com.codingame.game.exception.NotOwnerOfTreeException;
import com.codingame.game.exception.TreeAlreadyTallException;
import com.codingame.game.exception.TreeIsSeedException;
import com.codingame.game.exception.TreeNotFoundException;
import com.codingame.game.exception.TreeNotTallException;
import com.codingame.game.exception.TreeTooFarException;
import com.codingame.gameengine.core.MultiplayerGameManager;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class Game {

    @Inject private MultiplayerGameManager<Player> gameManager;
    @Inject private GameSummaryManager gameSummaryManager;
    Integer nutrients = Config.STARTING_NUTRIENTS;

    public static boolean ENABLE_SEED;
    public static boolean ENABLE_GROW;
    public static boolean ENABLE_SHADOW;
    public static boolean ENABLE_HOLES;
    public static int MAX_ROUNDS;
    public static int STARTING_TREE_COUNT;
    public static int STARTING_TREE_SIZE;
    public static int STARTING_TREE_DISTANCE;
    public static boolean STARTING_TREES_ON_EDGES;

    Board board;
    Map<Integer, Tree> trees;
    List<CubeCoord> dyingTrees;
    List<Integer> availableSun;
    List<Seed> sentSeeds;
    Sun sun;
    Map<Integer, Integer> shadows;
    List<Cell> cells;
    Random random;
    int round = 0;
    int turn = 0;
    FrameType currentFrameType = FrameType.INIT;
    FrameType nextFrameType = FrameType.GATHERING;

    public void init(long seed) {

        switch (gameManager.getLeagueLevel()) {
        case 1:
            // Wood 2
            MAX_ROUNDS = 1;
            ENABLE_SEED = false;
            ENABLE_GROW = false;
            ENABLE_SHADOW = false;
            ENABLE_HOLES = false;
            STARTING_TREE_COUNT = 6;
            STARTING_TREE_SIZE = Constants.TREE_TALL;
            STARTING_TREE_DISTANCE = 0;
            STARTING_TREES_ON_EDGES = false;
            break;
        case 2:
            // Wood 1
            MAX_ROUNDS = 6;
            ENABLE_SEED = false;
            ENABLE_GROW = true;
            ENABLE_SHADOW = false;
            ENABLE_HOLES = false;
            STARTING_TREE_COUNT = 4;
            STARTING_TREE_SIZE = Constants.TREE_SMALL;
            STARTING_TREE_DISTANCE = 1;
            STARTING_TREES_ON_EDGES = false;
            break;
        default:
            // Bronze+
            MAX_ROUNDS = Config.MAX_ROUNDS;
            ENABLE_SEED = true;
            ENABLE_GROW = true;
            ENABLE_SHADOW = true;
            ENABLE_HOLES = true;
            STARTING_TREE_COUNT = Constants.STARTING_TREE_COUNT;
            STARTING_TREE_SIZE = Constants.TREE_SMALL;
            STARTING_TREE_DISTANCE = 2;
            STARTING_TREES_ON_EDGES = true;
        }

        random = new Random(seed);
        board = BoardGenerator.generate(random);
        trees = new TreeMap<>();
        dyingTrees = new ArrayList<>();
        cells = new ArrayList<>();
        availableSun = new ArrayList<>(gameManager.getPlayerCount());
        sentSeeds = new ArrayList<>();
        initStartingTrees();

        sun = new Sun();
        shadows = new HashMap<>();
        sun.setOrientation(0);

        round = 0;
        if (ENABLE_SHADOW) {
            calculateShadows();
        }
    }

    public static String getExpected() {
        if (!ENABLE_GROW && !ENABLE_SEED) {
            return "COMPLETE <idx> | WAIT";
        }
        if (!ENABLE_SEED && ENABLE_GROW) {
            return "GROW <idx> | COMPLETE <idx> | WAIT";
        }
        return "SEED <from> <to> | GROW <idx> | COMPLETE <idx> | WAIT";
    }

    private CubeCoord getCoordByIndex(int index) throws CellNotFoundException {
        return board.map.entrySet()
            .stream()
            .filter(e -> e.getValue().getIndex() == index)
            .findFirst()
            .orElseThrow(() -> {
                return new CellNotFoundException(index);
            }).getKey();
    }

    private void initStartingTrees() {

        List<CubeCoord> startingCoords = new ArrayList<CubeCoord>();
        if (STARTING_TREES_ON_EDGES) {
            startingCoords = getBoardEdges();
        } else {
            startingCoords = new ArrayList<CubeCoord>(board.coords);
            startingCoords.removeIf(coord -> {
                return coord.getX() == 0 && coord.getY() == 0 && coord.getZ() == 0;
            });
        }

        startingCoords.removeIf(coord -> {
            Cell cell = board.map.get(coord);
            return cell.getRichness() == Constants.RICHNESS_NULL;
        });
        List<CubeCoord> validCoords = new ArrayList<CubeCoord>();

        while (validCoords.size() < STARTING_TREE_COUNT * 2) {
            validCoords = tryInitStartingTrees(startingCoords);
        }

        List<Player> players = gameManager.getPlayers();
        for (int i = 0; i < STARTING_TREE_COUNT; i++) {
            placeTree(players.get(0), board.map.get(validCoords.get(2 * i)).getIndex(), STARTING_TREE_SIZE);
            placeTree(players.get(1), board.map.get(validCoords.get(2 * i + 1)).getIndex(), STARTING_TREE_SIZE);
        }
    }

    private List<CubeCoord> tryInitStartingTrees(List<CubeCoord> startingCoords) {
        List<CubeCoord> coordinates = new ArrayList<CubeCoord>();

        List<CubeCoord> availableCoords = new ArrayList<>(startingCoords);
        for (int i = 0; i < STARTING_TREE_COUNT; i++) {
            if (availableCoords.isEmpty()) {
                return coordinates;
            }
            int r = random.nextInt(availableCoords.size());
            CubeCoord normalCoord = availableCoords.get(r);
            CubeCoord oppositeCoord = normalCoord.getOpposite();
            availableCoords.removeIf(coord -> {
                return coord.distanceTo(normalCoord) <= STARTING_TREE_DISTANCE ||
                    coord.distanceTo(oppositeCoord) <= STARTING_TREE_DISTANCE;
            });
            coordinates.add(normalCoord);
            coordinates.add(oppositeCoord);
        }
        return coordinates;
    }

    private void calculateShadows() {
        shadows.clear();
        trees.forEach((index, tree) -> {
            CubeCoord coord = board.coords.get(index);
            for (int i = 1; i <= tree.getSize(); i++) {
                CubeCoord tempCoord = coord.neighbor(sun.getOrientation(), i);
                if (board.map.containsKey(tempCoord)) {
                    shadows.compute(
                        board.map.get(tempCoord).getIndex(),
                        (key, value) -> value == null ? tree.getSize() : Math.max(value, tree.getSize())
                    );
                }
            }
        });
    }

    private List<CubeCoord> getBoardEdges() {
        CubeCoord centre = new CubeCoord(0, 0, 0);
        return board.coords.stream()
            .filter(coord -> coord.distanceTo(centre) == Config.MAP_RING_COUNT)
            .collect(Collectors.toList());
    }

    public List<String> getCurrentFrameInfoFor(Player player) {
        List<String> lines = new ArrayList<>();
        lines.add(String.valueOf(round));
        lines.add(String.valueOf(nutrients));
        //Player information, receiving player first
        Player other = gameManager.getPlayer(1 - player.getIndex());
        lines.add(
            String.format(
                "%d %d",
                player.getSun(),
                player.getScore()
            )
        );
        lines.add(
            String.format(
                "%d %d %d",
                other.getSun(),
                other.getScore(),
                other.isWaiting() ? 1 : 0
            )
        );
        lines.add(String.valueOf(trees.size()));
        trees.forEach((index, tree) -> {
            lines.add(
                String.format(
                    "%d %d %d %d",
                    index,
                    tree.getSize(),
                    tree.getOwner() == player ? 1 : 0,
                    tree.isDormant() ? 1 : 0
                )
            );
        });

        List<String> possibleMoves = getPossibleMoves(player);
        lines.add(String.valueOf(possibleMoves.size()));
        possibleMoves
            .stream()
            .forEach(lines::add);

        return lines;
    }

    private CubeCoord cubeAdd(CubeCoord a, CubeCoord b) {
        return new CubeCoord(a.getX() + b.getX(), a.getY() + b.getY(), a.getZ() + b.getZ());
    }

    private List<CubeCoord> getCoordsInRange(CubeCoord center, int N) {
        List<CubeCoord> results = new ArrayList<>();
        for (int x = -N; x <= +N; x++) {
            for (int y = Math.max(-N, -x - N); y <= Math.min(+N, -x + N); y++) {
                int z = -x - y;
                results.add(cubeAdd(center, new CubeCoord(x, y, z)));
            }
        }
        return results;
    }

    private List<String> getPossibleMoves(Player player) {
        List<String> lines = new ArrayList<>();
        lines.add("WAIT");

        List<String> possibleSeeds = new ArrayList<>();
        List<String> possibleGrows = new ArrayList<>();
        List<String> possibleCompletes = new ArrayList<>();

        if (player.isWaiting()) {
            return lines;
        }

        //For each tree, where they can seed.
        //For each tree, if they can grow.
        int seedCost = getSeedCost(player);
        trees.entrySet()
            .stream()
            .filter(e -> e.getValue().getOwner() == player)
            .forEach(e -> {
                int index = e.getKey();
                Tree tree = e.getValue();
                CubeCoord coord = board.coords.get(index);

                if (playerCanSeedFrom(player, tree, seedCost)) {
                    for (CubeCoord targetCoord : getCoordsInRange(coord, tree.getSize())) {
                        Cell targetCell = board.map.getOrDefault(targetCoord, Cell.NO_CELL);
                        if (playerCanSeedTo(targetCell, player)) {
                            possibleSeeds.add(
                                String.format(
                                    "SEED %d %d",
                                    index,
                                    targetCell.getIndex()
                                )
                            );
                        }
                    }
                }

                int growCost = getGrowthCost(tree);
                if (growCost <= player.getSun() && !tree.isDormant()) {
                    if (tree.getSize() == Constants.TREE_TALL) {
                        possibleCompletes.add(
                            String.format(
                                "COMPLETE %d",
                                index
                            )
                        );
                    } else if (ENABLE_GROW) {
                        possibleGrows.add(
                            String.format(
                                "GROW %d",
                                index
                            )
                        );
                    }
                }
            });

        Stream.of(possibleCompletes, possibleGrows, possibleSeeds)
            .forEach(possibleList -> {
                Collections.shuffle(possibleList, random);
                lines.addAll(possibleList);
            });

        return lines;
    }

    private boolean playerCanSeedFrom(Player player, Tree tree, int seedCost) {
        return ENABLE_SEED &&
            seedCost <= player.getSun() &&
            tree.getSize() > Constants.TREE_SEED &&
            !tree.isDormant();
    }

    private boolean playerCanSeedTo(Cell targetCell, Player player) {
        return targetCell.isValid() &&
            targetCell.getRichness() != Constants.RICHNESS_NULL &&
            !trees.containsKey(targetCell.getIndex());
    }

    public List<String> getGlobalInfoFor(Player player) {
        List<String> lines = new ArrayList<>();
        lines.add(String.valueOf(board.coords.size()));
        board.coords.forEach(coord -> {
            Cell cell = board.map.get(coord);
            lines.add(
                String.format(
                    "%d %d %s",
                    cell.getIndex(),
                    cell.getRichness(),
                    getNeighbourIds(coord)
                )
            );
        });

        return lines;
    }

    private String getNeighbourIds(CubeCoord coord) {
        List<Integer> orderedNeighborIds = new ArrayList<>(CubeCoord.directions.length);
        for (int i = 0; i < CubeCoord.directions.length; ++i) {
            orderedNeighborIds.add(
                board.map.getOrDefault(coord.neighbor(i), Cell.NO_CELL).getIndex()
            );
        }
        return orderedNeighborIds.stream()
            .map(String::valueOf)
            .collect(Collectors.joining(" "));
    }

    public void resetGameTurnData() {
        dyingTrees.clear();
        availableSun.clear();
        sentSeeds.clear();
        for (Player p : gameManager.getPlayers()) {
            availableSun.add(p.getSun());
            p.reset();
        }
        currentFrameType = nextFrameType;
    }

    private int getGrowthCost(Tree targetTree) {
        int targetSize = targetTree.getSize() + 1;
        if (targetSize > Constants.TREE_TALL) {
            return Constants.LIFECYCLE_END_COST;
        }
        return getCostFor(targetSize, targetTree.getOwner());
    }

    private int getSeedCost(Player player) {
        return getCostFor(0, player);
    }

    private void doGrow(Player player, Action action) throws GameException {
        CubeCoord coord = getCoordByIndex(action.getTargetId());
        Cell cell = board.map.get(coord);
        Tree targetTree = trees.get(cell.getIndex());
        if (targetTree == null) {
            throw new TreeNotFoundException(cell.getIndex());
        }
        if (targetTree.getOwner() != player) {
            throw new NotOwnerOfTreeException(cell.getIndex(), targetTree.getOwner());
        }
        if (targetTree.isDormant()) {
            throw new AlreadyActivatedTree(cell.getIndex());
        }
        if (targetTree.getSize() >= Constants.TREE_TALL) {
            throw new TreeAlreadyTallException(cell.getIndex());
        }
        int costOfGrowth = getGrowthCost(targetTree);
        int currentSun = availableSun.get(player.getIndex());
        if (currentSun < costOfGrowth) {
            throw new NotEnoughSunException(costOfGrowth, player.getSun());
        }

        availableSun.set(player.getIndex(), currentSun - costOfGrowth);

        targetTree.grow();
        gameSummaryManager.addGrowTree(player, cell);

        targetTree.setDormant();

    }

    private void doComplete(Player player, Action action) throws GameException {
        CubeCoord coord = getCoordByIndex(action.getTargetId());
        Cell cell = board.map.get(coord);
        Tree targetTree = trees.get(cell.getIndex());
        if (targetTree == null) {
            throw new TreeNotFoundException(cell.getIndex());
        }
        if (targetTree.getOwner() != player) {
            throw new NotOwnerOfTreeException(cell.getIndex(), targetTree.getOwner());
        }
        if (targetTree.getSize() < Constants.TREE_TALL) {
            throw new TreeNotTallException(cell.getIndex());
        }
        if (targetTree.isDormant()) {
            throw new AlreadyActivatedTree(cell.getIndex());
        }
        int costOfGrowth = getGrowthCost(targetTree);
        int currentSun = availableSun.get(player.getIndex());
        if (currentSun < costOfGrowth) {
            throw new NotEnoughSunException(costOfGrowth, player.getSun());
        }

        availableSun.set(player.getIndex(), currentSun - costOfGrowth);

        dyingTrees.add(coord);

        targetTree.setDormant();

    }

    private int getCostFor(int size, Player owner) {
        int baseCost = Constants.TREE_BASE_COST[size];
        int sameTreeCount = (int) trees.values()
            .stream()
            .filter(t -> t.getSize() == size && t.getOwner() == owner)
            .count();
        return (baseCost + sameTreeCount);
    }

    private void doSeed(Player player, Action action) throws GameException {
        CubeCoord targetCoord = getCoordByIndex(action.getTargetId());
        CubeCoord sourceCoord = getCoordByIndex(action.getSourceId());

        Cell targetCell = board.map.get(targetCoord);
        Cell sourceCell = board.map.get(sourceCoord);

        if (aTreeIsOn(targetCell)) {
            throw new CellNotEmptyException(targetCell.getIndex());
        }
        Tree sourceTree = trees.get(sourceCell.getIndex());
        if (sourceTree == null) {
            throw new TreeNotFoundException(sourceCell.getIndex());
        }
        if (sourceTree.getSize() == Constants.TREE_SEED) {
            throw new TreeIsSeedException(sourceCell.getIndex());
        }
        if (sourceTree.getOwner() != player) {
            throw new NotOwnerOfTreeException(sourceCell.getIndex(), sourceTree.getOwner());
        }
        if (sourceTree.isDormant()) {
            throw new AlreadyActivatedTree(sourceCell.getIndex());
        }

        int distance = sourceCoord.distanceTo(targetCoord);
        if (distance > sourceTree.getSize()) {
            throw new TreeTooFarException(sourceCell.getIndex(), targetCell.getIndex());
        }
        if (targetCell.getRichness() == Constants.RICHNESS_NULL) {
            throw new CellNotValidException(targetCell.getIndex());
        }

        int costOfSeed = getSeedCost(player);
        int currentSun = availableSun.get(player.getIndex());
        if (currentSun < costOfSeed) {
            throw new NotEnoughSunException(costOfSeed, player.getSun());
        }
        availableSun.set(player.getIndex(), currentSun - costOfSeed);
        sourceTree.setDormant();
        Seed seed = new Seed();
        seed.setOwner(player.getIndex());
        seed.setSourceCell(sourceCell.getIndex());
        seed.setTargetCell(targetCell.getIndex());
        sentSeeds.add(seed);
        gameSummaryManager.addPlantSeed(player, targetCell, sourceCell);

    }

    private boolean aTreeIsOn(Cell cell) {
        return trees.containsKey(cell.getIndex());
    }

    private void giveSun() {
        int[] givenToPlayer = new int[2];
        trees.forEach((index, tree) -> {
            if (!shadows.containsKey(index) || shadows.get(index) < tree.getSize()) {
                Player owner = tree.getOwner();
                owner.addSun(tree.getSize());
                givenToPlayer[owner.getIndex()] += tree.getSize();
            }
        });
        gameManager.getPlayers().forEach(player -> {
            int given = givenToPlayer[player.getIndex()];
            if (given > 0) {
                gameSummaryManager.addGather(player, given);
            }
        });
    }

    private void removeDyingTrees() {
        dyingTrees.forEach(coord -> {
            Cell cell = board.map.get(coord);
            int points = nutrients;
            if (cell.getRichness() == Constants.RICHNESS_OK) {
                points += Constants.RICHNESS_BONUS_OK;
            } else if (cell.getRichness() == Constants.RICHNESS_LUSH) {
                points += Constants.RICHNESS_BONUS_LUSH;
            }
            Player player = trees.get(cell.getIndex()).getOwner();
            player.addScore(points);
            gameManager.addTooltip(
                player, String.format(
                    "%s scores %d points",
                    player.getNicknameToken(),
                    points
                )
            );
            trees.remove(cell.getIndex());
            gameSummaryManager.addCutTree(player, cell, points);
        });
    }

    private void updateNutrients() {
        dyingTrees.forEach(coord -> {
            nutrients = Math.max(0, nutrients - 1);
        });
    }

    public void performGameUpdate() {
        turn++;

        switch (currentFrameType) {
        case GATHERING:
            gameSummaryManager.addRound(round);
            performSunGatheringUpdate();
            nextFrameType = FrameType.ACTIONS;
            break;
        case ACTIONS:
            gameSummaryManager.addRound(round);
            performActionUpdate();
            if (allPlayersAreWaiting()) {
                nextFrameType = FrameType.SUN_MOVE;
            }
            break;
        case SUN_MOVE:
            gameSummaryManager.addRoundTransition(round);
            performSunMoveUpdate();
            nextFrameType = FrameType.GATHERING;
            break;
        default:
            System.err.println("Error: " + currentFrameType);
            break;
        }

        gameManager.addToGameSummary(gameSummaryManager.toString());
        gameSummaryManager.clear();

        if (gameOver()) {
            gameManager.endGame();
        } else {
            gameManager.setMaxTurns(turn + 1);
        }
    }

    public void performSunMoveUpdate() {
        round++;
        if (round < MAX_ROUNDS) {
            sun.move();
            if (ENABLE_SHADOW) {
                calculateShadows();
            }
        }
        gameManager.setFrameDuration(Constants.DURATION_SUNMOVE_PHASE);
    }

    public void performSunGatheringUpdate() {
        // Wake players
        gameManager.getPlayers().forEach(p -> {
            p.setWaiting(false);
        });
        trees.forEach((index, tree) -> {
            tree.reset();
        });
        // Harvest
        giveSun();

        gameManager.setFrameDuration(Constants.DURATION_GATHER_PHASE);
    }

    public void performActionUpdate() {
        gameManager.getPlayers()
            .stream()
            .filter(p -> !p.isWaiting())
            .forEach(player -> {
                try {
                    Action action = player.getAction();
                    if (action.isGrow()) {
                        doGrow(player, action);
                    } else if (action.isSeed()) {
                        doSeed(player, action);
                    } else if (action.isComplete()) {
                        doComplete(player, action);
                    } else {
                        player.setWaiting(true);
                        gameSummaryManager.addWait(player);
                    }
                } catch (GameException e) {
                    gameSummaryManager.addError(player.getNicknameToken() + ": " + e.getMessage());
                    player.setWaiting(true);
                }
            });

        if (seedsAreConflicting()) {
            gameSummaryManager.addSeedConflict(sentSeeds.get(0));
        } else {
            sentSeeds.forEach(seed -> {
                plantSeed(gameManager.getPlayer(seed.getOwner()), seed.getTargetCell(), seed.getSourceCell());
            });
            for (Player player : gameManager.getPlayers()) {
                player.setSun(availableSun.get(player.getIndex()));
            }
        }
        removeDyingTrees();

        updateNutrients();

        gameManager.setFrameDuration(Constants.DURATION_ACTION_PHASE);

    }

    private boolean seedsAreConflicting() {
        return sentSeeds.size() != sentSeeds
            .stream()
            .map(seed -> {
                return seed.getTargetCell();
            })
            .distinct()
            .count();
    }

    private boolean allPlayersAreWaiting() {
        return gameManager.getPlayers()
            .stream()
            .filter(Player::isWaiting)
            .count() == gameManager.getPlayerCount();
    }

    private void plantSeed(Player player, int index, int fatherIndex) {
        Tree seed = placeTree(player, index, Constants.TREE_SEED);
        seed.setDormant();
        seed.setFatherIndex(fatherIndex);
    }

    private Tree placeTree(Player player, int index, int size) {
        Tree tree = new Tree();
        tree.setSize(size);
        tree.setOwner(player);
        trees.put(index, tree);
        return tree;
    }

    public void onEnd() {
        gameManager.getActivePlayers().forEach(
            player -> player.addScore((int) Math.floor(player.getSun() / 3))
        );
        if (
            gameManager.getActivePlayers().stream()
                .map(player -> player.getScore())
                .distinct()
                .count() == 1
        ) {
            trees.forEach((index, tree) -> {
                if (tree.getOwner().isActive()) {
                    tree.getOwner().addBonusScore(1);
                    tree.getOwner().addScore(1);
                }
            });
        }
    }

    public Map<CubeCoord, Cell> getBoard() {
        return board.map;
    }

    public Map<Integer, Tree> getTrees() {
        return trees;
    }

    public Map<Integer, Integer> getShadows() {

        return shadows;
    }

    private boolean gameOver() {
        return gameManager.getActivePlayers().size() <= 1 || round >= MAX_ROUNDS;
    }

    public int getRound() {
        return round;
    }

    public int getTurn() {
        return turn;
    }

    public Sun getSun() {
        return sun;
    }

    public int getNutrients() {
        return nutrients;
    }

    public FrameType getCurrentFrameType() {
        return currentFrameType;
    }

    public List<Seed> getSentSeeds() {
        return sentSeeds;
    }
}
