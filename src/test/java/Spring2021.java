import java.io.File;
import java.io.IOException;
import java.util.Properties;

import com.codingame.gameengine.runner.MultiplayerGameRunner;

public class Spring2021 {

    static String[] DEFAULT_AI = new String[] {
        "python3", "config/Boss.py"
    };
    static String[] BOSS_WOOD2 = new String[] {
        "python3", "config/level1/Boss.py"
    };
    static String[] BOSS_WOOD1 = new String[] {
        "python3", "config/level2/Boss.py"
    };

    public static void main(String[] args) throws IOException, InterruptedException {
        launchGame();
    }

    public static void launchGame() throws IOException, InterruptedException {

        MultiplayerGameRunner gameRunner = new MultiplayerGameRunner();
        gameRunner.setLeagueLevel(3);
        Properties gameParameters = new Properties();
        gameRunner.setGameParameters(gameParameters);

        gameRunner.addAgent(
            DEFAULT_AI,
            "Tororo",
            "https://static.codingame.com/servlet/fileservlet?id=61910307869345"
        );
        
        gameRunner.addAgent(
            DEFAULT_AI,
            "Ghilbib",
            "https://static.codingame.com/servlet/fileservlet?id=61910289640958"
        );
        
        gameRunner.setSeed(7308340236785320085L);

        gameRunner.start(8888);
    }
}
