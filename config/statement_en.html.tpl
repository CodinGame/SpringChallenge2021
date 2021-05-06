<!-- LEAGUES level1 level2 level3 level4 -->
<div id="statement_back" class="statement_back" style="display: none"></div>
<div class="statement-body">
  <!-- LEAGUE ALERT -->
<div style="color: #7cc576; 
background-color: rgba(124, 197, 118,.1);
padding: 20px;
margin-right: 15px;
margin-left: 15px;
margin-bottom: 10px;
text-align: left;">
  <div style="text-align: center; margin-bottom: 6px">
    <img src="//cdn.codingame.com/smash-the-code/statement/league_wood_04.png" />
  </div>

  <!-- BEGIN level1 -->
  <p style="text-align: center; font-weight: 700; margin-bottom: 6px;">
    This is a <b>league based</b> challenge.
  </p>
  <!-- END -->
  <div class="statement-league-alert-content">
    <!-- BEGIN level1 -->
    For this challenge, multiple leagues for the same game are available. Once you have proven yourself against the
    first Boss, you will access a higher league and extra rules will be available.<br>
    <br>
    <!-- END -->
    Starter AIs are available in the
    <a target="_blank" href="https://github.com/CodinGame/SpringChallenge2021/tree/main/starterAIs">Starter Kit</a>.
    They can help you get started with your own bot.
  </div>

</div>

<div style="padding: 20px;
    margin-right: 15px;
    margin-bottom: 10px;
    text-align: left;">
    <em>Tutorial video by Gaurav Sen: <a href="https://youtu.be/gZMdOiqchDk" rel="noopener" target="_blank" >https://youtu.be/gZMdOiqchDk</a></em>
  </div>


  <!-- GOAL -->
  <div class="statement-section statement-goal">
    <h2>
      <span class="icon icon-goal">&nbsp;</span>
      <span>Goal</span>
    </h2>
    <div style="margin-bottom: 10px" class="statement-goal-content">
      <div>
        End the game with more <b>points</b> than your opponent.
      </div>
      <center style="margin: 20px">
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574189838986" style="margin-bottom: 5px">
      </center>
    </div>
    <div style="margin-bottom: 10px">
      The game takes place in a <b>forest</b>, in which gentle wood spirits reside. Their job is to make sure trees
      complete their <b>lifecycle</b>.
      <br>
      Two wood spirits have started to compete over which one is the most efficient.
    </div>
    Grow trees at strategic locations of the forest to maximize your points.

  </div>
  <!-- RULES -->
  <div class="statement-section statement-rules">
    <h2>
      <span class="icon icon-rules">&nbsp;</span>
      <span>Rules</span>
    </h2>

    <div class="statement-rules-content">
      <div style="margin-bottom: 10px">
        Each player embodies a <b>wood spirit</b>. The game takes place on a hexagonal grid representing the <b>forest</b>.
      </div>
      <div style="margin-bottom: 10px">
        The game is played over several rounds called <b>days</b>. Each day can be made up of several game <b>turns</b>. On each turn, both players perform one action simultaneously.
      </div>
      <!-- BEGIN level1 -->
      <div class="statement-new-league-rule">
        <div style="margin-bottom: 10px">
          In this league, there is only <const>1 day</const>.
        </div>
      </div>
      <!-- END -->

      <h3 style="font-size: 14px;
    font-weight: 700;
    padding-top: 15px;
    color: #838891;
    padding-bottom: 15px;">
        Forest</h3>

      <div style="margin-bottom: 10px">
        The forest is made up of <const>37</const> hexagonal cells, arranged to form a larger hexagon.
        <!-- BEGIN level3 level4 -->
        <br>
        <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        Each cell has an <b>index</b> and up to six neighbors. Each direction is labelled <const>0</const> to <const>5</const>.

        <center style="margin: 20px">
          <img src="https://static.codingame.com/servlet/fileservlet?id=61694161023285"
            style="height: 226px; margin-bottom: 5px">
          <div>
            <em>Hex directions</em>
          </div>
        </center>
        <br>
      
        The distance between two cells equals the minimum number of cells to go through to get from one to the other.
      
        <!-- BEGIN level3 -->
        </div>
          <!-- END -->
        <!-- END -->
          </div>


      <div style="margin-bottom: 10px">
      <!-- BEGIN level1 -->
        <div style="margin-bottom: 10px">
          Each cell may contain a <b>tree</b>. Each tree is owned by one of the players.
        </div>
      <!-- END -->
      <!-- BEGIN level2 level3 level4 -->
      <!-- BEGIN level2 level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        <div style="margin-bottom: 10px">
          Each cell may contain a <b>tree</b>. Each tree is owned by one of the players and has a <var>size</var>:
        </div>

        <ul>
          <!-- BEGIN level3 level4 -->
          <li>
            <const>0</const> for a <b>seed</b>.
          </li>
          <!-- END -->
          <li>
            <const>1</const> for a small tree.
          </li>
          <li>
            <const>2</const> for a medium tree.
          </li>
          <li>
            <const>3</const> for a large tree.
          </li>
        </ul>
        <!-- BEGIN level2 level3 -->
      </div>
      <!-- END -->
      <!-- END -->
      </div>

      <div style="margin-bottom: 10px">
        Each cell has a <var>richness</var> which can be:
      
      <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
      <!-- END -->

      <ul>
        <!-- BEGIN level3 level4 -->
        <li>
          <const>0</const> for <b>unusable</b> cells. Nothing can grow on them.
        </li>
        <!-- END -->
        <li>
          <const>1</const> for low quality soil.
        </li>
        <li>
          <const>2</const> for medium quality soil.
        </li>
        <li>
          <const>3</const> for high quality soil.
        </li>
      </ul>
      <!-- BEGIN level3 -->
      </div>
       <!-- END -->
      </div>


      <h3 style="font-size: 14px;
      font-weight: 700;
      padding-top: 15px;
      color: #838891;
      padding-bottom: 15px;">
        Days</h3>

      <div style="margin-bottom: 10px">
        At the start of each day, players receive <b>sun points</b>.<br>
        Then, players take <b>actions</b> by spending their sun points.<br>
        The day ends when both players stop taking actions.<br>
        More information on sun points and actions further down.
      </div>

      <!-- BEGIN level3 level4 -->
      <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->


        <h3 style="font-size: 14px;
              font-weight: 700;
              padding-top: 15px;
              color: #838891;
              padding-bottom: 15px;">
          Sun & Shadows</h3>

        <div style="margin-bottom: 10px">
          Each tree casts a shadow that affects a number of cells based on its size:
        <ul>
          <li>Size <const>1</const> trees cast a shadow <const>1</const> cell long.</li>
          <li>Size <const>2</const> trees cast a shadow <const>2</const> cells long.</li>
          <li>Size <const>3</const> trees cast a shadow <const>3</const> cells long.</li>
        </ul>
        </div>

        <div style="margin-bottom: 10px">
          The direction of a shadow depends on which direction the <b>sun</b> is currently pointing towards.<br>
          On day <const>0</const>, the sun is pointing towards direction <const>0</const>, meaning all shadows are being cast to the <b>right</b>.
        </div>

        <div style="margin-bottom: 10px">
          In between each day, the sun <b>moves</b> to point towards the next direction, coming back to <const>0</const> after passing <const>5</const>.<br>
          The sun's direction will therefore always be equal to the current <const><var>day</var> modulo 6</const>.
        </div>

        <div style="margin-bottom: 10px">
          Helping the wood spirits are <b>lesser spirits</b> hiding among all the trees.<br>

          They will find the shadow on a cell <b>spooky</b> if any of the trees casting a shadow is of equal or greater <var>size</var> than the tree on that cell.
        </div>
        <div class="statement-examples">
          <h1>
            <span class="icon icon-example">&nbsp;</span>
            <span>Example</span>
          </h1>
          <div class="statement-example-container">

            <div class="statement-example statement-example-medium">
              <img src="https://static.codingame.com/servlet/fileservlet?id=61699027046513" />
              <div class="legend">
                <div class="description">
                  The medium tree casts a <b>spooky</b> shadow on the small tree.
                </div>
              </div>
            </div>
            <div class="statement-example statement-example-medium">
              <img src="https://static.codingame.com/servlet/fileservlet?id=61699004461164" />
              <div class="legend">
                <div class="description">
                  The medium tree casts a shadow that is <b>not spooky</b> on the tall tree.
                </div>
              </div>
            </div>
            <div class="statement-example statement-example-medium">
              <img src="https://static.codingame.com/servlet/fileservlet?id=61699040950394" />
              <div class="legend">
                <div class="description">
                  The medium tree casts a <b>spooky</b> shadow on the other medium tree, even if it is on the last cell of its shadow.
                </div>
              </div>
            </div>
            <!-- Flex buffer -->
            <div class="statement-example statement-example-medium statement-example-empty"
              style="height: 0; margin-top: 0; margin-bottom: 0"></div>
          </div>
        </div>

        <!-- BEGIN level3 -->
      </div>
      <!-- END -->
      <!-- END -->

      <h3 style="font-size: 14px;
          font-weight: 700;
          padding-top: 15px;
          color: #838891;
          padding-bottom: 15px;">
        Sun Points</h3>

      <!-- BEGIN level1 level2 -->
      <div style="margin-bottom: 10px">
        Helping the wood spirits are <b>lesser spirits</b> hiding among all the trees.<br>
      </div>
      <div style="margin-bottom: 10px">
        The forest's lesser spirits will harvest <b>sun points</b> from each tree.<br>
        The points will be given to the <b>owner</b> of the tree.
      </div>
      <!-- END -->

      <!-- BEGIN level3 level4 -->
      <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        <div style="margin-bottom: 10px">
          The forest's lesser spirits will harvest <b>sun points</b> from each tree that is not hit by a <b>spooky</b> shadow.<br>
          The points will be given to the <b>owner</b> of the tree.
        </div>
        <!-- BEGIN level3 -->
      </div>
      <!-- END -->
      <!-- END -->

      <div style="margin-bottom: 10px">
        <!-- BEGIN level1 -->
      <div class="statement-new-league-rule">
        <div style="margin-bottom: 10px">
          In this league, you gain <const>3</const> sun points per tree.
        </div>
      </div>
      <!-- END -->

      <!-- BEGIN level2 level3 level4 -->
      <!-- BEGIN level2 level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        The number of sun points harvested depends on the size of the tree:

        <ul>
          <!-- BEGIN level3 level4 -->
          <li>A size <const>0</const> tree (a seed): no points.</li>
          <!-- END -->
          <li>A size <const>1</const> tree: <const>1</const> sun point.</li>
          <li>A size <const>2</const> tree: <const>2</const> sun points.</li>
          <li>A size <const>3</const> tree: <const>3</const> sun points.</li>
        </ul>
        <!-- BEGIN level2 level3 -->
      </div>
      <!-- END -->
      <!-- END -->
      </div>
      <center style="margin: 20px">
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574060405023" style="height: 113px; margin-bottom: 5px">
        <div>
          <em>A sun point</em>
        </div>
      </center>

      <h3 style="font-size: 14px;
    font-weight: 700;
    padding-top: 15px;
    color: #838891;
    padding-bottom: 15px;">
        Actions</h3>
      <!-- BEGIN level1 -->
      <div style="margin-bottom: 10px">
        After collecting sun points, both players take simultaneous turns performing one of two possible actions.
        <br>
        As long as you have enough sun points, you can take any number of actions.
      </div>
      <div style="margin-bottom: 10px">
        The possible actions are:
      <ul>
        <li>
          <action>COMPLETE</action>: Command a tree to complete its lifecycle. This removes the tree from the forest and scores you points. More information about points further down.
        </li>
        <li>
          <action>WAIT</action>: Spend the rest of the day asleep. For this league, when both players are asleep, the game ends.
        </li>
      </ul>
      </div>
      <!-- END -->

      <!-- BEGIN level2 level3 level4 -->
      <!-- BEGIN level2 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        <div style="margin-bottom: 10px">
          <!-- BEGIN level2 -->
          After collecting sun points, both players take simultaneous turns performing one of three possible actions.
          <!-- END -->
          <!-- BEGIN level3 level4 -->
          After collecting sun points, both players take simultaneous turns performing one of four possible actions.
          <!-- END -->
          <br>
          As long as you have enough sun points, you can take any number of actions.
        </div>
        <div style="margin-bottom: 10px">
          The possible actions are:
        <ul>
          <!-- BEGIN level3 -->
          <li style="background: rgba(124, 197, 118, 0.1)">
            <action>SEED</action>: Command a tree to eject a seed onto a cell within distance equal to the tree's size.
          </li>
          <!-- END -->
          <!-- BEGIN level4 -->
          <li>
            <action>SEED</action>: Command a tree to eject a seed onto a cell within distance equal to the tree's size.
          </li>
          <!-- END -->
          <li>
            <action>GROW</action>: Command a seed or tree to grow into the next size. Trees can grow up to size <const>3
            </const>.
          </li>
          <li>
            <action>COMPLETE</action>: Command a tree to complete its lifecycle. This removes the tree from the forest and scores you points. More information about points further down.
          </li>
          <li>
            <action>WAIT</action>: Spend the rest of the day asleep. When both players are asleep, a new day begins and the players are awoken.
          </li>
        </ul>
        </div>
        <!-- BEGIN level2 -->
      </div>
      <!-- END -->
      Any tree impacted by one of your actions becomes <b>dormant</b> for the rest of the day. A dormant tree cannot be the subject of an action.
      <center style="margin: 20px">
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574084176910" style="height: 113px; margin-bottom: 5px">
        <div>
          <em>A dormant tree</em>
        </div>
      </center>
      <!-- END -->

      <!-- BEGIN level3 level4 -->
      <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        <h3 style="font-size: 14px;
      font-weight: 700;
      padding-top: 15px;
      color: #838891;
      padding-bottom: 15px;">
          Seed action</h3>

        <div style="margin-bottom: 10px">
          To perform a seed action, you must pay sun points equal to the number of seeds (size <const>0</const> trees) you already own in the forest.
        </div>
        <div style="margin-bottom: 10px">
          You may not send a seed onto an <b>unusable cell</b> or a cell already containing a tree.
        </div>
        <div style="margin-bottom: 10px">
          Performing this action impacts <b>both the source tree and the planted seed</b>. Meaning both trees will be <b>dormant</b> until the next day.
        </div>
        <div style="margin-bottom: 10px">
          If both players send a seed to the same place on the same turn, neither seed is planted and the sun points are refunded. The source tree, however, still becomes dormant.
        </div>

        <!-- BEGIN level3 -->
      </div>
      <!-- END -->
      <center style="margin: 20px">
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574125792901" style="height: 152px; margin-bottom: 5px">
        <div>
          <em>Planting a seed</em>
        </div>
      </center>
      <!-- END -->

      <!-- BEGIN level2 level3 level4 -->
      <!-- BEGIN level2 level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        <h3 style="font-size: 14px;
          font-weight: 700;
          padding-top: 15px;
          color: #838891;
          padding-bottom: 15px;">
          Grow action</h3>

        <div style="margin-bottom: 10px">
        <ul>
          <!-- BEGIN level3 level4 -->
          <li>Growing a seed into a size <const>1</const> tree costs <const>1</const> sun point + the number of size <const>1</const> trees you already own. </li>
          <!-- END -->
          <li>Growing a size <const>1</const> tree into a size <const>2</const> tree costs <const>3</const> sun points + the number of size <const>2</const> trees you already own.</li>
          <li>Growing a size <const>2</const> tree into a size <const>3</const> tree costs <const>7</const> sun points + the number of size <const>3</const> trees you already own.</li>
        </ul>
        </div>
        <!-- BEGIN level2 level3 -->
      </div>
      <!-- END -->

      <center style="margin: 20px">
        <!-- BEGIN level2 -->
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574205785426" style="margin-bottom: 5px">
        <!-- END -->
        <!-- BEGIN level3 level4 -->
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574143463850" style="margin-bottom: 5px">
        <!-- END -->
        <div>
          <em>Growing a tree</em>
        </div>
      </center>

      <!-- END -->

      <h3 style="font-size: 14px;
              font-weight: 700;
              padding-top: 15px;
              color: #838891;
              padding-bottom: 15px;">
        Complete action </h3>

      <div style="margin-bottom: 10px">
        Completing a tree's lifecycle requires <const>4</const> sun points.<br>
        <!-- BEGIN level2 level3 level4 -->
        <!-- BEGIN level2 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        You can only complete the lifecycle of a size <const>3</const> tree.
        <!-- BEGIN level2 -->
      </div>
      <!-- END -->
      <!-- END -->
      </div>
      <div style="margin-bottom: 10px">
        The forest starts with a <var>nutrient</var> value of <const>20</const>.<br>
        Completing a tree's lifecycle will award you with as many points as the current <var>nutrient</var> value + a bonus according to the <var>richness</var> of the cell:<br>
      <ul>
        <li>
          <const>1</const>: <const>+0</const> points.
        </li>
        <li>
          <const>2</const>: <const>+2</const> points.
        </li>
        <li>
          <const>3</const>: <const>+4</const> points.
        </li>
      </ul>
      Then, the <var>nutrient</var> value is decreased permanently by <const>1</const>.
      </div>

      <h3 style="font-size: 14px;
                      font-weight: 700;
                      padding-top: 15px;
                      color: #838891;
                      padding-bottom: 15px;">
        ⛔ Game end</h3>

      <div style="margin-bottom: 10px">
        <!-- BEGIN level1 -->
        For this league, the game lasts <b>1 day</b>.
        <!-- END -->
        <!-- BEGIN level2 -->
      <div class="statement-new-league-rule">
        For this league, the game lasts the time it takes for the sun to circle around the board <b>1 time</b>. This means players have <b>6 days</b> to play.
      </div>
      <!-- END -->
      <!-- BEGIN level3 level4 -->
      <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        The game lasts the time it takes for the sun to circle around the board <b>4 times</b>. This means players have <b>24 days</b> to play.
        <!-- BEGIN level3 -->
      </div>
      <!-- END -->
      <!-- END -->

      </div>

      <!-- TODO: rename sun points to something else -->
      <div style="margin-bottom: 10px">Players gain an extra <const>1 point</const> for every 3 sun points they have at the end of the game.</div>

      <div style="margin-bottom: 10px">If players have the same score, the winner is the player with the most trees in the forest. Note that a seed is also considered a tree.</div>

      <!-- Victory conditions -->
      <div class="statement-victory-conditions">
        <div class="icon victory"></div>
        <div class="blk">
          <div class="title">Victory Conditions</div>
          <div class="text">
            <ul style="padding-top:0; padding-bottom: 0;">
              The winner is the player with the most <b>points</b>.
            </ul>
          </div>
        </div>
      </div>
      <!-- Lose conditions -->
      <div class="statement-lose-conditions">
        <div class="icon lose"></div>
        <div class="blk">
          <div class="title">Defeat Conditions</div>
          <div class="text">
            <ul style="padding-top:0; padding-bottom: 0;">
              Your program does not provide a command in the allotted time or it provides an unrecognized command.
            </ul>
          </div>
        </div>
      </div>
      <br>
      <h3 style="font-size: 14px;
                      font-weight: 700;
                      padding-top: 15px;
    color: #838891;
                      padding-bottom: 15px;">
        🐞 Debugging tips</h3>
      <ul>
        <li>Hover over a cell to see extra information about it</li>
        <li>Append text after any command and that text will appear next to your wood spirit</li>
        <li>Press the gear icon on the viewer to access extra display options</li>
        <li>Use the keyboard to control the action: space to play/pause, arrows to step 1 frame at a time</li>
      </ul>

    </div>
  </div>

  <!-- EXPERT RULES -->
  <div class="statement-section statement-expertrules">
    <h2>
      <span class="icon icon-expertrules">&nbsp;</span>
      <span>Technical Details</span>
    </h2>
    <div class="statement-expert-rules-content">
      <ul style="padding-left: 20px;padding-bottom: 0">
        <!-- BEGIN level3 level4 -->
        <li>Players start the game with two size <const>1</const> trees placed randomly along the edge of the grid.</li>
        <!-- END -->
        <!-- BEGIN level1 -->
        <li>Players start the game with size <const>3</const> trees placed randomly on the grid.</li>
        <!-- END -->
        <!-- BEGIN level2 -->
        <li>Players start the game with size <const>1</const> trees placed randomly on the grid.</li>
        <!-- END -->
        <!-- BEGIN level2 level3 level4 -->
        <li>Players that are asleep do not receive input.</li>
        <!-- END -->
        <li>If both players complete a lifecycle on the same turn, they both receive full points and the nutrient value is decreased by two.</li>
        <li>The <var>nutrient</var> value cannot drop below <const>0</const>.</li>
        <li>
          You can check out the source code of this game <a rel="nofollow" target="_blank"
            href="https://github.com/CodinGame/SpringChallenge2021">on this GitHub repo</a>.
        </li>
      </ul>
    </div>
  </div>


  <!-- PROTOCOL -->
  <div class="statement-section statement-protocol">
    <h2>
      <span class="icon icon-protocol">&nbsp;</span>
      <span>Game Protocol</span>
    </h2>

    <!-- Protocol block -->
    <div class="blk">
      <div class="title">Initialization Input</div>
      <span class="statement-lineno">First line:</span> <var>numberOfCells</var> equals <const>37</const>.<br>
      <span class="statement-lineno">Next <var>numberOfCells</var> lines:</span>
      <const>8</const> space-separated integers:
      <ul>
        <li><var>index</var> for the cell's index.</li>
        <li><var>richness</var> for its richness.</li>
        <!-- BEGIN level1 level2 -->
        <li>
          <const>6</const> <var>neigh</var> variables: <em>Ignore for this league.</em>
        </li>
        <!-- END -->
        <!-- BEGIN level3 level4 -->
        <!-- BEGIN level3 -->
        <li style="background: rgba(124, 197, 118, 0.1)">
        <!-- END -->
        <!-- BEGIN level4 -->
        <li>
        <!-- END -->
          <const>6</const> <var>neigh</var> variables, one for each <b>direction</b>, containing the index of a
          neighboring cell or <const>-1</const> is there is no neighbor.
        <!-- BEGIN level3 -->
        </li>
        <!-- END -->
        <!-- BEGIN level4 -->
        </li>
        <!-- END -->
        
        <!-- END -->
      </ul>
      <div class="text">

      </div>
    </div>
    <div class="blk">
      <div class="title">Input for One Game Turn</div>
      <div class="text">

        <!-- BEGIN level2 level3 -->
        <div class="statement-new-league-rule">
          <!-- END -->
          <span class="statement-lineno">First line:</span> An integer <var>day</var>:
          <!-- BEGIN level1 -->
          the current day. Equals <const>0</const> for this league.<br>
          <!-- END -->
          <!-- BEGIN level2 -->
          the current day, from <const>0</const> to <const>5</const>.<br>
          <!-- END -->
          <!-- BEGIN level3 level4 -->
          the current day, from <const>0</const> to <const>23</const>.<br>
          <!-- END -->
          <!-- BEGIN level2 level3 -->
        </div>
        <!-- END -->

        <span class="statement-lineno">Next line:</span> An integer <var>nutrients</var>: the current nutrient value of the forest.<br>
        <span class="statement-lineno">Next line:</span> 2 space-separated integers: <ul>
          <li><var>mySun</var>: your current sun points.</li>
          <li><var>myScore</var>: your current score.</li>
        </ul>

        <span class="statement-lineno">Next line:</span> 3 space-separated integers:
        <ul>
          <li><var>oppSun</var>: your opponent's sun points.</li>
          <li><var>oppScore</var>: your opponent's score.</li>
          <li><var>oppIsWaiting</var>: equals <const>1</const> if your opponent is asleep, <const>0</const> otherwise.
          </li>
        </ul>

        <span class="statement-lineno">Next line:</span> An integer <var>numberOfTrees</var> for the current number of trees in the forest.<br>
        <span class="statement-lineno">Next <var>numberOfTrees</var> lines:</span> 4 space-separated integers to describe each tree:
        <ul>
          <li><var>cellIndex</var>: the index of the cell this tree is on.</li>
          <li><var>size</var>: the size of the tree. From <const>0</const> (seed) to <const>3</const> (large tree).
          </li>
          <li><var>isMine</var>: <const>1</const> if you are the owner of this tree, <const>0</const> otherwise.</li>
          <li><var>isDormant</var>:
            <!-- BEGIN level1 -->
            <em>Ignore in this league.</em>
            <!-- END -->
            <!-- BEGIN level2 level3 level4 -->
            <const>1</const> if this tree is dormant, <const>0</const> otherwise.
            <!-- END -->

          </li>
        </ul>

        <span class="statement-lineno">Next line:</span> An integer <var>numberOfPossibleActions</var> for the number of legal moves you can make this turn.<br>
        <span class="statement-lineno">Next <var>numberOfPossibleActions</var> lines:</span> A string <var>possibleAction</var> containing one of the actions you can output this turn.<br>This list is provided to help you get started.<br>
      </div>
    </div>


    <!-- Protocol block -->
    <div class="blk">
      <div class="title">Output</div>
      <div class="text">
        A single line with your command:

        <!-- BEGIN level2 level3 -->
        <div class="statement-new-league-rule">
          <!-- END -->

          <ul style="padding-left: 20px;padding-top: 0">
            <!-- BEGIN level2 level3 level4 -->
            <li>
              <action>GROW index</action>: make your tree on cell <action>index</action> grow by <const>1</const> size.
            </li>
            <!-- END -->
            <!-- BEGIN level3 level4 -->
            <li>
              <action>SEED index0 index1</action>: make your tree on cell <action>index0</action> launch a seed onto cell <action>index1</action>.
            </li>
            <!-- END -->
            <li>
              <action>COMPLETE index</action>: make your large tree on the specified cell complete its lifecycle. This removes the tree.
            </li>
            <li>
              <!-- BEGIN level1 -->
              <action>WAIT</action>: go to sleep.
              <!-- END -->
              <!-- BEGIN level2 level3 level4 -->
              <action>WAIT</action>: go to sleep until the start of the next day.
              <!-- END -->
            </li>
          </ul>

          <!-- BEGIN level2 level3 -->
        </div>
        <!-- END -->
      </div>
    </div>

    <div class="blk">
      <div class="title">Constraints</div>
      <div class="text">
        Response time per turn ≤ <const>100</const>ms
        <br>Response time for the first turn ≤ <const>1000</const>ms
      </div>
    </div>
  </div>

  <!-- BEGIN level1 level2 -->
  <!-- LEAGUE ALERT -->
  <div style="color: #7cc576; 
                      background-color: rgba(124, 197, 118,.1);
                      padding: 20px;
                      margin-top: 10px;
                      text-align: left;">
    <div style="text-align: center; margin-bottom: 6px"><img
        src="//cdn.codingame.com/smash-the-code/statement/league_wood_04.png" /></div>

    <div style="text-align: center; font-weight: 700; margin-bottom: 6px;">
      What is in store for me in the higher leagues?
    </div>
    extra rules available in higher leagues are:
    <ul>
      <!-- BEGIN level1 -->
      <li>Help young trees grow.</li>
      <!-- END -->
      <li>Choose where to plant trees, trees will also cast shadows on neighbouring trees.</li>
    </ul>
  </div>
  <!-- END -->

</div>