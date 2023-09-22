this.confront_warlord_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.confront_warlord";
		this.m.Name = "Confront Orc Warlord";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 1800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Score", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Détruisez tous les groupes de Peaux-Vertes et leurs camps pour attirer leur Chef de Guerre",
					"Tuez le Chef de Guerre Orc"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				this.Flags.set("MaxScore", 10 * this.Contract.getDifficultyMult());
				this.Flags.set("LastRandomTime", 0.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsBerserkers", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
			}

			function update()
			{
				if (this.Flags.get("Score") >= this.Flags.get("MaxScore"))
				{
					this.Contract.setScreen("FinalConfrontation1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("JustDefeatedGreenskins"))
				{
					this.Flags.set("JustDefeatedGreenskins", false);
					this.Contract.setScreen("MadeADent");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("LastRandomTime") + 300.0 <= this.Time.getVirtualTimeF() && this.Contract.getDistanceToNearestSettlement() >= 5 && this.Math.rand(1, 1000) <= 1)
				{
					this.Flags.set("LastRandomTime", this.Time.getVirtualTimeF());
					this.Contract.setScreen("ClosingIn");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBerserkersDone"))
				{
					this.Flags.set("IsBerserkersDone", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("Berserkers3");
					}
					else
					{
						this.Contract.setScreen("Berserkers4");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBerserkers") && !this.TempFlags.has("IsBerserkersShown") && this.Contract.getDistanceToNearestSettlement() >= 7 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsBerserkersShown", true);
					this.Contract.setScreen("Berserkers1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onLocationDestroyed( _location )
			{
				local f = this.World.FactionManager.getFaction(_location.getFaction());

				if (f.getType() == this.Const.FactionType.Orcs || f.getType() == this.Const.FactionType.Goblins)
				{
					this.Flags.set("Score", this.Flags.get("Score") + 4);
					this.Flags.set("JustDefeatedGreenskins", true);
				}
			}

			function onPartyDestroyed( _party )
			{
				local f = this.World.FactionManager.getFaction(_party.getFaction());

				if (f.getType() == this.Const.FactionType.Orcs || f.getType() == this.Const.FactionType.Goblins)
				{
					this.Flags.set("Score", this.Flags.get("Score") + 2);
					this.Flags.set("JustDefeatedGreenskins", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Berserkers")
				{
					this.Flags.set("IsBerserkersDone", true);
					this.Flags.set("IsBerserkers", false);
					this.Flags.set("Score", this.Flags.get("Score") + 2);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Warlord",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Tuez le Chef de Guerre Orc"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithWarlord.bindenv(this));
				}

				this.Flags.set("IsWarlordEncountered", false);
			}

			function update()
			{
				if (this.Flags.get("IsWarlordDefeated") || this.Contract.m.Destination == null || this.Contract.m.Destination.isNull() || !this.Contract.m.Destination.isAlive())
				{
					this.Contract.setScreen("FinalConfrontation3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithWarlord( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.Flags.get("IsWarlordEncountered"))
				{
					this.Flags.set("IsWarlordEncountered", true);
					this.Contract.setScreen("FinalConfrontation2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.OrcsTracks;
					properties.AfterDeploymentCallback = this.OnAfterDeployment.bindenv(this);
					this.World.Contracts.startScriptedCombat(properties, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

			function OnAfterDeployment()
			{
				local all = this.Tactical.Entities.getAllInstances();

				foreach( f in all )
				{
					foreach( e in f )
					{
						if (e.getType() == this.Const.EntityType.OrcWarlord)
						{
							e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
							e.getFlags().add("IsFinalBoss", true);
							break;
						}
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsWarlordDefeated", true);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous trouvez %employer% en train de marcher dans ses écuries. Il passe sa main sur un cheval. %SPEECH_ON% Saviez-vous qu\'un orc peut briser le cou de cette créature par sa seule force brute ? Je l\'ai vu. Je le sais, car c\'est mon cheval qui est mort, la tête tournée vers l\'arrière à cause d\'une peau verte très en colère.%SPEECH_OFF%Remonter le temps, c\'est bien, mais ce n\'est pas pour cela que vous êtes ici. Vous demandez subtilement au noble d\'en venir au fait. Il s\'exécute.%SPEECH_ON%Bien. La guerre avec les peaux-vertes ne se passe pas aussi bien que nous le souhaiterions, et j\'en suis arrivé à la conclusion que nous devions tuer l\'un de leurs chefs de guerre. Je vais être honnête avec vous : un orc physiquement supérieur à tous ses petits frères de merde est un cauchemar en chair et en os. Le meilleur moyen de le faire sortir est de tuer le plus grand nombre possible de ses frères à peau verte. Je sais que ça a l\'air dur, mais une fois que tout sera dit et fait, nos chances de gagner cette maudite guerre seront bien meilleures.%SPEECH_OFF% | %employer% vous accueille dans sa chambre. Il regarde une carte avec inquiétude.%SPEECH_ON%{Mes éclaireurs ont signalé la présence d\'un seigneur de guerre dans la région, mais nous ne savons pas exactement où il se trouve. J\'ai l'intuition que si vous allez là-bas et que vous causez beaucoup de problèmes à ces bâtards verts, il pourrait bien venir jouer. Vous comprenez ? | On nous a rapporté qu\'un seigneur de guerre orc rôdait dans les terres. Je pense que si nous parvenons à le tuer, le moral des orcs baissera et nous pourrons peut-être gagner cette maudite guerre. Bien sûr, il ne sera pas facile à trouver. Vous devrez faire en sorte que ce gros bâtard se montre et je crois que la meilleure façon d\'y parvenir est de parler la langue orque : tuer autant que vous le pouvez. Bien sûr, tuez les peaux vertes. Ne faites pas n\'importe quoi. | Je suis heureux que tu sois venu, mercenaire, car j\'ai une tâche à te confier. Nous avons appris qu\'un seigneur de guerre orc se trouvait dans la région, mais nous ne savons pas où il est. Je veux que tu ailles pratiquer un peu de diplomatie orque : tue autant de ces sauvages verts que tu peux et ce chef de guerre ne manquera pas de se faire connaître à toi. Si nous parvenons à le mettre hors d\'état de nuire, cette guerre sera bien plus belle pour notre camp. }%SPEECH_OFF% | %employer% est entouré de ses lieutenants et d'un gamin à l\'air très fatigué, aux bottes boueuses et au visage trempé de sueur. L\'un des commandants s\'avance et vous emmène sur le côté. %SPEECH_ON%Nous avons appris l\'existence d\'un seigneur de guerre orc. La famille de ce gamin a payé le prix de l\'avoir vu de ses propres yeux. %employer% je croit, et je suis d\'accord avec le seigneur, que si nous pouvons tuer autant de peaux vertes que possible, nous pourrons amener ce seigneur de guerre à se montrer.%SPEECH_OFF%Vous vous penchez en arrière et répondez.%SPEECH_ON%Et laissez-moi deviner, vous voulez que je prenne sa tête?%SPEECH_OFF%Le commandant hausse les épaules.%SPEECH_ON%Ce n\'est pas trop demander, n\'est ce pas ? Mon seigneur est prêt à payer beaucoup de couronnes pour ce travail.%SPEECH_OFF% | %employer% est assis au milieu d\'une meute de chiens épuisés. Il y a des plumes de faisan dans leurs gueules, qui voltigent entre deux respirations ronflantes. Le seigneur vous fait signe d\'entrer.%SPEECH_ON%Entrez, mercenaire. Je viens de terminer une chasse. Par coïncidence, j\'ai besoin de t\'envoyer en faire une. %SPEECH_OFF%Vous vous asseyez. L\'un des chiens lève la tête, souffle, puis la baisse pour se rendormir. Vous demandez ce que veut le noble. Il explique rapidement tout en frottant l\'une des oreilles du chien.%SPEECH_ON%J\'ai appris qu\'un seigneur de guerre orc rôdait. Où cela ? Je n\'en ai aucune idée. Mais je pense que vous pouvez le débusquer. Vous savez comment faire, n\'est-ce pas ? %SPEECH_OFF%Vous acquiescez et répondez.%SPEECH_ON%Oui. Vous continuez à tuer ses soldats jusqu\'à ce qu\'il soit assez énervé pour venir vous combattre personnellement. Mais ce n\'est pas une demande à la légère, %employer%.%SPEECH_OFF%Le noble sourit et ouvre les mains comme pour dire : Parlons affaires. Son chien lève les yeux comme pour dire : Seulement si ce travail signifie que tu continues à me gratter les oreilles. | %employer% est assis derrière un long bureau dont les deux extrémités sont recouvertes d\'une carte encore plus longue. L\'un de ses scribes lui chuchote à l\'oreille puis se précipite vers vous.%SPEECH_ON%Mon seigneur a une requête à formuler. Nous pensons qu\'un chef de guerre orc se trouve dans la région et, naturellement, nous voulons que ce sauvage soit abattu. Pour ce faire, nous...%SPEECH_OFF%Vous levez la main et vous interrompez.%SPEECH_ON%Oui, Je sais comment l\'attirer. Nous tuons autant de ces fils de pute que nous le pouvons jusqu\'à ce que le grand type vert en colère vienne à notre rencontre.%SPEECH_OFF%Le scribe sourit chaleureusement.%SPEECH_ON%Oh, alors vous avez lu les livres sur cette tactique, vous aussi ? C\'est génial ! %SPEECH_OFF%Votre regard s\'assombrit toujours aussi gracieusement, mais vous passez à autre chose et commencez à vous renseigner sur la rémunération potentielle. | %employer% vous reçoit dans son bureau. Il est en train de retirer des livres des étagères, de grands panaches de poussière traînant après chaque retrait.%SPEECH_ON%Venez, asseyez-vous.%SPEECH_OFF%Vous le faites et il vous apporte l\'un des tomes. Il l\'ouvre à une page et montre l\'image criarde d\'un énorme orc.%SPEECH_ON%Vous les connaissez, oui ? %SPEECH_OFF%Vous acquiescez. C\'est un seigneur de guerre, le chef d\'une bande d\'orques et le rouage autour duquel tourne un torrent de violence qui s\'étend sur le monde. Le noble acquiesce et poursuit %SPEECH_ON%%Je fais quelques recherches sur eux car mes éclaireurs m\'en ont signalé un. Bien sûr, nous ne pourrons jamais suivre à la trace cette maudite chose. Elle va où elle veut, et partout où elle va, elle détruit.%SPEECH_OFF%Vous arrêtez le noble et lui expliquez une stratégie simple : si vous tuez suffisamment de peaux vertes, le seigneur de guerre sera offensé, ou peut-être enhardi par le défi, personne ne le sait vraiment, et il sortira pour se battre. %employer% sourit.%SPEECH_ON%Tu vois, mercenaire, c\'est pour ça que je t\'aime bien. Tu sais ce que tu fais. Bien sûr, je pense qu\'il est prudent de supposer que ce genre de choses n\'est pas facile à faire. Le salaire sera plus qu\'à la hauteur.%SPEECH_OFF% | %employer% se penche sur un monticule de parchemins que son scribe est en train d\'apporter. Il n'arrête pas de secouer la tête.%SPEECH_ON%Aucun d\'entre eux ne dit comment on le trouve ! Si nous ne pouvons pas le trouver de manière fiable, comment pouvons-nous le tuer de manière fiable ? C\'est du simple calcul ! Je croyais que tu connaissais les maths !%SPEECH_OFF%Le scribe s\'éloigne en reniflant et en fixant le sol tout en se dépêchant de sortir de la pièce. Vous demandez quel est le problème. %employer% soupire et annonce qu\'un seigneur de guerre orc est dans la région mais qu\'ils ne savent pas comment l\'arrêter. Vous riez et répondez : %SPEECH_ON%C\'est facile : vous parlez leur langue. Vous tuez autant de ces bâtards que vous le pouvez jusqu\'à ce que ce chef de guerre soit obligé de venir vous voir personnellement. Les orques adorent la violence, ils sont nés pour ça et ont même probablement été élevés pour ça. Bien sûr, tuer le seigneur de guerre n\'est pas particulièrement facile...%SPEECH_OFF%%employer% se penche en avant et tend ses doigts.%SPEECH_ON%Oui, bien sûr que non, mais vous avez l\'air d\'être l\'homme de la situation. Et ce travail pourrait vraiment faire basculer cette maudite guerre en notre faveur. Parlons affaires.%SPEECH_OFF% | Vous trouvez %employer% en train de parcourir son jardin. Il semble particulièrement attiré par les tiges des plantes.%SPEECH_ON% Assez étrange, n\'est-ce pas ? Nous avons ces choses si vertes, et pourtant ces bâtards à la peau verte sont verts eux aussi, et je ne pense pas qu\'ils aient mangé un seul légume de toute leur vie. %SPEECH_OFF%Vous avez envie de dire que c\'est une observation assez stupide, mais vous vous retenez. Au lieu de cela, vous demandez quel est le problème avec les peaux vertes, car cela semble être le problème sous-entendu. %employer% acquiesce.%SPEECH_ON%D\'accord, bien sûr. Mes éclaireurs ont repéré un seigneur de guerre dans la région. Le problème, c\'est que nous ne savons pas où il se trouve ni où il va. Les éclaireurs ne peuvent pas rester longtemps sur place, sinon ils se feront tuer pour des raisons évidentes. Je pense que tuer ce seigneur de guerre nous aiderait à faire un pas de plus vers la fin de cette maudite guerre, mais je n\'ai pas la moindre idée de la façon de procéder, et vous ? %SPEECH_OFF%Vous acquiescez et répondez.%SPEECH_ON%Ce qui vous pousse à vouloir tuer le seigneur de guerre, c\'est le fait qu\'il tue votre peuple, n\'est-ce pas ? Alors qu\'est-ce qui le pousserait à vouloir nous tuer personnellement ? On tue autant de ses bâtards que possible.%SPEECH_OFF%Le noble applaudit et vous lance une tomate rouge vif.%SPEECH_ON%C\'est bien pensé, mercenaire. Parlons affaires !%SPEECH_OFF% | Vous trouvez %employer% et ses commandants autour d\'une carte. Ils pivotent vers vous lorsque vous entrez dans la pièce, comme une bande de faucons repérant un lapin. Le noble vous souhaite la bienvenue.%SPEECH_ON%Bonjour, mercenaire, nous sommes un peu sur les nerfs. Nos éclaireurs nous ont signalé qu\'un seigneur de guerre orc rôde dans la région en ce moment même. Le problème, c\'est que nous ne savons pas exactement où il va ni comment le trouver. Mes commandants pensent que si nous tuons autant de peaux vertes que possible, le chef de guerre se montrera et nous pourrons alors le tuer. Pensez-vous être à la hauteur de cette tâche ? Si oui, parlons affaires. %SPEECH_OFF% | Vous entrez dans la chambre de %employer% pour le trouver en train de consulter un groupe de scribes. Ils tremblent visiblement, pincent leurs colliers et se tortillent dans tous les sens. L\'un d\'eux vous montre du doigt.%SPEECH_ON%Peut-être a-t-il une idée ? %SPEECH_OFF%Les autres se moquent, mais vous demandez quel est le problème. %employer% explique qu\'un seigneur de guerre orc erre dans les terres, mais qu\'ils ont du mal à le localiser. Vous acquiescez consciencieusement, puis vous expliquez une solution très simple : %SPEECH_ON%Tuer autant de peaux vertes que possible et le seigneur de guerre, qui est une bête de nature orgueilleuse, sortira pour vous combattre. Ou, dans ce cas, viendra se battre... contre moi... %SPEECH_OFF%%employer% hoche la tête.%SPEECH_ON%Vous avez la tête sur les épaules, mercenaire. Parlons affaires.%SPEECH_OFF% | %employer% se tient avec ses commandants devant des cartes.%SPEECH_ON%Nous avons une sacrée tâche à te confier, mercenaire. Nos éclaireurs ont repéré un seigneur de guerre qui rôde dans la région et nous avons besoin que tu tues autant de peaux vertes que possible pour le faire sortir du bois. Si nous parvenons à prendre la tête de ce seigneur de guerre, nous serons plus près de mettre fin à cette maudite guerre.%SPEECH_OFF% | Lorsque vous entrez dans la chambre de %employer%, il vous demande si vous vous y connaissez en matière de chasse aux seigneurs de guerre orcs. Vous haussez les épaules et répondez.%SPEECH_ON%Ils répondent au langage de la violence. Si vous voulez parler à l\'un d\'entre eux, vous devez tuer un grand nombre de ses semblables. C\'est le seul moyen de l\'amener à sortir et à jouer, pour ainsi dire.%SPEECH_OFF%Le noble acquiesce, il comprend. Il fait glisser un papier sur son bureau.%SPEECH_ON%J\'ai peut-être quelque chose à vous proposer. Nous avons appris l\'existence d\'un chef de guerre orc dans notre région, mais nous avons du mal à le retrouver. Je veux que vous l\'attiriez et que vous le tuiez. Si nous y parvenons, nos chances de gagner cette guerre contre ces sauvages verts seront décuplées !%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{J\'imagine que vous allez payer chère pour ça. | Tout peut être fait si la paie est juste. | Convainquez-moi avec de la monnaie sonnante et trébuchante.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé autre part.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ClosingIn",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Un petit tas de crânes humains fraîchement déplacés. %randombrother% fixe le totem des visages angoissés et secoue la tête.%SPEECH_ON%Tu crois qu\'ils considèrent ça comme de l\'art ? Est-ce que l\'un de ces sauvages a pris du recul et s'est dit : Oui, ça a l\'air bien ?%SPEECH_OFF%Vous n\'êtes pas sûr. Vous espérez vraiment que les humains ne sont pas le pinceau et la toile des peaux vertes. | Vous tombez sur un champ d\'animaux de ferme abattus. Les entrailles ont coulé sur les sols ondulés de la ferme comme une irrigation sanguinaire. Soit un fermier a terriblement mal interprété la météo, soit c\'est un signe certain que les orcs sont proches. | Des cadavres. Certains coupés en deux, d\'autres plutôt paisibles avec quelques fléches dans le dos. Les deux formes de finalité sont un signe certain de la proximité des peaux-vertes. | Vous arrivez à un campement abandonné de peaux vertes. Il y a un gobelin dont la tête a été écrasée. Il s\'est peut-être battu avec un orc plus grand et plus fort. Une forme effroyable est posée sur une broche. Il ne reste plus qu\'à espérer que ce soit pas ce que l\'on croit. %randombrother% montre les braises qui crépitent sous le repas.%SPEECH_ON%c\'est tout frais. Ils ne sont pas loin, monsieur.%SPEECH_OFF% | Vous arrivez dans une grange dont les portes s\'ouvrent et se ferment en grinçant sous l\'effet d'un vent âcre. %randombrother% se précipite ensuite vers l\'intérieur, puis revient rapidement en arrière en portant la main à son nez.%SPEECH_ON%Oui, les peaux vertes sont passées par là.%SPEECH_OFF%En vous épargnant un coup d\'œil dans la grange, vous dites aux hommes de se préparer à la bataille, car elle ne manquera pas d\'arriver. | Vous trouvez un orc mort avec un gobelin mort sur son dos. En poussant les deux corps, vous trouvez un fermier mort en dessous. %randombrother% acquiesce.%SPEECH_ON%Il s\'est bien battu. Dommage qu\'on n\'ait pas pu arriver plus tôt.%SPEECH_OFF%Vous montrez des traces fraîches dans la boue.%SPEECH_ON%Il etait en infériorité numérique et les autres ne sont pas loin. Dites aux hommes de se préparer au combat.%SPEECH_OFF% | Vous tombez sur un homme enveloppé de lourdes chaînes et, apparemment, écrasé à mort par celles-ci. Son corps violacé et écrasé grince et tressaille tandis que les chaînes se balancent et se tordent. %randombrother%descend les corps. Le cadavre crache du sang noir par la bouche et le mercenaire s\'éloigne d\'un bond.%SPEECH_ON%Bon sang, ce type est frais ! Celui qui a fait ça n\'est pas loin !%SPEECH_OFF%Vous lui montrez des traces dans la boue et lui dites qu\'il s'agit sans aucun doute de l\'œuvre de peaux vertes et qu\'elles sont en effet très proches. | Vous trouvez sur la route un sac fait de chair. À l\'intérieur, il y a des oreilles humaines, tannées et rigides, avec des trous pour faire un collier. %randombrother% baille. Vous informez les hommes que les peaux vertes ne sont pas loin. La bataille approche à grands pas ! | Vous tombez sur les restes d\'une maison. Des braises crépitent dans les restes noircis. %randombrother% trouve un couple de squelettes et remarque qu\'il leur manque la moitié du corps. Voyant des traces profondes dans la boue cendrée, vous informez les hommes de se préparer car des peaux vertes sont sans doute proches. | Vous trouvez un homme qui sanglote au bord de la route. Il est assis les jambes croisées, le corps balançant d\'avant en arrière. Lorsque vous vous en approchez, il tourne la tête, sans yeux, sans nez et avec les lèvres coupées.%SPEECH_ON%Arrêtez ! S'il vous plaît, pitier !%SPEECH_OFF%Il tombe sur le côté et commence à convulser, puis reste immobile. %randombrother%fait le tour du corps, puis se lève en secouant la tête.%SPEECH_ON%peaux vertes?%SPEECH_OFF%Vous montrez les traces profondes dans la boue et vous acquiescez. | Vous tombez sur une femme qui se lamente sur un cadavre. Elle dégouline de sang et de chair, et le corps qui se trouve sous ses genoux a la tête complètement enfoncée. Vous vous accroupissez à côté d\'elle. Elle vous regarde et gémit. Vous demandez qui ou quoi a fait ça. La femme s\'éclaircit la gorge et répond.%SPEECH_ON%les peaux vertes. Des grands. Des peties. Ils riaient en le faisant. Leurs massues montaient, descendaient, ils recommençaient encore et encore, et entre les deux, ils n'arrêtaient pas de rire.%SPEECH_OFF% | Vous trouvez un cheval mort au bord du chemin, l\'estomac tourné vers le sentier. Sa cage thoracique laisse encore couler des gouttes fraîche. %randombrother% note qu\'il manque le cœur, le foie et d\'autres morceaux de choix. Vous montrez du doigt des empreintes de pas, grandes et petites, qui suivent le sang plus loin sur le chemin.%SPEECH_ON%Goblins et orcs.%SPEECH_OFF%Et ils ne sont pas loin. Vous ordonnez à %companyname% de se préparer au combat.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Soyez sur vos gardes!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MadeADent",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{Avec autant de peaux vertes mortes, ce n\'est qu\'une question de temps avant que leur chef de guerre ne se manifeste. | Vous avez laissé une traînée de peaux vertes mortes. Leur chef de guerre aura bientôt vent de vous. | Le chef de guerre des peaux-vertes a sûrement entendu des histoires sur ses guerriers abattus à l\'heure qu\'il est. Il est sans doute en train de vous pister. | Si vous étiez le chef de guerre des Peaux-vertes, vous seriez probablement prêt à traquer le bâtard qui a tué vos troupes. Continuez à tuer et vous verrez sans doute à quel point vous et ce sauvage pensez de la même façon. | Un sauvage comprend la violence, et vous avez sûrement laissé une trace d'enseignements sanglants dans toute la région. Si le seigneur de guerre est une créature intelligente, il ne tardera sans doute pas à se diriger vers vous. | Si l\'on en croit les estimations, le seigneur de guerre orc est certainement très en colère contre les humains qui ont perturbé ses plans. Vous devriez vous attendre à voir ce sauvage tôt ou tard. Le plus probable, c\'est le premier. | Avec autant de meurtres d\'orcs et de gobelins, ce n\'est qu\'une question de temps avant que leur chef ne s\'en prenne personnellement à vous. | Si les orcs parlent le langage de la violence, alors vous avez écrit une véritable lettre d\'amour dans toute la région. Le chef de guerre orc sera certainement d\'humeur à vous répondre. | Si la violence est le langage de l\'amour chez les orcs, alors tu es resté dans la cour de leur seigneur de guerre et tu as jeté beaucoup de pierres à la fenêtre pour essayer d\'attirer son attention. Mais au lieu de cailloux, ce sont les membres et les têtes de ses soldats. Cette brute ne manquera pas de réagir d\'un jour à l\'autre. | Vous avez laissé une longue traînée de peaux vertes mortes, ce qui ne manquera pas d\'attirer l\'attention de leur chef de guerre. | Les affaires sont bonnes pour les buses : vous avez laissé une traînée de peaux vertes mortes et il est probable que, d\'un jour à l\'autre, leur chef de guerre viendra voir de ses propres yeux ce que vous êtes en train de faire. | Si les choses continuent à se dérouler comme prévu, il est probable que leur chef de guerre viendra d\'un jour à l\'autre se rendre compte de ce que vous faites. | Si les choses continuent à se dérouler comme prévu, c\'est-à-dire en massacrant sans entrave les sauvages verts, ce n\'est plus qu\'une question de temps avant qu\'un seigneur de guerre orc ne vienne vous voir en personne. |Une bousculade pourrait difficilement faire plus de bruit que ce que vous avez fait cette semaine. Si vous continuez à tuer des peaux vertes à droite et à gauche, ce n\'est qu\'une question de temps avant que leur chef de guerre ne se montre. | Vous avez l\'impression que quelque part dans cette région se trouve un chef de guerre orc très, très furieux, qui regarde un dessin grossier de votre visage. | Vous aimez à penser que vous avez généré des affiches de vous dans le milieu des peaux vertes. La silhouette d\'un homme avec un prix en dessous. Recherché mort ou très mort. Le problème, c\'est que vous continuerez à tuer tous ceux qui se présenteront à vous jusqu\'à ce que le chef de guerre orc lui-même fasse son apparition - et vous avez l\'impression que cela ne saurait tarder. | Les peaux vertes racontent sûrement des histoires sur vous autour de leurs feux de camp. Un maudit humain qui terrorise leurs rangs. Et vous ne doutez pas qu\'un chef de guerre orc entendra ces histoires et se sentira obligé de voir par lui-même si ce qu_'elles racontent est vrai... | Si vous continuez à tuer des peaux-vertes comme ça, leur chef de guerre ne manquera pas de revenir à la charge. | Vous vous aventurez dans des eaux dangereuses.Avec autant de peaux vertes tuées, le seigneur de guerre orc ne va pas tarder à arriver. | J\'ai l'impression que le seigneur de guerre orc va bientôt arriver. Ça a peut-être un rapport avec le fait que tu aies tué tous ses soldats. C\'est juste une intuition. | Vous avez tué des petites peaux-vertes et des grands peaux-vertes. Maintenant, il est temps de tuer le plus grand d\'entre eux : un seigneur de guerre. Ce sauvage doit bien se trouver quelque part par ici... | Vous avez fait la guerre aux peaux vertes et pour cela, leur chef de guerre ne manquera pas d\'apparaître tôt ou tard. | Les Peaux-vertes meurent à gauche et à droite. À un moment donné, leur chef de guerre va se rendre compte que ce n'est pas dû à des causes naturelles. Une fois qu\'il l\'aura compris, il viendra vous chercher doublement.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Victoire! | Maudits peaux-vertes.}",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FinalConfrontation1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{Vous entendez beaucoup de rumeurs de la part des habitants de la région selon lesquelles un seigneur de guerre orc rassemble ses soldats et se dirige vers vous. Si ces rumeurs sont fondées, vous devez vous préparer au mieux. | Bien, on parle beaucoup d\'un seigneur de guerre orc qui serait dans la région. Il se trouve qu\'il se dirige vers vous - ce qui vous fait penser que votre plan a fonctionné ! %companyname% doit se préparer à une lutte acharnée.| La rumeur dit que le seigneur de guerre orc se dirige vers vous !  Preparez %companyname% car un combat d\'enfer les attend ! | Tous les paysans que vous croisez semblent colporter la même rumeur : un seigneur de guerre orc arrive dans votre direction ! Il ne s\'agit probablement pas d\'une coïncidence et  %companyname% doit se préparer en conséquence. | La nouvelle qui circule est que %companyname% est la cible d\'un seigneur de guerre orc marchant avec une petite armée. Il semble que votre plan ait fonctionné. La compagnie doit se préparer à l\'incroyable bataille qui l\'attend ! | Il semble que chaque paysan que vous croisez ait une histoire à raconter et elles sont toutes les mêmes : un seigneur de guerre orc a rassemblé une petite armée et se trouve par hasard dans votre direction. %companyname% devrait se préparer à un combat d\'enfer ! | Une petite vieille se précipite vers vous. Elle vous explique que tout le monde parle d\'un seigneur de guerre orc qui se dirige vers vous. Vous n\'êtes pas sûr que ce soit vrai, mais étant donné votre but ces derniers jours, c\'est certainement une bien trop grande coïncidence. %companyname% doit se préparer au combat. | Bien, %companyname% doit se préparer au combat. Tous les gens que vous croisez vous racontent la même histoire : un seigneur de guerre orque a rassemblé une petite armée et se dirige vers vous ! | Il semble que les massacres aient porté leurs fruits : un seigneur de guerre orque et son armée se dirigent vers vous pour s\'occuper personnellement de la compagnie. %companyname% doit se préparer au combat ! |  Un petit garçon s\'approche de vous. Il jette un coup d\'œil à la bannière de %companyname%puis à vous. Il sourie.%SPEECH_ON%Je pense que vous avez besoin d\'aide.%SPEECH_OFF%C\'est peut-être vrai, mais cela semble étrange de la part d'un enfant. Vous lui demandez pourquoi et il vous répond.%SPEECH_ON%Mon père a dit qu\'un grand orque méchant allait tous vous tuer. Il a dit que les marchands en ont parlé toute la journée !%SPEECH_OFF%Hmmm, si c\'est vrai, cela signifie que la stratégie a porté ses fruits et que %companyname% doit se préparer à la bataille. Vous remerciez l\'enfant. Il hausse les épaules.%SPEECH_ON%Je viens de vous sauver la vie et tout ce que j\'obtiens, c\'est un remerciement ? Vous, les gens !%SPEECH_OFF%Le gamin crache et s\'en va en donnant des coups de pied dans les cailloux.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devons être prêts pour cela.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_orcs.getFaction()).spawnEntity(tile, "Greenskin Horde", false, this.Const.World.Spawn.GreenskinHorde, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(nearest_orcs.getBanner());
				party.getSprite("body").setBrush("figure_orc_05");
				party.setDescription("A horde of greenskins led by a fearsome orc warlord.");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				this.Contract.m.UnitsSpawned.push(party);
				local hasWarlord = false;

				foreach( t in party.getTroops() )
				{
					if (t.ID == this.Const.EntityType.OrcWarlord)
					{
						hasWarlord = true;
						break;
					}
				}

				if (!hasWarlord)
				{
					this.Const.World.Common.addTroop(party, {
						Type = this.Const.World.Spawn.Troops.OrcWarlord
					}, false);
				}

				party.getLoot().ArmorParts = this.Math.rand(0, 35);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local intercept = this.new("scripts/ai/world/orders/intercept_order");
				intercept.setTarget(this.World.State.getPlayer());
				c.addOrder(intercept);
				this.Contract.setState("Running_Warlord");
			}

		});
		this.m.Screens.push({
			ID = "FinalConfrontation2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Le chef de guerre est à la tête d\'un groupe d\'orcs et de gobelins. Il se dresse au milieu des guerriers déjà énormes qui l\'entourent. Vous ordonnez à vos hommes de se mettre en ligne de bataille et à peine les mots ont-ils quitté vos lèvres que le chef de guerre rugit et que ses guerriers se précipitent sur vous ! | Une grande formation d\'orcs et de gobelins se tient devant vous, leur chef de guerre se tenant à l\'avant. Il s\'avance et lance un sac à dos dans votre direction. Il se déploie en plein vol et s\'ouvre en touchant le sol. Une douzaine de têtes en sortent comme des billes d\'un sac de jeu d\'enfant. Le seigneur de guerre lève son arme et rugit. Alors que les peaux vertes se dirigent vers vous, vous ordonnez rapidement à %companyname% de se mettre en formation. | %companyname% se tient devant un groupe de peaux-vertes : des orcs, des gobelins et leur chef de guerre, une créature bestiale qui semble peu gracieuse, même dans les rangs de sa propre espèce. L\'énorme guerrier lève son arme et rugit, faisant envoler les oiseaux des arbres et envoyant les créatures se réfugier dans les trous. Alors que les peaux vertes commencent à charger, vous criez à vos hommes de se mettre en formation et de ne pas oublier qui ils sont :  %companyname% ! | Vous et %companyname% arrivez enfin devant le seigneur de guerre et son armée d\'orcs et de gobelins. C\'est l\'occasion d\'un discours, mais avant même que vous n\'ayez pu dire un mot, les sauvages brutaux commencent à charger ! | Enfin, les forces de l\'homme et de la bête s\'affrontent. En face de %companyname% se trouve une petite armée d\'orcs et de gobelins, avec à leur tête un chef de guerre brutal. Vous sortez votre épée et le chef de guerre lève son arme. Si ce n\'est que pour un instant, on comprend que ce sont des guerriers et seulement des guerriers qui vont mourir aujourd\'hui. | Le chef de guerre orc et son armée chargent ! Vous dites au %companyname% que c\'est à cela qu\'ils se sont entraînés et préparés.%SPEECH_ON%Nous ne serions pas ici si nous le voulions !%SPEECH_OFF%Les hommes rugissent, dégainent leurs lames et se mettent en formation. | Alors qu\'une horde de gobelins et d\'orcs traverse le champ de bataille, un énorme seigneur de guerre à leur tête, vous dites aux hommes de ne pas avoir peur.%SPEECH_ON%Nous aurons beaucoup à célébrer ce soir, messieurs !%SPEECH_OFF%Ils dégainent leurs armes et rugissent, un cri assourdissant qui se répercute sur les peaux vertes qui semblent, pour la première fois, momentanément surprises. | %randombrother% vient à vous, vous indiquant une petite armée d\'orcs et de gobelins qui foncent sur vous, un chef de guerre à leur tête.%SPEECH_ON%Sans vouloir souligner l\'évidence, les geenskins sont là.%SPEECH_OFF%Vous acquiescez et criez à vos hommes. %SPEECH_ON%Qui d\'autre est ici ? %SPEECH_OFF%Les hommes sortent leurs armes.%SPEECH_ON%Le %companyname%!%SPEECH_OFF% | Vous et %randombrother% regardez un chef de guerre orc charger dans votre direction, une petite armée d\'orcs et de gobelins derrière lui. Le mercenaire rit.%SPEECH_ON%Et bien, ils arrivent.%SPEECH_OFF%En hochant la tête, vous vous adressez aux hommes.%SPEECH_ON%Ils chargent parce qu\'ils ont peur. Parce qu'ils n'ont pas de base sur laquelle s'appuyer. Mais nous, si, parce que nous prenons position ici même ! %SPEECH_OFF%Vous plantez une bannière de %companyname% dans le sol. Le voile ondule dans le vent tandis que les hommes se mettent à rugir. | Vous regardez les peaux vertes charger en avant avec leur chef de guerre en tête. Dégainant votre épée, vous criez aux hommes : Une bonne nuit à tous ceux qui prendront la tête d\'un sauvage. Qui dort bien ce soir ? %SPEECH_OFF%Les métaux s\'entrechoquent tandis que les hommes dégainent leurs armes et crient.%SPEECH_ON%Le %companyname%!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithWarlord(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FinalConfrontation3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{The warlord is right where he should be: dead on the ground. You watch as the rest of the greenskins take for the hills. Your employer, %employer%, will be most pleased with the work the %companyname% has put in this day. | The %companyname% has triumphed this day! The orc warlord is dead in the mud and his army scattered to the hills. This is a result your employer, %employer%, will be most pleased with. | Your employer, %employer%, paid for the best and got just that: the orc warlord is dead and its roaming band of savages has fled. With no leader, there\'s little doubt the beasts will scatter and die off on their own. You should go back to the nobleman for your pay. | You have stamped out the greenskins, killing their warlord and sending them running for the hills. Your employer, %employer%, will be most pleased with the %companyname%. | The orc warlord is dead and with no head, the snake of the greenskin gang will shrivel and die. Your employer, %employer%, will be most pleased by this news. | The orc warlord is dead. It looks surprisingly at peace given the amount of terror and chaos it put on this earth. %randombrother% comes up, laughing.%SPEECH_ON%It\'s big, but it dies. I feel like people always forget that last part.%SPEECH_OFF%You nod and tell the men to prepare a Retournez à %employer% at %townname%. | The warlord is dead at your feet, right where he should be. The %companyname% has earned its payday from %employer%. All that\'s left is to Retournez à the nobleman and give him the news. | %employer% probably didn\'t believe in you. He probably didn\'t foresee this moment where you, a mercenary captain, stands over a dead orc warlord. But that\'s where you are this day, because the %companyname% is not to be trifled with. Time to go back to that nobleman and get your payday. | The orc warlord is dead and its army scattered. You take a look around and yell to your men.%SPEECH_ON%Men, my friend wants to kill his worst enemy, who should he call upon?%SPEECH_OFF%They raise their fists.%SPEECH_ON%The %companyname%!%SPEECH_OFF%You laugh and continue.%SPEECH_ON%An old woman wants us to kill all the rats in her attic, who should she call upon?%SPEECH_OFF%The men, quieter this time.%SPEECH_ON%The %companyname%?%SPEECH_OFF%You grin widely and continue.%SPEECH_ON%If a dainty man is scared of a spider on his wall, who should he call upon?%SPEECH_OFF%%randombrother% spits.%SPEECH_ON%Let\'s just get back to %townname% and %employer% already!%SPEECH_OFF% | You watch as the greenskins scatter like rats. %randombrother% looks ready to give chase, but you stop him.%SPEECH_ON%Let them run.%SPEECH_OFF%The mercenary shakes his head.%SPEECH_ON%But they\'ll speak of us! They know who we are.%SPEECH_OFF%You grin widely and clap the man on the shoulder.%SPEECH_ON%Exactly. C\'mon, let\'s head on back to %townname% and %employer%.%SPEECH_OFF% | You walk through the mounds of the dead, coming to stand before the slain orc warlord. The flies are already upon him. %randombrother% stands beside you, looking down at the beast.%SPEECH_ON%He wasn\'t so bad. I mean, okay, yeah he was pretty scary. A little on the gonna give me nightmares side of things, but all in all, not too bad.%SPEECH_OFF%You smile and clap the man on the shoulder.%SPEECH_ON%I hope one day you\'ll be able to scare you grandchildren with stories of it.%SPEECH_OFF% | The battlefield has settled. The dead are in the places they spent their whole lives getting to. The greenskins are out running for the hills. And the %companyname% is cheering in victory. %employer% will be most pleased with this series of events. | The %companyname% stands triumphant over the greenskin savages. You look down upon the orc warlord, taking into consideration that a lot of things had to die just so... it could die. A strange world with strange rules, but this is simply how it is.\n\n%employer% will be pleased and paying you a lot - and the world of the coin is the world you understand best. | You and %randombrother% look at the orc warlord\'s corpse. Flies are already busying themselves on its tongue, farking one another and spreading their plague. The mercenary looks at you and laughs.%SPEECH_ON%Is that the end you see for yourself, a bunch of insects doing the business on your goddam face?%SPEECH_OFF%You shrug and answer.%SPEECH_ON%It\'s a long ways away from dying while wrapped in a blanket and surrounded by family, that\'s for sure.%SPEECH_OFF%You slap the sellsword on the chest.%SPEECH_ON%C\'mon, enough of that talk. Let\'s get back to %employer% and get our pay.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Le %companyname% l\'a emporté! | Victoire!}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "Berserkers1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_93.png[/img]Sur le chemin, %randombrother% se redresse soudain et demande à tout le monde de se taire. Vous vous accroupissez et avancez jusqu\'à lui. Il pointe du doigt quelques buissons.%SPEECH_ON%là. Des emmerdes. Vous regardez à travers les buissons pour voir un camp de berserkers orcs. Ils ont allumé un petit feu avec une broche de viande qui tourne. A proximité se trouve un regroupement de cages, chacune contenant un chien qui gémit. Vous regardez une peau verte ouvrir une cage et en extraire un chien. Il le traîne en hurlant vers le feu et le tient au-dessus des flammes. Le mercenaire vous jette un regard. %SPEECH_ON%Que devons-nous faire, monsieur ?%SPEECH_OFF%,
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous sommes en guerre et chaque bataille compte. Aux armes!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Berserkers";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BerserkersOnly, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "Ce n\'est pas notre combat.",
					function getResult()
					{
						return "Berserkers2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Berserkers2",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_93.png[/img]Ce n\'est pas votre combat et ça ne le sera jamais. Les hommes se déplacent autour du campement, évitant tranquillement ce qui pourrait très facilement être un combat dévastateur avec un groupe de berserkers. Les hurlements des chiens semblent vous chasser et s\'attardent sur quelques hommes longtemps après que vous ayez quitté les lieux.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Gardez la tête froide, messieurs.",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						this.Flags.set("IsBerserkersDone", false);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.houndmaster")
					{
						bro.worsenMood(1.0, "You didn\'t help wardogs being eaten by orcs");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Berserkers3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_32.png[/img]The fight over, you take a good look autour de berserkers\' encampment. Each of the cages is home to a shriveled, cornered dog. When you open one of the cages, the dog sprints out, yelping and yapping as it darts over the hills and is gone, just like that. Most of the other mutts follow suit. Two, however, remain. They follow you around as you inspect the rest of the encampment. %randombrother% notes that they\'re war dogs.%SPEECH_ON%Look at the size of \'em. Big, burly, nasty farks. Their owners must\'ve been killed by the orcs and now, well, they\'ve reason to trust us. Welcome to the company, little buddies.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bon travail les gars.",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						this.Flags.set("IsBerserkersDone", false);
						return 0;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Berserkers4",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_32.png[/img]With the last of the berserkers slain, you start in on their camp. You find the burnt bones of dogs strewn about the campfire. The meat has been picked clean and a collection of heads was teetering like some sickly cairn. %randombrother% goes about opening the cages. All the dogs, the very second they have a gap, sprint out and run away. The mercenary manages to snag one, but it yelps and goes limp, dying from sheer panic and fear. The rest of the camp has nothing of value aside from disappointment and piles of orc shite.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We still did good here.",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You find %employer% talking to his generals. He turns to you with a smile and arms open.%SPEECH_ON%Well, you did it, sellsword. I gotta admit, I didn\'t think you could. Funny business, killing orcs.%SPEECH_OFF%It wasn\'t especially funny, but you nod anyway. The nobleman goes and gets a satchel of %reward_completion% crowns and hands it to you personally.%SPEECH_ON%Job well done.%SPEECH_OFF% | %employer% is found in bed with a few women. His guard stands at the door, shrugging with a \'you said let him in\' look on his face. The nobleman waves at you.%SPEECH_ON%I\'m a bit busy, but I understand that you have been successful in all your... ehem, endeavors.%SPEECH_OFF%He snaps his fingers and one of the women slides out of the blankets. She daintily crosses the cold stone floor to pick up a satchel and carry it over to you. %employer% speaks again.%SPEECH_ON%%reward_completion% crowns, was it? I think that\'s some pretty pay for what you have done. I hear killing an orc warlord isn\'t exactly easy business.%SPEECH_OFF%The woman stares deep into your eyes as she hands the money over.%SPEECH_ON%You killed an orc warlord? That\'s so brave...%SPEECH_OFF%You nod and the lithe lady twists on her toes. The nobleman snaps his fingers again and she returns to his bed.%SPEECH_ON%Careful, mercenary.%SPEECH_OFF% | A guard takes you to a gardening %employer%. He snips at the vegetables and drops them into a basket held by a servant.%SPEECH_ON%Judging by your not being dead, my deductive skills tells me you were successful in killing the orc warlord.%SPEECH_OFF%You respond.%SPEECH_ON%It wasn\'t easy.%SPEECH_OFF%The nobleman nods, staring at the dirt, then continues clipping off a series of tomatoes.%SPEECH_ON%The guard standing yonder will have your pay. %reward_completion% crowns as we agreed upon. I\'m very busy right now, but you should know that I and the people of this town owe you a lot.%SPEECH_OFF%And by \'a lot\' he just means %reward_completion% crowns, apparently. | %employer% welcomes you into his room.%SPEECH_ON%My little birds have been chirping a lot these days, telling me stories of a sellsword that slew an orc warlord and scattered his army. And I thought to myself, hey, I think I know that guy.%SPEECH_OFF%The nobleman grins and hands over a satchel of %reward_completion% crowns.%SPEECH_ON%Good work, mercenary.%SPEECH_OFF% | %employer% greets you with a satchel of %reward_completion% crowns.%SPEECH_ON%My spies have already told me everything I need to know. You are the man to trust, sellsword.%SPEECH_OFF% | When you enter %employer%\'s room you find the nobleman listening to the whispers of one of his scribes. Seeing you, the man bolts upright.%SPEECH_ON%Speak of the devil and he will come. You are the talk of the town, sellsword. Killing an orc warlord and scattering its army? Well, I\'d say that\'s worth the %reward_completion% crowns we agreed upon.%SPEECH_OFF% | %employer% is staring dutifully at a map.%SPEECH_ON%I\'m gonna have to redraw some of this thank to you - and I mean that in the good way. Killing that orc warlord will allow us to rebuild from the ashes it had sown over these lands.%SPEECH_OFF%You nod, but subtly ask about the pay. The nobleman smiles.%SPEECH_ON%%reward_completion% crowns, was it? Also, you should at least take a moment to let the accolades come in, sellsword. The money isn\'t going nowhere, but the pride you feel now will one day fade.%SPEECH_OFF%You disagree. That money is going to fade its way into a pint of good mead. | %employer% is pacing his room while generals stand by the wayside in almost dutiful silence. You ask what the problem is and the man bolts upright.%SPEECH_ON%By the old gods on a fly\'s ass, I didn\'t think you\'d make it.%SPEECH_OFF%You ignore that soaring vote of confidence and inform the nobleman of all that you\'ve done. He nods repeatedly then takes out a satchel of %reward_completion% crowns and hands it over.%SPEECH_ON%That is a job well done, mercenary. Well damn done!%SPEECH_OFF% | You find %employer% watching a servant chop wood. Seeing your shadow, the nobleman wheels around.%SPEECH_ON%Ah, the man of the hour! I\'ve already heard so much of what you\'ve done. We\'re actually having a celebration - gotta prep the firewood for cooking and nighttime festivities. I\'d invite you, but this is for the highborn only, I\'m sure you understand.%SPEECH_OFF%You shrug and respond.%SPEECH_ON%I\'d understand a lot better if I had the %reward_completion% crowns we agreed upon.%SPEECH_OFF%%employer% laughs and snaps his fingers to a guard who promptly brings your pay over. | %employer% is found talking to the captain of another mercenary band. He\'s a frail leader, probably just getting his start. But upon seeing you, the nobleman quickly dismisses him and welcomes you.%SPEECH_ON%Ah hell, it is good seeing you, mercenary! Things were about to get a little desperate around here.%SPEECH_OFF%You remark that the captain you just saw would be most unfit to handle any job, much less that of hunting an orc warlord. The nobleman hands you a satchel of %reward_completion% crowns and responds.%SPEECH_ON%Look, let\'s just agree that you\'ve done good this day. We can finally start rebuilding what that damned orc savage destroyed and that\'s what matters.%SPEECH_OFF%The crowns in your hand are what matters, but you agree to no longer dawdle on the point.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Killed a renowned orc warlord");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

