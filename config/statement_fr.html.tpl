<!-- LEAGUES level1 level2 level3 level4 -->
<div id="statement_back" class="statement_back" style="display: none"></div>
<div class="statement-body">
  <!-- LEAGUE ALERT -->
  <div style="color: #7cc576; 
  background-color: rgba( 124 , 197 , 118 , 0.1 );
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
      Ce challenge se déroule en <b>ligues</b>.
    </p>
    <!-- END -->
    <span class="statement-league-alert-content">
      <!-- BEGIN level1 -->
      Pour ce challenge, plusieurs versions du même jeu seront disponibles. Quand vous aurez prouvé votre valeur dans la
      première version, vous accèderez à la ligue supérieure et débloquerez de nouvelles règles.<br>
      <br>
      <!-- END -->
      Des IAs de base sont disponibles dans le <a target="_blank" href="https://github.com/CodinGame/SpringChallenge2021/tree/main/starterAIs">kit de démarrage</a>. Elles peuvent vous aider à appréhender votre propre IA.
    </span>
  </div>

  <div style="padding: 20px;
    margin-right: 15px;
    margin-bottom: 10px;
    text-align: left;">
    <em>Vidéo tuto par Gaurav Sen: <a href="https://youtu.be/gZMdOiqchDk" rel="noopener" target="_blank" >https://youtu.be/gZMdOiqchDk</a></em>
  </div>


  <!-- GOAL -->
  <div class="statement-section statement-goal">
    <h2>
      <span class="icon icon-goal">&nbsp;</span>
      <span>Objectif</span>
    </h2>
    <div style="margin-bottom: 10px" class="statement-goal-content">
      <div>
        Gagner plus de <b>points</b> que votre adversaire.
      </div>
      <center style="margin: 20px">
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574189838986" style="margin-bottom: 5px">
      </center>
    </div>
    <div style="margin-bottom: 10px">
      Le jeu se déroule dans une <b>forêt</b>, dans laquelle de doux esprits résident. Ils sont responsable de veiller à
      ce que les arbres achèvent leur <b>cycles de vie</b>.
      <br>
      Deux esprits de la forêt sont en compétition pour la place de l'esprit le plus efficace.
    </div>
    Plantez et faites pousser stratégiquement les arbres de la forêt pour maximiser vos points.

  </div>
  <!-- RULES -->
  <div class="statement-section statement-rules">
    <h2>
      <span class="icon icon-rules">&nbsp;</span>
      <span>Règles</span>
    </h2>

    <div class="statement-rules-content">
      <div style="margin-bottom: 10px">
        Chaque joueur incarne un <b>esprit de la forêt</b>. Le jeu se déroule sur une grille hexagonale représentant la <b>forêt</b>.
      </div>
      <div style="margin-bottom: 10px">
        La partie se déroule sur plusieurs rounds appelés <b>jours</b>. Chaque jour peut être composé de plusieurs <b>tours</b> de jeu. À chaque tour, les deux joueurs font une action simultanément.
      </div>
      <!-- BEGIN level1 -->
      <div class="statement-new-league-rule">
        <div style="margin-bottom: 10px">
          Dans cette ligue, il n'y a que <const>1 jour</const>.
        </div>
      </div>
      <!-- END -->

      <h3 style="font-size: 14px;
    font-weight: 700;
    padding-top: 15px;
    color: #838891;
    padding-bottom: 15px;">
        Forêt</h3>

      <div style="margin-bottom: 10px">
        La forêt est composée de <const>37</const> cases hexagonales, arrangée en un plus grand hexagone.
        <!-- BEGIN level3 level4 -->
        <br>
      <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
      <!-- END -->
        Chaque case a un <b>indice</b> et jusqu'à 6 voisins. Les directions sont numérotées de <const>0</const> à <const>5</const>.

        <center style="margin: 20px">
          <img src="https://static.codingame.com/servlet/fileservlet?id=61694161023285" style="height: 226px; margin-bottom: 5px">
          <div>
            <em>Directions des cases</em>
          </div>
        </center>
        <br>

        La distance entre deux cases est égale au nombre minimum de cases qu'il faut parcourir pour aller de l'une à l'autre.
           <!-- BEGIN level3 -->
        </div>
         <!-- END -->
  <!-- END -->
      </div>


      <div style="margin-bottom: 10px">
        <!-- BEGIN level1 -->
        <div style="margin-bottom: 10px">
          Chaque case peut contenir un <b>arbre</b>. Chaque arbre appartient à l'un des joueurs.
        </div>
      <!-- END -->

      <!-- BEGIN level2 level3 level4 -->
      <!-- BEGIN level2 level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        <div style="margin-bottom: 10px">
          Chaque case peut contenir un <b>arbre</b>. Chaque arbre appartient à l'un des joueurs et possède une taille (<var>size</var>) :
        </div>

        <ul>
          <!-- BEGIN level3 level4 -->
          <li>
            <const>0</const> pour une <b>graine</b>.
          </li>
          <!-- END -->
          <li>
            <const>1</const> pour un petit arbre.
          </li>
          <li>
            <const>2</const> pour un arbre moyen.
          </li>
          <li>
            <const>3</const> pour un grand arbre.
          </li>
        </ul>
        <!-- BEGIN level2 level3 -->
      </div>
      <!-- END -->
      <!-- END -->
      </div>

      <div style="margin-bottom: 10px">
        Chaque case a une richesse (<var>richness</var>) qui peut valoir&nbsp;:
        <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        <ul>
          <!-- BEGIN level3 level4 -->
          <li>
            <const>0</const> pour les cases <b>inutilisables</b>. Rien ne peut pousser sur ces cases
          </li>
          <!-- END -->
          <li>
            <const>1</const> pour un sol de mauvaise qualité.
          </li>
          <li>
            <const>2</const> pour un sol de qualité moyenne.
          </li>
          <li>
            <const>3</const> pour un sol de bonne qualité.
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
        Jours</h3>

      <div style="margin-bottom: 10px">
        Au début de chaque jour, les joueurs recoivent des <b>points de soleil</b>.<br>
        Ensuite, les joueurs executent des <b>actions</b> en dépensant leurs points de soleil.<br>
        Le jour se termine quand tous les joueurs arrêtent d'agir.<br>
        Plus d'informations sur les actions et les points de soleil dans la suite de l'énoncé.
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
          Soleil et Ombres</h3>

        <div style="margin-bottom: 10px">
          Chaque arbre projette une ombre qui affecte un nombre de cases basé sur leur taille :
        <ul>
          <li>Les arbres de taille <const>1</const> projettent une ombre sur <const>1</const> case.</li>
          <li>Les arbres de taille <const>2</const> projettent une ombre sur <const>2</const> cases.</li>
          <li>Les arbres de taille <const>1</const> projettent une ombre sur <const>3</const> cases.</li>
        </ul>
        </div>

        <div style="margin-bottom: 10px">
          La direction de l'ombre dépend de la direction vers laquelle le <b> soleil </b> pointe.
          Au jour <const>0</const>, le soleil pointe vers la direction <const>0</const>, ce qui veut dire que toutes les ombres sont projetées vers la <b>droite</b>.
        </div>

        <div style="margin-bottom: 10px">
          Entre chaque jour, le soleil <b>tourne</b> pour pointer vers la directions suivante, revenant à <const>0</const> après la direction <const>5</const>.<br>
          La direction du soleil va donc toujours être égale au <const><var>day</var> modulo 6</const>.
        </div>

        <div style="margin-bottom: 10px">
          Aidant les esprits des bois, des <b>petits esprits</b> se cachent dans les arbres.<br>

          Ils vont trouver l'ombre sur leur case <b>menaçante</b> si elle est projetée par un arbre de taille (<var>size</var>) supérieure ou égale à leur arbre.
        </div>
        <div class="statement-examples">
          <h1>
            <span class="icon icon-example">&nbsp;</span>
            <span>Exemples</span>
          </h1>
          <div class="statement-example-container">

            <div class="statement-example statement-example-medium">
              <img src="https://static.codingame.com/servlet/fileservlet?id=61699027046513" />
              <div class="legend">
                <div class="description">
                  L'arbre moyen projette une ombre <b>menaçante</b> sur l'arbre petit.
                </div>
              </div>
            </div>
            <div class="statement-example statement-example-medium">
              <img src="https://static.codingame.com/servlet/fileservlet?id=61699004461164" />
              <div class="legend">
                <div class="description">
                  L'arbre moyen projette une ombre qui n'est <b>pas menaçante</b> sur l'arbre petit.
                </div>
              </div>
            </div>
            <div class="statement-example statement-example-medium">
              <img src="https://static.codingame.com/servlet/fileservlet?id=61699040950394" />
              <div class="legend">
                <div class="description">
                  L'arbre moyen projette une ombre <b>menaçante</b> sur l'autre arbre moyen, même si celui-ci est sur la dernière case de son ombre
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
        Points de soleil</h3>

      <!-- BEGIN level1 level2 -->
      <div style="margin-bottom: 10px">
        Aidant les esprits des bois, des <b>petits esprits</b> se cachent dans les arbres.<br>
      </div>
      <div style="margin-bottom: 10px">
        Les petits esprits de la forêt vont récupérer des <b>points de soleil</b> grâce à chaque arbre.<br>
        Les points seront données au joueur auquel appartient l'arbre.
      </div>
      <!-- END -->

      <!-- BEGIN level3 level4 -->
      <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        <div style="margin-bottom: 10px">
          Les petits esprits de la forêt vont récupérer des <b>points de soleil</b> grâce à chaque arbre qui n'est pas frappé par une ombre <b>menaçante</b>.<br>
          Les points seront données au joueur auquel appartient l'arbre.
        </div>
        <!-- BEGIN level3 -->
      </div>
      <!-- END -->
      <!-- END -->

      <div style="margin-bottom: 10px">
        <!-- BEGIN level1 -->
      <div class="statement-new-league-rule">
        <div style="margin-bottom: 10px">
          Dans cette ligue, vous gagnez <const>3</const> points de soleil par arbre.
        </div>
      </div>
      <!-- END -->

      <!-- BEGIN level2 level3 level4 -->
      <!-- BEGIN level2 level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        Le nombre de points récupérés dépend de la taille de l'arbre :

        <ul>
          <!-- BEGIN level3 level4 -->
          <li>Une arbre de taille <const>0</const> (une graine) : aucun point de soleil.</li>
          <!-- END -->
          <li>Une arbre de taille <const>1</const> : 1 point de soleil.</li>
          <li>Une arbre de taille <const>2</const> : 2 points de soleil.</li>
          <li>Une arbre de taille <const>3</const> : 3 points de soleil.</li>
        </ul>
        <!-- BEGIN level2 level3 -->
      </div>
      <!-- END -->
      <!-- END -->
      </div>
      <center style="margin: 20px">
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574060405023" style="height: 113px; margin-bottom: 5px">
        <div>
          <em>Un point de soleil</em>
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
        Après avoir collecté les points de soleil, chaque joueurs effectuent des <b>tours</b> simultanés en prenant l'une des deux actions possibles.
        <br>
        Tant que vous avez assez de points de soleil, vous pouvez prendre autant d'actions que vous souhaitez.
      </div>
      <div style="margin-bottom: 10px">
        Les actions possibles sont:
      <ul>
        <li>
          <action>COMPLETE</action> : Commandez à un arbre de compléter son cycle de vie. Cette action retire l'arbre de la forêt et vous fait marquer des points. Plus d'informations sur les points dans la suite de l'énoncé.
        </li>
        <li>
          <action>WAIT</action> : Passez le reste du jour à dormir et ne rien faire. Dans cette ligue, lorsque les deux joueurs dorment, la partie se termine
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
          Après avoir collecté les points de soleil, chaque joueurs effectuent des <b>tours</b> simultanés en prenant l'une des trois actions possibles.
          <!-- END -->
          <!-- BEGIN level3 level4 -->
          Après avoir collecté les points de soleil, chaque joueurs effectuent des <b>tours</b> simultanés en prenant l'une des quatre actions possibles.
          <!-- END -->
          <br>
          Tant que vous avez assez de points de soleil, vous pouvez prendre autant d'actions que vous souhaitez.
        </div>
        <div style="margin-bottom: 10px">
          Les actions possibles sont :
        <ul>
          <!-- BEGIN level3 -->
          <li style="background: rgba(124, 197, 118, 0.1)">
            <action>SEED</action> : Commandez à un arbre de lancer une graine sur une case dont la distance à l'arbre est inferieure ou égal à la taille de l'arbre.
          </li>
          <!-- END -->
          <!-- BEGIN level4 -->
          <li>
            <action>SEED</action> : Commandez à un arbre de lancer une graine sur une case dont la distance à l'arbre est inferieure ou égal à la taille de l'arbre.
          </li>
          <!-- END -->
          <li>
            <action>GROW</action> : Commandez à un arbre ou une graine de grandir jusqu'a la taille suivante. Les arbres peuvent grandir jusqu'à la taille <const>3
            </const>.
          </li>
          <li>
            <action>COMPLETE</action> : Commandez à un arbre de compléter son cycle de vie. Cette action retire l'arbre de la forêt et vous fait marquer des points. Plus d'informations sur les points dans la suite de l'énoncé.
          </li>
          <li>
            <action>WAIT</action> : Passez le reste du jour à dormir et ne rien faire. Lorsque les deux joueurs dorment, un nouveau jour commence et les deux joueurs se réveillent.
          </li>
        </ul>
        </div>
        <!-- BEGIN level2 -->
      </div>
      <!-- END -->
      Chaque arbre ayant effectué une action devient <b>endormi</b> pour le reste du jour. Un arbre endormi ne peut effectuer aucune action.
      <center style="margin: 20px">
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574084176910" style="height: 113px; margin-bottom: 5px">
        <div>
          <em>Un arbre endormi</em>
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
          Action Seed</h3>

        <div style="margin-bottom: 10px">
          Pour effectuer l'action Seed, vous devez dépenser un nombre de points de soleil égal au nombre de graines (arbres de taille <const>0</const>) présentes dans la forêt que vous possédez.
        </div>
        <div style="margin-bottom: 10px">
          Vous ne pouvez pas planter une graine sur une case <b>inutilisable</b> ou sur une case qui contient déjà un arbre.
        </div>
        <div style="margin-bottom: 10px">
          Cette action impacte l'arbre et la graine, ce qui signifies qu'ils seront tous les deux <b>endormis</b> avant le début du prochain jour.
        </div>
        <div style="margin-bottom: 10px">
          Si les deux joueurs plantent une graine au même endroit au même moment, aucun des deux graines n'est planté, les points de soleils sont rendus aux joueurs et les arbres ayant lancé les graines deviennent <b>endormis</b>
        </div>

        <!-- BEGIN level3 -->
      </div>
      <!-- END -->
      <center style="margin: 20px">
        <img src="https://static.codingame.com/servlet/fileservlet?id=61574125792901" style="height: 152px; margin-bottom: 5px">
        <div>
          <em>Planter une graine</em>
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
          Action Grow</h3>

        <div style="margin-bottom: 10px">
        <ul>
          <!-- BEGIN level3 level4 -->
          <li>Faire pousser une graine en un arbre de taille <const>1</const> coûte <const>1</const> point de soleil + le nombre d'arbres de taille <const>1</const> que vous possédez déjà.</li>
          <!-- END -->
          <li>Faire pousser un arbre de taille <const>1</const> en un arbre de taille <const>2</const> coûte <const>3 </const> points de soleil + le nombre d'arbres de taille <const>2</const> que vous possédez déjà.</li>
          <li>Faire pousser un arbre de taille <const>2</const> en un arbre de taille <const>3</const> coûte <const>7 </const> points de soleil + le nombre d'arbres de taille <const>3</const> que vous possédez déjà.</li>
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
          <em>Faire pousser un arbre</em>
        </div>
      </center>

      <!-- END -->

      <h3 style="font-size: 14px;
              font-weight: 700;
              padding-top: 15px;
              color: #838891;
              padding-bottom: 15px;">
        Action Complete</h3>

      <div style="margin-bottom: 10px">
        Compléter le cycle de vie d'un arbre coûte <const>4</const> points de soleil.<br>
        <!-- BEGIN level2 level3 level4 -->
        <!-- BEGIN level2 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        Vous ne pouvez compléter le cycle de vie que des arbres de taille <const>3</const>
        <!-- BEGIN level2 -->
      </div>
      <!-- END -->
      <!-- END -->
      </div>
      <div style="margin-bottom: 10px">
        La forêt commence avec une valeur de nutriments (<var>nutrient</var>) égale à <const>20</const>.<br>
        Compléter le cycle de vie d'un arbre vous rapportera autant de points que la valeur actuelle de nutriments (<var>nutrient</var>) + un bonus basé sur la richesse (<var>richness</var>) de la case :<br>
      <ul>
        <li>
          <const>1</const> : <const>+0</const> points.
        </li>
        <li>
          <const>2</const> : <const>+2</const> points.
        </li>
        <li>
          <const>3</const> : <const>+4</const> points.
        </li>
      </ul>
      Ensuite, la valeur de nutriments (<var>nutrient</var>) est réduite de <const>1</const> de manière permanente.
      </div>


      <h3 style="font-size: 14px;
                      font-weight: 700;
                      padding-top: 15px;
                      color: #838891;
                      padding-bottom: 15px;">
        ⛔ Fin du jeu</h3>

      <div style="margin-bottom: 10px">
        <!-- BEGIN level1 -->
        Pour cette ligue, le jeu dure <b>1 jour</b>.
        <!-- END -->
        <!-- BEGIN level2 -->
      <div class="statement-new-league-rule">
        Pour cette ligue, le jeu dure le temps qu'il faut au soleil pour tourner autour du plateau <b>1 fois</b>. Ce qui signifie que les joueur disposent de <b>6 jours</b> pour jouer.
      </div>
      <!-- END -->
      <!-- BEGIN level3 level4 -->
      <!-- BEGIN level3 -->
      <div class="statement-new-league-rule">
        <!-- END -->
        Pour cette ligue, le jeu dure le temps qu'il faut au soleil pour tourner autour du plateau <b>4 fois</b>. Ce qui signifie que les joueur disposent de <b>24 jours</b> pour jouer.
        <!-- BEGIN level3 -->
      </div>
      <!-- END -->
      <!-- END -->

      </div>

      <!-- TODO: rename sun points to something else -->
      <div style="margin-bottom: 10px">Les joueurs gagnent <const>1 point</const> bonus par tranche de 3 points de soleil qu'il leur reste à la fin du jeu.</div>

      <div style="margin-bottom: 10px">Si les joueurs ont le même score, le gagnant est le joueur qui possède le plus d'arbres dans la forêt. Notez qu'une graine est aussi considéré comme étant un arbre.</div>

      <!-- Victory conditions -->
      <div class="statement-victory-conditions">
        <div class="icon victory"></div>
        <div class="blk">
          <div class="title">Conditions de victoire</div>
          <div class="text">
            <ul style="padding-top:0; padding-bottom: 0;">
              Le gagnant est le joueur avec le plus grand nombre de <b>points</b>.
            </ul>
          </div>
        </div>
      </div>
      <!-- Lose conditions -->
      <div class="statement-lose-conditions">
        <div class="icon lose"></div>
        <div class="blk">
          <div class="title">Condition de défaite</div>
          <div class="text">
            <ul style="padding-top:0; padding-bottom: 0;">
              Vous effectuez une action invalide ou votre programme ne répond pas dans les temps.
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
        🐞 Conseils de débogage</h3>
      <ul>
        <li>Survolez une case pour voir davantage d'informations</li>
        <li>Ajoutez du texte à la fin d'une instruction pour afficher ce texte à côté de votre esprit des bois</li>
        <li>Cliquez sur la roue dentée pour afficher des options supplémentaires</li>
        <li>Utilisez le clavier pour contrôler les actions : espace pour lire/mettre en pause, les flèches pour avancer pas à pas</li>
      </ul>

    </div>
  </div>

  <!-- EXPERT RULES -->
  <div class="statement-section statement-expertrules">
    <h2>
      <span class="icon icon-expertrules">&nbsp;</span>
      <span>Détails techniques</span>
    </h2>
    <div class="statement-expert-rules-content">
      <ul style="padding-left: 20px;padding-bottom: 0">
        <!-- BEGIN level3 level4 -->
        <li>Les joueurs commencent la partie avec deux arbres de taille <const>1</const> placés aléatoirement sur le bord de la grille.</li>
        <!-- END -->
        <!-- BEGIN level1 -->
        <li>Les joueurs commencent la partie avec des arbres de taille <const>3</const> placés aléatoirement sur la grille.</li>
        <!-- END -->
        <!-- BEGIN level2 -->
        <li>Les joueurs commencent la partie avec des arbres de taille <const>1</const> placés aléatoirement sur la grille.</li>
        <!-- END -->
        <!-- BEGIN level2 level3 level4 -->
        <li>Les joueurs qui dorment ne reçoivent pas d'information.</li>
        <!-- END -->
        <li>Si les deux joueurs complètent le cycle de vie d'un arbre au même tour, ils recoivent tous les deux tous les points, puis la valeur des nutriments est baissée de 2.</li>
        <li>La valeur des nutriments (<var>nutrient</var>) ne peux pas descendre en dessous de <const>0</const>.</li>
        <li>
          Vous pouvez voir le code source sur
          <a rel="nofollow" target="_blank" href="https://github.com/CodinGame/SpringChallenge2021">ce repo GitHub</a>.
        </li>
      </ul>
    </div>
  </div>


  <!-- PROTOCOL -->
  <div class="statement-section statement-protocol">
    <h2>
      <span class="icon icon-protocol">&nbsp;</span>
      <span>Protocole de jeu</span>
    </h2>

    <!-- Protocol block -->
    <div class="blk">
      <div class="title">Initialization Input</div>
      <span class="statement-lineno">Ligne 1 :</span> <var>numberOfCells</var> égal à <const>37</const>.<br>
      <span class="statement-lineno">Les <var>numberOfCells</var> lignes suivantes :</span>
      <const>8</const> entiers :
      <ul>
        <li><var>index</var> pour l'indice de la case.</li>
        <li><var>richness</var> pour sa richesse.</li>
        
        <!-- BEGIN level1 level2 -->
        <li>
          <const>6</const> variables <var>neigh</var> : <em>Ignorez pour cette ligue.</em>
        </li>
        <!-- END -->
        <!-- BEGIN level3 level4 -->
        <!-- BEGIN level3 -->
        <li style="background: rgba(124, 197, 118, 0.1)">
        <!-- END -->
        <!-- BEGIN level4 -->
        <li>
        <!-- END -->

        <li>
          <const>6</const> variables <var>neigh</var>, une pour chaque <b>direction</b>, contenant l'index de la case
          voisine, <const>-1</const> si il n'y a pas de case voisine.
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
      <div class="title">Entrées pour un tour de jeu</div>
      <div class="text">

        <!-- BEGIN level2 level3 -->
        <div class="statement-new-league-rule">
          <!-- END -->
          <span class="statement-lineno">Ligne 1 :</span> Un entier <var>day</var> :
          <!-- BEGIN level1 -->
          le jour actuel. Égal à <const>0</const> pour cette ligue.<br>
          <!-- END -->
          <!-- BEGIN level2 -->
          le jour actuel, de <const>0</const> à <const>5</const>.<br>
          <!-- END -->
          <!-- BEGIN level3 level4 -->
          le jour actuel, de <const>0</const> à <const>23</const>.<br>
          <!-- END -->
          <!-- BEGIN level2 level3 -->
        </div>
        <!-- END -->

        <span class="statement-lineno">Ligne suivante :</span> Un entier <var>nutrients</var> : la valeur actuelle de nutriments de la forêt.<br>
        <span class="statement-lineno">Ligne suivante :</span> 2 entiers : <ul>
          <li><var>mySun</var> : votre nombre actuel de points de soleil.</li>
          <li><var>myScore</var> : votre score actuel.</li>
        </ul>

        <span class="statement-lineno">Ligne suivante :</span> 3 entiers :
        <ul>
          <li><var>oppSun</var> : le nombre actuel de points de soleil de votre adversaire.</li>
          <li><var>oppScore</var> : le score actuel de votre adversaire.</li>
          <li><var>oppIsWaiting</var> : égal à <const>1</const> si votre adversaire dort, <const>0</const> sinon.
          </li>
        </ul>

        <span class="statement-lineno">Ligne suivante :</span> Un entier <var>numberOfTrees</var> pour le nombre actuel d'arbres dans la forêt.<br>
        <span class="statement-lineno">Les <var>numberOfTrees</var> lignes suivantes :</span> 4 entiers décrivant chaque arbre :
        <ul>
          <li><var>cellIndex</var> : l'indice de la case sur laquelle l'arbre se trouve.</li>
          <li><var>size</var> : la taille de l'arbre. De <const>0</const> (graine) à <const>3</const> (grand arbre).
          </li>
          <li><var>isMine</var> : <const>1</const> si vous possédez l'arbre, <const>0</const> sinon.</li>
          <li><var>isDormant</var> :
            <!-- BEGIN level1 -->
            <em>Ignorez pour cette ligue.</em>
            <!-- END -->
            <!-- BEGIN level2 level3 level4 -->
            <const>1</const> si l'arbre est endormi, <const>0</const> sinon.
            <!-- END -->

          </li>
        </ul>

        <span class="statement-lineno">Ligne suivante :</span> Un entier <var>numberOfPossibleActions</var> pour le nombre d'actions valides que vous pouvez faire ce tour.<br>
        <span class="statement-lineno">Les <var>numberOfPossibleActions</var> lignes suivantes :</span> Une chaîne de caractères  <var>possibleAction</var> contenant une des actions que vous pouvez renvoyer ce tour-ci.<br>Cette liste est présente pour vous aider à débuter.<br>
      </div>
    </div>


    <!-- Protocol block -->
    <div class="blk">
      <div class="title">Output</div>
      <div class="text">
        Une seule ligne contenant votre action :

        <!-- BEGIN level2 level3 -->
        <div class="statement-new-league-rule">
          <!-- END -->

          <ul style="padding-left: 20px;padding-top: 0">
            <!-- BEGIN level2 level3 level4 -->
            <li>
              <action>GROW index</action> : faites grandir votre arbre sur la case <action>index</action> de <const>1</const> taille.
            </li>
            <!-- END -->
            <!-- BEGIN level3 level4 -->
            <li>
              <action>SEED index0 index1</action> : faites que votre arbre sur la case <action>index0</action> lance une graine sur la case <action>index1</action>.
            </li>
            <!-- END -->
            <li>
              <action>COMPLETE index</action> : faites que l'arbre de grande taille sur la case <action>index</action> complète son cycle de vie. Cette action libère la case
            </li>
            <li>
              <!-- BEGIN level1 -->
              <action>WAIT</action> : endormez-vous.
              <!-- END -->
              <!-- BEGIN level2 level3 level4 -->
              <action>WAIT</action> : endormez-vous jusqu'au début du prochain jour.
              <!-- END -->
            </li>
          </ul>

          <!-- BEGIN level2 level3 -->
        </div>
        <!-- END -->
      </div>
    </div>

    <div class="blk">
      <div class="title">Contraintes</div>
      <div class="text">
        Temps de réponse par tour ≤ <const>100</const>ms<br>
        Temps de réponse au premier tour ≤ <const>1000</const>ms
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
      Qu'est-ce qui m'attend dans les prochaines ligues ?
    </div>
    Les nouvelles règles débloquées dans les prochaines ligues sont&nbsp;:
    <ul>
      <!-- BEGIN level1 -->
      <li>Aider les arbres à grandir.</li>
      <!-- END -->
      <li>Choisir où planter ses arbres et projeter des ombres sur la forêt.</li>
    </ul>
  </div>
  <!-- END -->

</div>