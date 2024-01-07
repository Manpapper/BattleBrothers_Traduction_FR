this.free_greenskin_prisoners_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		BattlesiteTile = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.free_greenskin_prisoners";
		this.m.Name = "Free Prisoners";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Recherchez le champ de bataille %direction% de %origin% pour des indices",
					"Free any prisoners you find"
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
				if (this.Contract.m.BattlesiteTile == null || this.Contract.m.BattlesiteTile.IsOccupied)
				{
					local playerTile = this.World.State.getPlayer().getTile();
					this.Contract.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains
					], false);
				}

				local tile = this.Contract.m.BattlesiteTile;
				tile.clear();
				this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", tile.Coords));
				this.Contract.m.Destination.onSpawned();
				this.Contract.m.Destination.setFaction(this.Const.Faction.PlayerAnimals);
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 5)
				{
					this.Flags.set("IsSurvivor", true);
				}
				else if (r <= 10)
				{
					this.Flags.set("IsLuckyFind", true);
				}
				else if (r <= 15)
				{
					this.Flags.set("IsAccident", true);
				}
				else if (r <= 35)
				{
					if (this.Contract.getDifficultyMult() > 0.85)
					{
						this.Flags.set("IsScouts", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsEnemyCamp", true);

					if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() < 1.15)
					{
						this.Flags.set("IsEmptyCamp", true);
					}
				}
				else
				{
					this.Flags.set("IsEnemyParty", true);
				}

				if (this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsAmbush", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (!this.TempFlags.get("IsBattlefieldReached") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.TempFlags.set("IsBattlefieldReached", true);
					this.Contract.setScreen("Battlesite1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsScoutsDefeated"))
				{
					this.Flags.set("IsScoutsDefeated", false);
					this.Contract.setScreen("Battlesite2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsDefeated", true);
				}
			}

		});
		this.m.States.push({
			ID = "Pursuit",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Suivez les empreintes des Peaux-Vertes qui mènent en dehors du champ de bataille",
					"Libérez tous les prisonniers que vous croisez"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;

					if (this.Flags.get("IsEmptyCamp"))
					{
						this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				if ((this.Contract.m.Destination == null || this.Contract.m.Destination.isNull()) && !this.Flags.get("IsEmptyCamp"))
				{
					this.Contract.setScreen("Battlesite3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbush") && !this.Flags.get("IsAmbushTriggered") && !this.TempFlags.get("IsAmbushTriggered") && this.Contract.m.Destination.isHiddenToPlayer() && this.Contract.getDistanceToNearestSettlement() >= 5 && this.Math.rand(1, 1000) <= 2)
				{
					this.TempFlags.set("IsAmbushTriggered", true);
					this.Contract.setScreen("Ambush");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbushDefeated"))
				{
					this.Contract.setScreen("AmbushFailed");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.Flags.set("IsAmbushDefeated", true);
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.setScreen("EmptyCamp");
				this.World.Contracts.showActiveContract();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Revenez avec les prisonniers libérés à " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				}

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
			 Text = "[img]gfx/ui/events/event_45.png[/img]{Lorsque vous trouvez %employer%, il écoute attentivement un paysan qui parle désespérément d\'une voix rauque. Apparemment, des peaux-vertes ont attaqué un village voisin et ont emmené des prisonniers. Le noble fait immédiatement appel à vos services : ramenez ces gens... moyennant finances, bien sûr. | %employer% regarde des cartes lorsque vous entrez dans sa chambre. Quelques commandants se tiennent à ses côtés, utilisant des bâtons comme pointeurs pour tracer et marquer la topographie sur papier. Lorsqu\'il vous voit, le noble vous fait signe de vous approcher immédiatement.%SPEECH_ON%J\'ai un problème, mercenaire. Les peaux-vertes attaquent nos terres, comme vous l\'avez sûrement remarqué, mais dernièrement, nous avons reçu des rapports indiquant qu\'ils ont pris des prisonniers. Nous ne sommes pas tout à fait sûrs de l\'endroit où ils sont allés, mais nous savons où ils ont été vus pour la dernière fois. Si vous vous rendez là-bas, je pense que vous pourriez trouver des indices sur leur emplacement actuel. J\'espère que cela vous intéresse, mercenaire.%SPEECH_OFF% | Vous voyez %employer% et un paysan parler ensemble. Quelques gardes tiennent le paysan par les bras, apparemment l\'ayant traîné devant le noble. Vous supposez qu\'un crime a été commis, mais en réalité, c\'est simplement ainsi que %employer% préfère parler à la populace. Selon les rumeurs, les peaux-vertes ont attaqué une région locale et ont pris quelques prisonniers. Ils ont laissé suffisamment d\'indices pour ne pas être trop difficiles à trouver, si vous êtes prêt à relever le défi. | %employer% est retrouvé affalé sur sa chaise.%SPEECH_ON%Mon peuple perd confiance en moi. On dit que les peaux-vertes ne se contentent pas de piller des villages, mais prennent aussi des prisonniers, et je pense que c\'est encore pire ! Mais peut-être que si quelqu\'un pouvait ramener ces gens, mon peuple recommencerait à me faire confiance. Que dites-vous, mercenaire, allez-vous aider à retrouver ces pauvres âmes perdues ? Moyennant une rémunération appropriée, bien sûr.%SPEECH_OFF% | %employer% parle à l\'un de ses commandants.%SPEECH_ON%Nous les récupérerons, ne vous inquiétez pas.%SPEECH_OFF%Vous êtes rapidement informé de la situation : il y a eu une grande bataille avec des peaux-vertes %direction% d\'ici et des prisonniers ont été pris. %employer% n\'a pas suffisamment d\'hommes pour partir à leur recherche et a besoin d\'un homme de votre flexibilité pour faire le travail. | Vous trouvez %employer% en train de regarder une carte. Il pointe un endroit.%SPEECH_ON%%direction% d\'ici, il y a eu une grande bataille avec des peaux-vertes. Nous avons des raisons de croire qu\'ils ont pris des prisonniers - et j\'ai des raisons de croire que vous pouvez les récupérer.%SPEECH_OFF% | Un garde boiteux vient à vous sur des béquilles. Sa jambe suinte sur le sol en pierre.%SPEECH_ON%Hé, vous êtes avec la %companyname%, non ? %employer% m\'a dit de vous rencontrer.%SPEECH_OFF%Il explique que ses hommes ont affronté des peaux-vertes %direction% d\'ici et qu\'ils ont peut-être emmené un groupe de prisonniers. Vous demandez à l\'homme pourquoi il ne reçoit pas de soins.%SPEECH_ON%J\'ai, euh, fui du champ de bataille. C\'est ma punition. Peu importe de toute façon, l\'apothicaire dit que je serai mort d\'ici le mois. Vous voyez ça ? Assez laid, non ?%SPEECH_OFF%Il soulève délicatement sa jambe. Des pustules vertes bouillonnent autour des bandages. C\'est assez laid. | %employer% est trouvé en train d\'essayer de récupérer une bouteille d\'encre de son chien.%SPEECH_ON%Avale ça et tu es mort, pourquoi tu ne comprends pas, maudit cabot ?%SPEECH_OFF%Le noble vous voit et se redresse.%SPEECH_ON%Mercenaire ! C\'est bon de vous voir car ce sont vraiment des temps désespérés. Il y a eu une bataille avec des peaux-vertes %direction% d\'ici et mes commandants rapportent que les sauvages ont emmené des prisonniers ! J\'ai besoin d\'un homme de vos services pour aider à ramener ces hommes.%SPEECH_OFF%Pendant que vous réfléchissez, le chien avale la bouteille d\'encre et commence immédiatement à étouffer. Elle ressort en un jet de vomi noirci. Une plume glisse doucement à travers le vomi. %employer% lève les mains incrédules.%SPEECH_ON%J\'ai passé une heure à la chercher ! C\'était ma préférée, maudit chien.%SPEECH_OFF% | Vous trouvez %employer% en train de dérouler un parchemin. Il le lit attentivement tandis qu\'un scribe pensif regarde par-dessus son épaule. Le noble claque le papier sur son bureau et vous fait signe d\'entrer.%SPEECH_ON%Il y a eu une grande bataille avec des peaux-vertes %direction% d\'ici et ces sauvages ont pris des prisonniers ! Des prisonniers, pouvez-vous le croire ?%SPEECH_OFF%Avant que vous puissiez répondre, %employer% continue.%SPEECH_ON%Regardez, je n\'ai pas d\'hommes à perdre, mais s\'il est vrai que les peaux-vertes ont pris des prisonniers, alors peut-être qu\'un homme de vos capacités pourrait les aider à les récupérer ?%SPEECH_OFF% | Un des commandants de %employer% vous rencontre devant la porte de sa chambre. Il vous remet un parchemin avec des instructions écrites dessus. Selon le rapport, une grande bataille %direction% d\'ici s\'est terminée par la capture de prisonniers par les peaux-vertes. %employer% souhaite récupérer ces hommes, mais n\'a pas de soldats à épargner pour les secourir. Le commandant croise les bras.%SPEECH_ON%Si vous souhaitez négocier, mon seigneur m\'a délégué le pouvoir de le faire.%SPEECH_OFF% | Vous trouvez %employer% en train de donner des coups de pied à un chat dans sa chambre, le chassant avec son pied partout où il peut jusqu\'à ce que le félin se réfugie au plafond, agrippé fermement au sommet d\'une tige de rideau. Le noble le regarde en l\'air.%SPEECH_ON%Je ne pense pas que je pourrais jamais trouver les mots pour exprimer à quel point je déteste cette fichue chose.%SPEECH_OFF%Il se tourne vers vous.%SPEECH_ON%Mercenaire ! Vous êtes une vue pour les yeux endoloris ! J\'ai quelque chose à faire, et non, ce n\'est pas à propos de cette satanée créature. Mes soldats sont entrés en conflit avec des peaux-vertes %direction% d\'ici. Les rapports indiquent que les sauvages ont pris des prisonniers, ce qui signifie qu\'ils pourraient éventuellement être récupérés. Et je pense que vous, monsieur, êtes l\'homme de la situation.%SPEECH_OFF%Le chat miaule et se dresse sur ses pattes arrière. %employer% se retourne, pointant un doigt.%SPEECH_ON%Je veux que vous sautiez d\'ici ! Je veux que vous le fassiez !%SPEECH_OFF% | Il y a un groupe de commandants autour de %employer%. Il y a aussi la tête d\'un homme sur le bureau devant eux. %employer% vous regarde.%SPEECH_ON%Une unité de soldats a pris contact avec des peaux-vertes %direction% d\'ici. Ils ont perdu, si vous n\'aviez pas remarqué. Ils ont aussi pris des prisonniers et, si c\'est vrai, j\'ai un vif intérêt à récupérer ces hommes ! Je pense que vous êtes l\'homme parfait pour le travail, mercenaire, qu\'en dites-vous ?%SPEECH_OFF% | Un gamin maigre se tient à côté de %employer%, dessinant une carte et expliquant une série d\'événements qu\'il a observés de ses propres yeux : une unité de soldats a affronté des peaux-vertes %direction% d\'ici et a perdu. Les sauvages ont ensuite pris des prisonniers et se sont enfuis. %employer% se tourne vers vous.%SPEECH_ON%Eh bien, si ce que dit ce maigrichon paysan est vrai, alors nous devons récupérer ces hommes. Mercenaire, qu\'en dites-vous ? Êtes-vous intéressé par le sauvetage de mes soldats ?%SPEECH_OFF% | Vous trouvez %employer% en train de parler à un commandant en pleurs.%SPEECH_ON%Alors, laissez-moi comprendre. %direction% d\'ici, vous avez rencontré un groupe de peaux-vertes, vous avez perdu, vous avez fui et vous avez vu certains de vos hommes être pris prisonniers ?%SPEECH_OFF%Le commandant hoche la tête. %employer% agite la main vers quelques gardes.%SPEECH_ON%La lâcheté déshonorante ne trouvera aucune récompense dans ces salles, emmenez-le ! Et vous, mercenaire ! J\'ai besoin d\'un homme de constitution plus robuste pour aller là-bas et récupérer ces prisonniers !%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{J\'imagine que vous allez payer chère pour ça. | Parlons argent. | Tout peut être fait si la paie est juste.}",
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
			ID = "Battlesite1",
			Title = "Sur le site de la bataille...",
			Texte = "[img]gfx/ui/events/event_22.png[/img]{Les mouches font un bruit si fort que vous les entendez avant même de pouvoir sentir sur quoi elles s\'affairent. Une horde d\'insectes est descendue sur un champ d\'ordure, un lieu de peste et d\'horreur où l\'homme et le peau-verte se sont affrontés et où il y avait désespoir de gagner mais tout le monde a perdu. Vous frayez votre chemin à travers le brouillard de mouches et ordonnez à la %companyname% de commencer à chercher des survivants ou des indices. | Des morts entassés sur des morts. Des chevaux ici et là. L\'un galope au loin, s\'emballant et devenant sauvage. L\'odeur des entrailles exposées. Chaque pas dans une flaque de sang. %randombrother% s\'approche avec un chiffon sur son nez.%SPEECH_ON%Nous commencerons à chercher des indices, monsieur, mais ça va être difficile.%SPEECH_OFF% | Fumée, sang et terre transformée en boue. Vous marchez sur le champ de bataille, ordonnant aux mercenaires de se disperser et de chercher des indices. %randombrother% fixe un peau-verte empalé au bout d\'une fourche cassée, l\'orque plantant elle-même son tueur dans le crâne avec une lame rouillée. Il secoue la tête.%SPEECH_ON%D\'accord. Des \'indices\', comme si nous devions nous demander ce qui s\'est vraiment passé ici.%SPEECH_OFF%Vous lui rappelez que les peaux-vertes ont emmené des prisonniers et que la %companyname% est là pour les sauver. | %randombrother% regarde le champ de bataille.%SPEECH_ON%Es-tu sûr qu\'il y avait des survivants à emmener ?%SPEECH_OFF%En effet, il semble qu\'une grande masse de corps ait écrasé la terre et l\'ait rendue sanglante et méconnaissable. Des cadavres tordus et raidis de tant de manières, des orques avec des gueules ouvertes dans des grognements éternels, des hommes et des femmes déchirés. Des chevaux enterrés parmi les cadavres, leurs jambes cisaillées dans les airs comme des totems tordus de fureur bestiale. Vous n\'êtes pas sûr si des prisonniers ont été pris d\'ici ou non, mais vous ordonnez à la %companyname% de commencer à chercher. | Des prisonniers pris d\'ici seraient comme des démons tirés des enfers eux-mêmes. En regardant des tas de morts avec leurs membres si emmêlés et saillants, vous ne pouvez pas imaginer comment quelqu\'un aurait pu survivre. C\'est comme si une grande foule d\'hommes et de bêtes se tenait ensemble, et un plus grand rocher de destruction les a tous labourés et les restes étaient les éparpillements que vous trouvez devant vous. Très peu peuvent être considérés comme entiers. %randombrother% porte un chiffon à son visage et le regarde, chassant les mouches de son visage.%SPEECH_ON%Eh bien, je suppose que nous commencerons à chercher des traces. Je ne peux rien promettre, cependant.%SPEECH_OFF% | Chercher des traces ici serait comme trouver une aiguille dans une botte de cadavres démembrés. %randombrother% met ses mains sur ses hanches et rit incrédule.%SPEECH_ON%Quelqu\'un a survécu à ce foutoir, encore moins jugé bon de prendre des prisonniers ?%SPEECH_OFF%Vous haussez les épaules et ordonnez à la %companyname% de commencer à chercher des indices. | Vous avez l\'impression que cet endroit était autrefois un lieu serein pour les amoureux en fuite et les enfants joueurs. Maintenant, la terre a été transformée en boue et les morts jonchent le sol aussi nombreux que les empreintes qu\'ils ont créées dans leurs finalités chaotiques. %randombrother% s\'essuie le front.%SPEECH_ON%C\'est quelque chose, hein. Eh bien, je suppose que nous allons fouiller et voir si nous pouvons trouver des traces ou des indices.%SPEECH_OFF% | Vous arrivez sur le champ de bataille. %randombrother% se penche en arrière, riant de l\'horreur absolue devant lui.%SPEECH_ON%Les dieux, mais qu\'est-ce que c\'est ? Tu dois me faire une blague !%SPEECH_OFF%D\'abord, il y a eu une bataille. Des hommes et des bêtes. Désespoir enragé. Les mourants ont pris beaucoup de monde. Puis il y a eu la pluie. La terre piétinée s\'est transformée en boue. Des champs ensanglantés en un véritable bain de sang. Et maintenant vous, les mercenaires, les témoins, à travers l\'écarlate écume, prenant en considération un vestige de ruine totale. Vous secouez la tête et commencez à donner des ordres aux hommes.%SPEECH_ON%Nous sommes ici pour des indices. Cherchez des traces menant loin. Tout ce qui a survécu ici a pris des prisonniers.%SPEECH_OFF% | Vous ne voyez pas vraiment de corps, mais plutôt des parties. Un amas d\'indices qu\'un jour et à un moment donné, une collection d\'hommes et de bêtes s\'est rencontrée ici, et dans leur sauvagerie, ils ont écarté toute notion selon laquelle les guerriers étaient jamais entiers. %randombrother% incline une botte au bout d\'un bâton et un pied en glisse. Il secoue la tête.%SPEECH_ON%D\'accord, nous pouvons commencer à chercher des traces, mais je serai maudit si quelqu\'un a survécu ici, encore moins s\'il a jugé bon de prendre des prisonniers.%SPEECH_OFF% | %randombrother% regarde le champ de bataille.%SPEECH_ON%Damn.%SPEECH_OFF%Vous avez trouvé les vestiges d\'un combat, un amas de peaux-vertes ruinées et d\'hommes rassemblés dans une cérémonie sanglante et tordue. Des chevaux se tiennent à l\'écart, pointant leurs têtes vers la scène avec une curiosité conflictuelle, oreilles plaquées. Ils se dispersent lorsque vos hommes commencent à fouiller la scène à la recherche d\'indices. Vous lancez un ordre.%SPEECH_ON%N\'oubliez pas, les peaux-vertes ont pris des prisonniers ! Cherchez des traces, les gars.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Recherchez Partout!",
					function getResult()
					{
						if (this.Flags.get("IsAccident"))
						{
							return "Accident";
						}
						else if (this.Flags.get("IsLuckyFind"))
						{
							return "LuckyFind";
						}
						else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "Survivor";
						}
						else if (this.Flags.get("IsScouts"))
						{
							return "Scouts";
						}
						else
						{
							return "Battlesite2";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite2",
			Title = "Sur le site de la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% a trouvé une série de traces menant loin du site. Le %companyname% devrait les suivre ! | Une série de traces a été découverte s\'éloignant du champ de bataille. On y trouve des empreintes humaines plus petites parmi celles, plus grandes, des orcs. Vous pourrez probablement trouver les prisonniers en les suivant. | %randombrother% se baisse près du sol et vous fait signe de venir. Il pointe quelques impressions dans le sol.%SPEECH_ON%À quoi ressemblent-elles, monsieur ?%SPEECH_OFF%Vous voyez des ensembles d\'empreintes de bottes plus petites et beaucoup, beaucoup plus grandes. Il y a aussi des séries de petites empreintes qui parsèment le côté. Vous pointez et évaluez chacune tour à tour.%SPEECH_ON%Humain, orc, gobelin. Je dis que si nous les suivons, nous pourrions bien trouver nos prisonniers.%SPEECH_OFF% | Vous tombez, ou plutôt vous heurtez, à une grande série d\'empreintes de pas. À en juger par les gros orteils et les formes sans bottes, ce sont des empreintes d\'orcs. Cependant, à côté d\'elles, vous reconnaissez instantanément des traces. %randombrother% s\'approche.%SPEECH_ON%On dirait que c\'est notre piste, monsieur. Nous suivons ça et les prisonniers ne devraient pas être trop loin des jours plus heureux.%SPEECH_OFF% | Vous vous accroupissez et regardez une série de traces. Humain, orcs, gobelins. Toutes fraîches, toutes menant loin du champ de bataille. Si vous les suivez, elles vous conduiront probablement aux prisonniers que vous recherchez. | Les empreintes d\'une masse d\'orcs et de gobelins s\'éloignent du champ de bataille. Le long de leurs côtés, on trouve une série d\'empreintes humaines, toutes très fraîches. %randombrother% crache et hoche la tête.%SPEECH_ON%C\'est ce que nous cherchons. Nous suivons ça et nous pourrions bien trouver ces prisonniers. Je veux dire, ils sont probablement tous morts comme ma grand-mère et elle est morte vraiment fort dans un glissement de terrain, mais ça vaut quand même la peine de regarder, je suppose.%SPEECH_OFF% | %randombrother% annonce une découverte des plus pertinentes : une série d\'empreintes, d\'hommes et de bêtes, s\'éloignant du champ de bataille. Si le %companyname% les suit, alors trouver les prisonniers ne devrait pas être trop loin. | Un homme avec une fourche vient par là, enfonçant la fourche dans la terre comme s\'il se hissait sur une colline. Il vous crie de vous approcher, ce que vous faites lentement. L\'homme sourit en vous approchant.%SPEECH_ON%Vous cherchez les prisonniers, n\'est-ce pas ?%SPEECH_OFF%Il tourne une brindille de balai entre ses dents et là où les dents devraient être. Il pointe.%SPEECH_ON%Il y a des traces dans ce chemin boueux là-bas. Je ne sais pas pourquoi les sauvages laissent des signes de leur venue et de leurs allées, mais je suppose que c\'est pour ça qu\'on les appelle sauvages, hein.%SPEECH_OFF%Vous remerciez le fermier pour son aide et, comme il l\'a dit, vous trouvez bientôt des traces menant loin du champ de bataille. Le %companyname% devrait les suivre pour trouver les prisonniers. | En fouillant le champ de bataille, %randombrother% est effrayé par un enfant qui surgit d\'un cadavre avec les mains écartées sur les côtés de sa tête, comme une plante maladive devenue vivante et carnivore. Le mercenaire tire son arme.%SPEECH_ON%Tu vas le payer, espèce de petit démon !%SPEECH_OFF%Vous arrêtez le mercenaire et demandez à l\'enfant ce qu\'il fait. Le petit hausse les épaules.%SPEECH_ON%Je joue. Dis, ça ne t\'intéresserait pas de savoir où les verts sont partis, hein ?%SPEECH_OFF%Bien sûr que si. L\'enfant vous mène à une série de traces, humaines, orcs, et gobelines. Toutes fraîches. Vous dites à l\'enfant de rentrer chez lui, ce n\'est pas sûr ici. Il roule des yeux.%SPEECH_ON%{Mon Dieu, c\'est un \'merci\' bien sympa que tu me fais là, monsieur. | Eh bien, mince alors, monsieur, de rien. Je pensais être ici pour m\'amuser, mais je suppose que ma vraie mission était d\'attendre que tu arrives. | Oh c\'est génial, je pensais m\'être éloigné de ma mère mais la voilà de toute façon, bon sang.}%SPEECH_OFF% | Vous commencez à perdre espoir de trouver quoi que ce soit quand une jeune femme passe avec un panier. Elle ramasse des chiffons des morts, essorant le sang au fur et à mesure. Vous lui demandez si elle a vu quelque chose. Elle hoche la tête.%SPEECH_ON%Ouais bien sûr, j\'ai vu quelque chose, j\'ai des yeux, non ? J\'ai aussi quelque chose dans le ciboulot et il a été bien gestué que vous, monsieur cherchez les prisonniers que ces sales verts ont emmenés. %SPEECH_OFF%Vous hochez la tête et demandez où ils sont partis. Elle pointe vers une colline.%SPEECH_ON%Vous voyez ce sentier ? Il y a des traces dedans. Les sauvages ont laissé beaucoup d\'indications sur l\'endroit où ils allaient. Personnellement, je ne les suivrais pas, mais vous avez l\'air costaud. Dites, c\'est quel genre de tissu, ça ?%SPEECH_OFF%Elle pointe la bannière du %companyname%. Vous haussez les épaules. Elle fait de même.%SPEECH_ON%Eh bien, c\'est joli. Si vous voyez quelque chose comme ça ici, venez me le dire, d\'accord ? Je fais une robe pour mon mariage.%SPEECH_OFF% | Un homme remonte un sentier, balançant les jambes comme un soldat, tandis qu\'un ensemble de poissons morts pend à sa hanche. Il s\'arrête en vous voyant.%SPEECH_ON%Laissez-moi deviner, vous cherchez où ces prisonniers sont partis, non ?%SPEECH_OFF%Vous hochez la tête et demandez s\'il a vu où ils sont partis. Il secoue la tête, mais pointe ses pieds.%SPEECH_ON%Non monsieur, pas exactement. Mais il y a des traces juste ici. Voyez, humains et peaux vertes. Ça a peut-être quelque chose à voir avec eux, non ?%SPEECH_OFF%En effet. Vous ordonnez au %companyname% de se préparer pour une marche. | Le champ de bataille n\'a pas d\'indices, mais la zone juste à l\'extérieur en a : vous trouvez une série de traces entremêlées avec les empreintes d\'hommes et de peaux vertes. Sans aucun doute, elles mèneront aux prisonniers, ou du moins à ceux qui les ont pris. | %randombrother% vous appelle. À ses pieds se trouvent une série d\'empreintes de pieds larges et quelques-unes de plus en plus petites. Elles se combinent en formations qui s\'éloignent du champ de bataille. Le mercenaire vous jette un coup d\'œil.%SPEECH_ON%Sûr comme la merde que ce sont les prisonniers là-bas, et les orcs là-bas, et les petits qui les suivent sont des gobelins.%SPEECH_OFF%Vous hochez la tête et criez au %companyname% de se préparer à suivre les traces. | %randombrother% trouve quelques traces juste à l\'extérieur du champ de bataille. Vous venez inspecter et il pointe leurs tailles différentes tour à tour.%SPEECH_ON%Je pense que celles-ci appartiennent aux orcs, celles-là sont des gobelins, et celles-là, ce sont les prisonniers que nous cherchons.%SPEECH_OFF%Vous êtes d\'accord avec son évaluation. Si le %companyname% suit ces traces, il trouvera probablement les prisonniers et leurs ravisseurs.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "En Avant!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(playerTile);
						local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
						local camp;

						if (nearest_goblins.getTile().getDistanceTo(playerTile) <= nearest_orcs.getTile().getDistanceTo(playerTile))
						{
							camp = nearest_goblins;
						}
						else
						{
							camp = nearest_orcs;
						}

						if (this.Flags.get("IsEnemyParty"))
						{
							local tile = this.Contract.getTileToSpawnLocation(playerTile, 10, 15);
							local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "Greenskin Horde", false, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							party.getSprite("banner").setBrush(camp.getBanner());
							party.setDescription("Une horde de peaux-vertes en marche vers la guerre.");
							party.setFootprintType(this.Const.World.FootprintsType.Orcs);
							this.Contract.m.UnitsSpawned.push(party);
							party.getLoot().ArmorParts = this.Math.rand(0, 25);
							party.getLoot().Ammo = this.Math.rand(0, 10);
							party.addToInventory("supplies/strange_meat_item");
							this.Contract.m.Destination = this.WeakTableRef(party);
							party.setAttackableByAI(false);
							party.setFootprintSizeOverride(0.75);
							local c = party.getController();
							c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.0);
							c.addOrder(wait);
							local roam = this.new("scripts/ai/world/orders/roam_order");
							roam.setPivot(camp);
							roam.setMinRange(5);
							roam.setMaxRange(10);
							roam.setAllTerrainAvailable();
							roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
							roam.setTerrain(this.Const.World.TerrainType.Shore, false);
							roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
							c.addOrder(roam);
						}
						else
						{
							this.Contract.m.Destination = this.WeakTableRef(camp);
							camp.clearTroops();

							if (this.Flags.get("IsEmptyCamp"))
							{
								camp.setResources(0);
								this.Contract.m.Destination.setLootScaleBasedOnResources(0);
							}
							else
							{
								this.Contract.m.Destination.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

								if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
								{
									this.Contract.m.Destination.getLoot().clear();
								}

								camp.setResources(this.Math.min(camp.getResources(), 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
								this.Contract.addUnitsToEntity(camp, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}

						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.OrcFootprints, this.Const.World.FootprintsType.Orcs, 0.75, 10.0);
						this.Contract.setState("Pursuit");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Les peaux-vertes vaincues, vous vous dirigez vers leur camp pour trouver les prisonniers en cage et les yeux bandés. Vous ordonnez aux mercenaires de commencer à les libérer. Pensant être déjà morts, la plupart des prisonniers éclatent en larmes et vous remercient de les avoir sauvés. Tout en une journée de travail, vraiment. | Les peaux-vertes ont été vaincues et vous vous dirigez rapidement vers leur camp. Vous trouvez les prisonniers dans une tente, blottis les uns contre les autres sans vêtements. Les affranchis peuvent à peine parler, mais leurs yeux en disent long sur les horreurs qu\'ils ont vécues. %randombrother% va chercher des couvertures pour les couvrir lors du retour vers votre employeur, %employer%. | Les peaux-vertes ont été éliminées, maintenant vous et vos hommes commencez à fouiller leur camp abandonné. Vous entendez immédiatement des cris provenant d\'une tente. %randombrother% ouvre le rabat pour voir un gobelin agitant un fer chaud devant un groupe d\'hommes recroquevillés et nus. Le mercenaire tranche la tête de la créature d\'un seul coup avant même qu\'elle ne réalise le renversement de sa fortune. Les prisonniers crient, vous remerciant pour le sauvetage. Votre employeur, %employer%, devrait être très satisfait qu\'au moins certains de ses hommes rentrent chez eux. | Les peaux-vertes vaincues, vous et le %companyname% vous précipitez dans leur campement. Là, vous trouvez un gobelin torturant un homme décédé. %randombrother% saisit le gobelin inconscient et lui enfonce une lame à travers l\'arrière du crâne. Vous suivez les traces de sang jusqu\'à une tente voisine pour y trouver un groupe d\'hommes aux yeux bandés, recroquevillés les uns contre les autres. Ils s\'écartent de votre voix, mais vous leur faites rapidement comprendre que vous êtes là pour les aider. Les pauvres âmes ont beaucoup souffert. Les ramener à votre employeur, %employer%, et chez eux devrait favoriser une bonne convalescence. | Toute pensée que les peaux-vertes avaient de sortir vainqueurs de ce combat a été anéantie : ces sauvages sont bien morts. Vous ordonnez aux hommes de fouiller leur campement pour essayer de trouver les prisonniers. Il ne faut pas longtemps avant que %randombrother% ne trouve les hommes blottis sous une tente. Ils ont été battus et torturés, mais ils survivront. Quelques-uns vous remercient, et la plupart remercient les anciens dieux. Ces foutus dieux volent toujours la vedette. Quoi qu\'il en soit, votre employeur, %employer%, sera très satisfait. | Le %companyname% se débarrasse facilement des peaux-vertes et se précipite rapidement dans leur campement abandonné. Les horreurs qui s\'y trouvent dépassent l\'entendement. Des hommes embrochés sur des broches, d\'autres dressés vers le ciel au bout d\'énormes pieux. Heureusement, il y a encore de la lumière dans toute cette obscurité : les prisonniers que vous cherchiez sont trouvés. Ils sont gravement battus, mais ils sont en vie. | Les peaux-vertes ont été vaincues. Vous vous aventurez dans leur campement pour y trouver des horreurs étincelant fraîchement en rouge. Des figures écorchées suspendues contre des étagères de branches de thorn et d\'arbres tordus. Des corps gris éventrés, leurs visages émaciés et étirés témoignant encore d\'un dénouement des plus grotesques. D\'autres hommes sont trouvés dans une tranchée peu profonde, attachés face contre terre dans des eaux écumeuses, de gros rochers placés sur leur dos pour qu\'ils se noient avec le souffle à un pouce de distance.\n\nNon seulement vous vous inquiétez qu\'il n\'y ait pas de survivants, une partie de vous espère qu\'il n\'y en ait pas. De telles horreurs n\'étaient pas censées être perpétuées. Malheureusement, %randombrother% vous fait signe d\'approcher d\'une tente. À l\'intérieur, quelques prisonniers se blottissent les uns contre les autres, nus et se rétractant devant votre présence. Vous ordonnez au %companyname% de habiller, nourrir et abreuver les hommes pour le retour chez votre employeur, %employer%. | Le %companyname% vainc les peaux-vertes avec une relative facilité et se faufile dans le camp des sauvages. Là, vous trouvez des humains transformés en totems sacrés, de grands obélisques en os luisants et des cairns de crânes inclinés. %randombrother% vous appelle vers l\'une des tentes en peau de chèvre. Vous vous précipitez pour y trouver quelques prisonniers, chacun enfermé dans une cage de barbelés métalliques soigneusement pliés. Chaque homme est libéré avec précaution, et chacun se confie sur les horreurs qu\'il a endurées. Vous assurez aux hommes qu\'ils seront renvoyés auprès de leurs familles. | Après avoir vaincu les peaux-vertes, vous vous précipitez rapidement dans leur camp pour trouver les prisonniers. Ils sont attachés à une longue chaîne noire. Un orc frêle aux yeux tordus et aux mains difformes tente de s\'enfuir avec les hommes. %randombrother% s\'élance et assomme le peau-verte à l\'arrière de la tête. Il tombe par terre et roule sur un dos globuleux. La créature déformée et difforme lance un cri non appris, une rétardation de langage au-delà même de la langue orc brutale. %randombrother% hésite un moment, les yeux de l\'orc étant les seuls témoins d\'un monde qu\'il n\'a jamais compris, puis l\'homme serre les dents et écrase la tête de la créature.\n\nVous libérez les prisonniers qui expliquent qu\'ils allaient être emmenés par ce qui aurait pu être l\'idiot de la tribu. Quoi qu\'il en soit, ils sont maintenant sauvés et %employer% sera très heureux de les récupérer ! | Les peaux-vertes ont été vaincues et les prisonniers sont rapidement sauvés du campement des sauvages. Chaque prisonnier a une histoire d\'horreur à raconter, même ceux qui ne disent pas un mot. Votre employeur, %employer%, sera très satisfait. | Votre employeur, %employer%, ne devait probablement pas croire que cela arriverait, mais après avoir vaincu les peaux-vertes et pénétré dans leur campement, vous parvenez à sauver les prisonniers ! Ils ne sont pas en très bonne santé, mais voir le %companyname% au lieu d\'un orc avec un fer rouge ou une hache d\'exécution a certainement remonté leur moral. | Après avoir vaincu les peaux-vertes, le %companyname% se précipite rapidement dans le campement des sauvages. Là, vous trouvez les prisonniers attachés par des cordes à un poteau d\'appât à ours. Un ours mort est dans la boue, avec quelques hommes horriblement déchiquetés. Les survivants, qui ont apparemment tué l\'animal à mains nues, doivent être ramenés chez votre employeur à %townname% dès que possible. | Le %companyname% triomphe des peaux-vertes et se précipite pour trouver les prisonniers dans le campement des sauvages. Vous n\'êtes pas sûr que les soldats soient aptes à combattre un jour de plus, mais espérons que votre employeur, %employer%, les traitera avec soin de toute façon.}",
			Image = "",
			List = [],
			Options = [
				{
					 Text = "Nous avons ce pour quoi nous sommes venus. Il est temps de Retournez à %townname% !",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Scouts",
			Title = "Sur le site de la bataille...",
    		Text = "[img]gfx/ui/events/event_49.png[/img]{En fouillant autour des cadavres à la recherche d\'indices, vous êtes soudainement attaqué par un groupe de peaux-vertes ! Ils revenaient probablement pour piller le champ de bataille. Vous ordonnez rapidement aux hommes de se mettre en formation pendant que les sauvages font de même. | Un groupe de reconnaissance peau-verte, ayant l\'intention de piller le champ de bataille, a plutôt découvert le %companyname%. Préparez-vous au combat ! | En balayant la zone à la recherche d\'indices, un petit groupe de peaux-vertes tombe sur le %companyname%. Ils revenaient probablement pour le butin, mais maintenant vous allez les ajouter aux tas de cadavres ! | Le %companyname% recherche des indices lorsqu\'un groupe de pillards peaux-vertes revient sur le champ de bataille ! | Vous retournez un cadavre et un gobelin vous dévisage. Vous essayez de donner un coup de pied à ce corps aussi, sauf qu\'il grogne et attrape votre pied. Il n\'est pas mort ! En regardant vers le haut, vous voyez un groupe tout aussi surpris de pillards peaux-vertes vous fixant. Le gobelin crie et bat en retraite, et vous reculez également rapidement, ordonnant au %companyname% de se mettre en formation.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Scouts";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
						local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
						local camp;

						if (nearest_goblins.getTile().getDistanceTo(tile) <= nearest_orcs.getTile().getDistanceTo(tile))
						{
							camp = nearest_goblins;
						}
						else
						{
							camp = nearest_orcs;
						}

						p.EnemyBanners.push(camp.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GreenskinHorde, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor",
			 Title = "Sur le site de la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% fouille parmi les cadavres quand il recule brusquement.%SPEECH_ON%Monsieur ! On en a un vivant ici !%SPEECH_OFF%Vous vous précipitez pour voir un homme grimper hors d\'un tas de membres. Il se lève péniblement, un visage dégoulinant de sang se plissant à la lumière. L\'homme déclare qu\'il était ici dans la bataille - et qu\'il a l\'intention de la finir. Apparemment, il se joindra au %companyname% gratuitement ! | En fouillant les restes du champ de bataille, vous entendez soudainement un homme crier de sous les cadavres. %randombrother% commence à débarrasser les cadavres jusqu\'à ce que vous trouviez un visage d\'homme vous souriant.%SPEECH_ON%Par les vieux dieux, je pensais mourir là-dessous.%SPEECH_OFF%Vous demandez s\'il a combattu dans la bataille, ce à quoi il répond par l\'affirmative. Il tend une main et vous le tirez hors de la pile. Il sort en grattant les débris de sang de ses épaules. Apercevant la bannière du %companyname%, il demande si vous avez de la place pour un de plus.%SPEECH_ON%J\'ai une affaire inachevée, je suis sûr que vous comprenez.%SPEECH_OFF% | Vous étiez dans l\'erreur en pensant qu\'il n\'y avait rien ici que des morts : %randombrother% a trouvé un survivant enseveli sous les monticules de cadavres. Vous allez à sa rencontre, un guerrier qui se tient chancelant au sommet des cadavres des vaincus. Il rétrécit les yeux en reprenant ses repères.%SPEECH_ON%Ah, je reconnais ce sigle. Vous êtes le %companyname%. Eh bien, messieurs, je n\'ai guère d\'autre chose ici pour moi et je n\'ai jamais été très enclin à nettoyer des dégâts. Que diriez-vous de m\'accepter dans votre compagnie ?%SPEECH_OFF% | Un survivant est découvert sortant la tête de l\'aisselle d\'un guerrier orc. Il halète alors que %randombrother% et vous l\'aidez à le traîner dehors. %randombrother% lui donne à boire et vous demandez s\'il y a d\'autres survivants. Il hausse les épaules.%SPEECH_ON%Eh bien, ils criaient pendant un moment, mais maintenant ils ne le font plus. Dites, êtes-vous avec le %companyname% ?%SPEECH_OFF%L\'homme essuie sa bouche et lance une main vers la bannière de la compagnie. Vous hochez la tête. Il hoche la tête à son tour et prend une autre gorgée.%SPEECH_ON%Eh bien, mercenaires, il n\'y a pas grand-chose pour moi ici. Plus maintenant. J\'espère que ce ne serait pas trop demander, mais peut-être pourrais-je me joindre à votre compagnie ?%SPEECH_OFF% | Vous avez trouvé un survivant ! Un homme qui sort en grimpant du tas de cadavres comme un ver qui s\'échappe d\'un panier de pommes pourries. Il essuie le sang et les débris gris de son visage et rit.%SPEECH_ON%Je suis resté là-bas en pensant que les peaux-vertes reviendraient, mais vous les gars, vous êtes une vue pour les yeux endoloris, mon Dieu !%SPEECH_OFF%Alors que %randombrother% lui donne de l\'eau à boire, vous lui demandez s\'il y avait d\'autres survivants. Il hoche la tête.%SPEECH_ON%Ouais, et ils ont été faits prisonniers, les vieux dieux savent ce qu\'ils sont devenus. Dites, si c\'est le sigle du %companyname% que je vois, ça vous dérange si je me joins à la compagnie ? Vous avez sûrement remarqué qu\'il n\'y a pas grand-chose pour moi ici.%SPEECH_OFF% | Un homme se relève parmi les morts comme s\'il vous attendait depuis le début. %randombrother% recule effrayé, tirant son arme. Le survivant fait signe amicalement.%SPEECH_ON%Je dois admettre que je ne m\'attendais pas à votre groupe. J\'étais sûr que les peaux-vertes reviendraient pour piller ce qui reste ici. Dites, c\'est bien la bannière du %companyname% que vous arborez ?%SPEECH_OFF%Vous lui dites que oui. Il bat des mains et avance en trébuchant sur les crânes, les membres démembrés et en glissant ses pieds dans les trous boueux remplis de sang.%SPEECH_ON%Quelle chance ! J\'ai besoin d\'un nouvel équipement et si cela ne vous dérange pas, j\'aimerais rejoindre votre compagnie !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans le %companyname% !",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				},
				{
					Text = "Cela ne va pas se produire. Dégage d\'ici.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);
				this.Contract.m.Dude.setHitpointsPct(0.6);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getTitle() == "")
				{
					this.Contract.m.Dude.setTitle("the Survivor");
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Accident",
			Title = "Sur le site de la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Fouiller un champ de bataille n\'est pas la tâche la plus sûre, et cet axiome se concrétise lorsque %hurtbro% se blesse. | %hurtbro% a glissé et est tombé sur un tas d\'armes. Naturellement, il s\'est un peu blessé. | Malheureusement, %hurtbro% a glissé sur la boue ensanglantée et est tombé tête la première sur la mâchoire ouverte d\'un guerrier orc. Il a subi quelques blessures. | Les champs de bataille restent dangereux longtemps après la fin des combats : %hurtbro% a glissé et est tombé. Juste un peu amoché, il va bien. | Vous saviez qu\'un de ces idiots finirait par glisser tôt ou tard : %hurtbro% a mis son pied sur un bouclier qui a rapidement glissé le long d\'une montagne de cadavres. Il a dérapé droit dans un tas d\'armes et a subi quelques conséquences évidentes pour avoir fait cela. | %hurtbro% crie.%SPEECH_ON%Hey, regardez ça !%SPEECH_OFF%Il saute sur un bouclier et commence à le faire glisser le long d\'une montagne de cadavres. Malheureusement, une énorme main d\'orc heurte le bouclier et l\'envoie tourner en rond. Il vole en arrière du bouclier et atterrit sur un tas d\'armes. Il gémit de douleur. %randombrother% crie.%SPEECH_ON%{J\'ai vu ce que tu as fait là. | Il n\'y a aucune dame à impressionner par ici, abruti.}%SPEECH_OFF% | %hurtbro% ramasse une lame d\'orc rouillée et tente de s\'en servir. Malheureusement, il trébuche sur son ancien propriétaire et se coupe en tombant. L\'idiot guérira avec le temps. | Vous regardez %hurtbro% ramasser et tester diverses armes orques. Pour un bref moment, vous détournez le regard et le foutu imbécile se blesse. Vous vous retournez pour le voir penché en avant et gémissant de douleur. Ce n\'est pas grave, mais bon sang, vous souhaitez que ces idiots fassent plus attention. | Malgré votre demande aux hommes d\'être prudents, %hurtbro% parvient à glisser et à tomber sur le visage d\'un orc, ce qui reviendrait à glisser et à tomber sur une arme réelle. Il est blessé, mais il survivra. | %hurtbro% ramasse un petit gobelin et joue avec comme s\'il s\'agissait d\'une marionnette. L\'esprit du gobelin a dû prendre offense, car le mercenaire glisse sur un bouclier jeté et part en arrière, le gobelin mort faisant des pirouettes dans les airs. Le mercenaire est blessé, mais il survivra.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Soyez plus prudent.",
					function getResult()
					{
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.Contract.m.Dude = bro;
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " suffers " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "LuckyFind",
			Title = "Sur le site de la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Vous ne pensiez pas que les hommes trouveraient grand-chose en fouillant le champ de bataille, mais il semble que %randombrother% ait réussi à trouver une arme puissante ! | En fouillant les restes du champ de bataille, %randombrother% parvient à dénicher une arme particulièrement bien fabriquée qui a miraculeusement survécu au carnage intacte ! | Une arme puissante a été trouvée ! %randombrother% la brandit avec enthousiasme pour que tout le monde la voie. | %randombrother% commence à fouiller une pile d\'armes. Vous lui dites d\'arrêter avant de se blesser et de perdre un membre. Il se redresse soudainement, une relique de bataille à l\'aspect étrange entre ses mains.%SPEECH_ON%Oh ouais, qu\'est-ce que vous en pensez, monsieur ?%SPEECH_OFF%D\'accord, il remporte celle-ci. | Vous avertissez les hommes de rester à l\'affût des traces menant loin du champ de bataille, mais %randombrother% commence à fouiller les tas de cadavres à la recherche de quelque chose à piller. Juste au moment où vous alliez lui dire qu\'il va se faire mal, l\'homme se redresse, une arme très bien ouvragée en main. Vous lui faites un pouce levé.%SPEECH_ON%Bon travail, mercenaire !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pas mal du tout.",
					function getResult()
					{
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 10);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/greatsword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/billhook");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/noble_sword");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/warbrand");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/two_handed_hammer");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/greenskins/orc_axe_2h");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/greenskins/orc_cleaver");
				}
				else if (r == 9)
				{
					item = this.new("scripts/items/weapons/greenskins/named_orc_cleaver");
				}
				else if (r == 10)
				{
					item = this.new("scripts/items/weapons/greenskins/named_orc_axe");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Alors que vous suivez les traces, un orque surgit soudainement des buissons et hurle. D\'autres se précipitent hors de la végétation tout autour de vous. C\'est une embuscade ! | Vous suivez les traces, mais quelque chose semble clocher. Vous vous baissez, commencez à balayer la poussière et les feuilles d\'une trace. Elle est dirigée dans la direction opposée. Celui qui a laissé ces empreintes a fait demi-tour, ce qui signifie...\n\n%randombrother% complète votre pensée, pointant du doigt et criant.%SPEECH_ON%Embûche ! Orques !%SPEECH_OFF% | Vous arrivez sur une paire de traces qui bifurquent soudainement dans des directions aléatoires. En suivant leurs traces, vous réalisez qu\'elles disparaissent dans les buissons qui entourent le chemin. Vous soupirez et ordonnez à vos hommes de se préparer au combat. À peine avez-vous prononcé ces mots qu\'une horde d\'orques commence à surgir en embuscade ! | Les choses ne sont pas ce qu\'elles semblent être... Et juste au moment où vous pensez cela, un %randombrother% très exorbité et brûlé par le soleil crie.%SPEECH_ON%C\'est un piège !%SPEECH_OFF%Des orques sortent en masse des buissons environnants. C\'est une embuscade ! Vous ordonnez rapidement à vos hommes de se mettre en formation. | Les traces sont facilement suivies, presque trop facilement si vous êtes honnête à ce sujet - avant même que la pensée ne puisse être achevée, un orque surgit des buissons et grogne. De l\'autre côté du chemin, d\'autres orques font de même. C\'était un piège ! Préparez-vous au combat ! | Vous repérez une bifurcation dans les traces. Certaines continuent tout droit tandis que d\'autres se branchent et disparaissent dans les buissons le long du chemin. Il ne faut pas être un génie pour réaliser ce qui se passe : vous donnez des ordres à vos hommes pour les mettre en formation. Comme prévu, des groupes d\'orques sortent en criant des buissons pour tendre une embuscade au %companyname%. Préparez-vous au combat ! | Les traces disparaissent à vos pieds et vous savez exactement ce que cela signifie. Élevant la voix, vous donnez des ordres à vos hommes pour les mettre en formation. Les orques commencent à surgir des buissons en hurlant comme des banshees. C\'est une embuscade ! | Les traces continuent tout droit, mais vous remarquez des signes de terre remuée juste à côté d\'elles. Vous ordonnez aux hommes de s\'arrêter et vous baissez pour enquêter. En balayant les feuilles et la saleté, vous révélez lentement des traces qui se dirigent effectivement dans la direction opposée. Les orques ont fait demi-tour... %randombrother% crie.%SPEECH_ON%Embûche ! Embûche !%SPEECH_OFF%Vous vous retournez pour voir les sauvages sortir en criant des buissons avec des armes levées haut et la violence en tête. Prenant rapidement le commandement, vous ordonnez à vos hommes de se mettre en formation. Préparez-vous au combat !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
						p.EnemyBanners.push(nearest_goblins.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GoblinRaiders, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AmbushFailed",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{L\'embuscade déjouée, vous vous dirigez vers le camp des peaux-vertes pour trouver les prisonniers en cage et les yeux bandés. Vous ordonnez aux mercenaires de commencer à les libérer. Pensant déjà être morts, la plupart des prisonniers éclatent en larmes et vous remercient de les avoir sauvés. C\'est vraiment le travail d\'une journée. | L\'embuscade des peaux-vertes a échoué et vous vous dirigez donc vers leur camp. Tout orque qui traîne s\'enfuit rapidement, abandonnant tout. Vous trouvez les prisonniers dans une tente, recroquevillés sans vêtements. %randombrother% va chercher des couvertures pour les couvrir pendant le retour à %employer%. Les libérés peuvent à peine parler, mais leurs yeux en disent long sur les horreurs qu\'ils ont vécues. | L\'embuscade a été neutralisée, et vous et vos hommes commencez à fouiller le camp abandonné des peaux-vertes. Vous entendez immédiatement des cris provenant d\'une tente. %randombrother% ouvre le rabat pour voir un gobelin brandissant un fer chaud devant un groupe d\'hommes recroquevillés et nus. Le mercenaire coupe la tête de la créature d\'un seul coup. Les prisonniers crient, vous remerciant pour le sauvetage. %employer% devrait être très heureux que du moins certains de ses hommes rentreront chez eux. | L\'embuscade déjouée, vous et le %companyname% vous précipitez dans le camp des peaux-vertes. Vous y trouvez un gobelin qui torture un homme apparemment mort. %randombrother% saisit le gobelin inconscient et le roue de coups jusqu\'à la mort. Vous fouillez une tente voisine pour trouver un groupe d\'hommes les yeux bandés, recroquevillés dans un coin. Ils s\'éloignent de votre voix, mais vous leur faites rapidement comprendre que vous êtes là pour les aider. Les pauvres âmes ont beaucoup souffert. Les ramener à %employer% et à leurs foyers devrait faciliter leur rétablissement. | Toute pensée que les peaux-vertes avaient de sortir gagnantes de ce combat a été anéantie : ces sauvages sont complètement morts.\n\nVous ordonnez aux hommes de fouiller leur camp pour essayer de trouver les prisonniers. Il ne faut pas longtemps avant que %randombrother% ne trouve les hommes recroquevillés sous une tente. Ils ont été battus et torturés, mais ils vivront. Quelques-uns vous remercient, et la plupart des autres remercient les vieux dieux. Les maudits dieux volent une fois de plus votre éclair. Quoi qu\'il en soit, %employer% sera très heureux. | Le %companyname% met fin à l\'embuscade et se précipite rapidement dans le camp abandonné des peaux-vertes. Vous trouvez un homme sur une broche rôtissant sur un feu. Un autre pend d\'un arbre avec les pieds coupés. Des cris attirent votre attention vers une tente voisine où vous trouvez le reste des hommes recroquevillés ensemble et suppliant de l\'eau. Vos hommes commencent à distribuer de l\'eau et à soigner leurs blessures. Ils devront pouvoir marcher pour retourner chez %employer% et chez eux. | L\'embuscade a été prise en charge, mais qu\'en est-il des prisonniers ? Vous vous précipitez rapidement dans le camp des peaux-vertes abandonné pour trouver les prisonniers attachés à une série de poteaux. Malheureusement, l\'homme au bout a déjà été torturé à mort. Judicieusement par ses plaies encore suintantes, vous étiez juste un peu trop tard. Le reste des prisonniers crie d\'extase, cependant. L\'un après l\'autre, ils embrassent la terre devant vos pieds. Cependant, ce n\'est pas le moment de se sentir bien dans votre peau. %employer% vous attendra avec ses propres remerciements : une grosse pile de couronnes.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous avons ce pour quoi nous sommes venus. Il est temps de retourner à %townname% !",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "EmptyCamp",
			Title = "En vous approchant...",
			Texte = "[img]gfx/ui/events/event_53.png[/img]{Vous entrez dans le camp des peaux-vertes les armes à la main, mais trouvez l\'endroit entièrement abandonné. Des pots de ragoût sont renversés et des feux récents indiquent qu\'ils ont été rapidement abandonnés. %randombrother% ouvre une tente en peau de chèvre pour trouver les prisonniers rassemblés. Ils louent les anciens dieux à la simple vue de vous. %employer% sera content de ce résultat, et vous êtes content que les peaux-vertes aient abandonné sans combat. | Le camp des peaux-vertes est abandonné. Vous trouvez les restes carbonisés d\'un cochon laissé comme pitance et quelques ragoûts renversés. Ils ont certainement quitté les lieux en hâte.\n\n%randombrother% vous appelle. Les prisonniers sont dans un trou dans le sol avec de l\'eau jusqu\'à la taille. Une porte en bois pointue les empêche de sortir, bien qu\'elle soit emmêlée avec des vêtements ensanglantés, ce qui suggère qu\'au moins un homme a essayé. Vous soulevez rapidement le couvercle et les aidez à sortir. Vous regardez en bas et voyez un corps flottant dans l\'eau. Ils ne reviennent pas tous, mais %employer% devrait être plus que satisfait de ces quelques âmes chanceuses. | Vous vous précipitez dans le camp des peaux-vertes pour trouver les tentes renversées et une grande ruée de pas s\'éloignant de là. Ils l\'ont abandonné en hâte. %randombrother% rit.%SPEECH_ON%On dirait qu\'ils savaient que le %companyname% arrivait.%SPEECH_OFF%Soudain, une voix sort d\'une des tentes, criant et hurlant. Vous courez pour trouver un homme en hystérie, étendu par terre pendant qu\'un groupe d\'hommes aveuglés s\'agglutine dans un coin. Les prisonniers. Doigts, orteils, yeux, nez, membres manquants, le tic-tac du temps passé en compagnie des peaux-vertes. Vous secouez la tête et ordonnez aux hommes de commencer à distribuer des soins. %employer% sera heureux qu\'ils soient en vie, mais ces hommes sont certainement brisés pour toujours. | Le camp des peaux-vertes est vide. Quelques corbeaux noirs croassent et se battent pour un peu de ragoût renversé, tandis que des chiens errants détale à votre simple vue. Vos hommes commencent à fouiller les tentes en peau de chèvre laissées derrière. Rien n\'est trouvé jusqu\'à ce que votre pied s\'enfonce soudainement un peu plus dans le sol que prévu. Vous vous accroupissez et balayez le camouflage pour révéler une trappe. En la soulevant, vous trouvez une goulotte bien convertie par les peaux-vertes en une cellule de prison très verticale. Les prisonniers sont entassés comme des brindilles et regardent vers le haut à la lumière avec des visages flétris et usés par l\'eau. %randombrother% regarde en bas et grogne.%SPEECH_ON%Eh bien, ils sont en vie. J\'irai chercher de la corde.%SPEECH_OFF% | Des empreintes de pas s\'éloignent du camp. À en juger par l\'espacement et l\'éparpillement des ordures, ils étaient pressés. %randombrother% vous appelle. Il se tient devant une tente en tenant le rabat ouvert. Lorsque vous arrivez là-bas, vous voyez qu\'elle était utilisée pour loger les prisonniers. Ils sont tous nus et par terre, les oreilles bouchées de brindilles et les yeux bandés. On dirait qu\'ils ont été battus pour ne pas bouger sauf sur demande. Il y a une pile de membres humains dans un coin, et il semble que quelque chose avait pris l\'habitude d\'utiliser leurs crânes pour de l\'art primitif. Vous secouez la tête.%SPEECH_ON%Libérez-les et donnez-leur de l\'eau. %employer% espérait probablement le meilleur en récupérant ces hommes, mais c\'est à peu près ce à quoi je m\'attendais.%SPEECH_OFF% | Les peaux-vertes avaient abandonné leur camp. Vous n\'êtes pas sûr pourquoi, mais il est probable que leurs éclaireurs ont repéré votre compagnie et ont pris la décision de partir tant qu\'ils le pouvaient encore.\n\nLes hommes reçoivent l\'ordre de chercher les prisonniers, et ce n\'est pas long avant qu\'ils ne soient trouvés: une tente en peau de chèvre avec les hommes rassemblés sous un poteau, les mains attachées et les visages littéralement enfouis dans la saleté. On leur a donné des pailles pour respirer. %randombrother% se précipite et commence à les sortir de terre. Le visage de chaque homme est violacé et halète d\'air, mais ils sont en vie et la torture est terminée. %employer% devrait être heureux de les voir revenir. | L\'encampement est trouvé vide. %randombrother% ramasse un chaudron renversé qui fuit plus de déchets que de ragoût. Il le laisse tomber et secoue la tête.%SPEECH_ON%Le feu crépite encore. Ils sont partis en hâte.%SPEECH_OFF%Vous hochez la tête et ordonnez aux hommes de se disperser et de chercher les prisonniers. Pas plus tôt les mots ont quitté tes lèvres que tu entends quelqu\'un crier depuis une tente voisine. À l\'intérieur, tu trouves les prisonniers - ou du moins ceux qui ont survécu. D\'un côté de la pièce, les survivants sont nus et recroquevillés. De l\'autre, tu vois une flaque de sang, un billot d\'exécution, un maillet taché de rouge, et quelques corps coupés à la tête comme des marque-pages. %employer% ne récupérera pas tous ses hommes. | En entrant dans le camp des peaux-vertes, {tu trouves un gobelin qui enfourne des os dans un sac à dos. Il abandonne rapidement ses affaires. %randombrother% le pourchasse et lui plante une lame. | tu trouves un orc blessé adossé à un poteau. Il respire lourdement, mais d\'un coup rapide de sa lame, %randombrother% s\'assure qu\'il ne respire plus du tout.} Le reste du camp semble avoir été abandonné ; ce peau-verte est le dernier à rester. Tu trouves les prisonniers dans une tente. Ils ont les yeux bandés, et quelques-uns manquent de doigts ou d\'orteils. %employer% sera très satisfait. | Le camp a été abandonné, mais les prisonniers ont été laissés derrière. Tu les sauves, ou du moins ce qu\'il en reste : certains ont eu les doigts et les orteils arrachés, d\'autres respirent à travers des trous là où se trouvaient leurs nez. Mais ils sont en vie. C\'est ce qui compte, non ? | Tu arrives dans un campement qui a été abandonné précipitamment. Les peaux-vertes ont probablement vu arriver la %companyname% et ont pris une sage décision de partir pendant qu\'ils le pouvaient encore. Les prisonniers sont, heureusement, retrouvés vivants. Ils remercient les vieux dieux et s\'inclinent devant toi comme des miséreux devant un sage oraculaire. Tu procures de l\'eau aux pauvres survivants et te prépares à retourner chez %employer%. | Un seul orc est trouvé dans le campement. Il se repose contre une cage où les prisonniers sont enfermés. Un des prisonniers a une chaîne autour du cou de l\'orc et la tire contre les barreaux, gardien et prisonnier enlacés dans une lutte ironique. %randombrother% se précipite et lui plante une lame dans l\'œil, libérant les hommes. Les prisonniers sortent de la cage, embrassant la terre et sautant de joie. Un homme joyeux explique que les peaux-vertes sont parties précipitamment, et il semble qu\'elles étaient terriblement effrayées. Tu hoche la tête et pointes par-dessus ton épaule vers le sigle de la %companyname%.%SPEECH_ON%Elles ont eu raison de l\'être.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous avons ce que nous sommes venus chercher. Il est temps de retourner à %townname% !",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vous accueille dans sa chambre.%SPEECH_ON%J\'ai bien observé les prisonniers. Enfin, ce qu\'il en reste. Ils sont dans un sale état, mais vous avez fait du bon travail. %reward_completion% couronnes, c\'est ça ?%SPEECH_OFF% | %employer% parcourt sa chambre, jetant parfois un coup d\'œil par la fenêtre. En bas, les prisonniers sont pris en charge. Il secoue la tête.%SPEECH_ON%Je ne pensais vraiment pas qu\'un seul de ces pauvres bougres reviendrait. Vous avez bien fait, mercenaire.%SPEECH_OFF%Il fait glisser vers vous une bourse contenant %reward_completion% couronnes. | Vous trouvez %employer% en train d\'aider personnellement à nourrir les prisonniers. Il leur adresse des paroles bienveillantes. En vous voyant, il confie la tâche à un serviteur et vous emmène à l\'écart.%SPEECH_ON%Écoutez, je sais que ces hommes ne sont plus bons à rien. Les verts ne les ont pas tués, mais c\'est tout comme. Leurs corps tiennent bon, mais leurs âmes sont brisées. Peu importe. Vous avez fait ce que je vous ai demandé. Le garde là-bas aura %reward_completion% couronnes pour vous. Je ne sais pas comment vous faites, mercenaire. Le quotidien. Mais j\'apprécie vos services.%SPEECH_OFF% | %employer% fixe sa fenêtre, sa silhouette pâle éclairée à travers les minces rideaux. En bas, les prisonniers libérés sont pris en charge. Il secoue la tête et rejoint son bureau.%SPEECH_ON%C\'est triste de voir les hommes dans cet état.%SPEECH_OFF%Il prend une bourse de %reward_completion% couronnes et la pousse vers vous, continuant.%SPEECH_ON%Mais vous les avez ramenés chez eux, mercenaire, et c\'est ce qui compte le plus. Aucun homme ne mérite de mourir dans le camp d\'un sauvage.%SPEECH_OFF% | %employer% est retrouvé en train de regarder une série de parchemins. Un scribe est à ses côtés, regardant en bas alors qu\'il fait rouler une perle entre son pouce et son index. Ils lèvent tous deux les yeux vers vous lorsque vous entrez dans la pièce. Vous rapportez que les prisonniers ont été secourus. Le noble dépose un parchemin et fait signe au scribe qui vous paie promptement %reward_completion% couronnes. %employer% applaudit des mains.%SPEECH_ON%J\'espère que les hommes sont rentrés sains et saufs.%SPEECH_OFF%Lorsque vous ouvrez la bouche pour dire que certains d\'entre eux ne l\'ont pas fait, le noble vous coupe.%SPEECH_ON%Je n\'ai pas besoin d\'un discours, mercenaire. J\'ai du travail à faire.%SPEECH_OFF%Le scribe vous sourit chaleureusement en vous faisant sortir. | Les prisonniers sont confiés à un guérisseur qui s\'emploie à soigner leurs blessures horribles. Malheureusement, ce sont les cicatrices invisibles qui tourmenteront véritablement ces hommes pour le reste de leur vie. %employer% semble heureux, cependant.%SPEECH_ON%C\'est bien de les avoir de retour. Je ne pensais vraiment pas qu\'ils reviendraient un jour. Vos talents sont uniques, mercenaire.%SPEECH_OFF%Uniques, peut-être, mais pas tellement différents des autres compagnies de mercenaires : vous demandez votre paiement. Ce rappel incite le noble à claquer des doigts. Un garde vient immédiatement avec %reward_completion% couronnes. | Vous escorte les hommes secourus dans %townname%. %employer% est debout sur un balcon, applaudissant.%SPEECH_ON%Bravo, bravo ! Garde !%SPEECH_OFF%Un homme en armure se précipite vers vous avec une bourse de %reward_completion% couronnes. | Les prisonniers secourus sont pris en charge par un groupe de vieux guérisseurs qui, eux-mêmes, semblent avoir vécu des vies dans un camp de verts. Des guerriers blessés pris en charge par leurs aînés. %employer% semble très heureux, vous remettant personnellement une bourse de %reward_completion% couronnes.%SPEECH_ON%Vous savez, nous, les nobles, avions des paris sur le fait que ces hommes reviendraient ou non. J\'ai misé sur vous, mercenaire. Je savais que vous pouviez le faire ! J\'ai gagné plus d\'argent que je ne vous ai juste payé ! N\'est-ce pas hilarant ?%SPEECH_OFF% | Vous et %employer% regardez les prisonniers secourus entrer dans une boutique d\'apothicaire. Le noble hausse les épaules avec déception.%SPEECH_ON%Eh bien, merde.%SPEECH_OFF%Ce n\'était pas la réaction à laquelle vous vous attendiez. Il se penche et explique à voix basse.%SPEECH_ON%Nous avions des paris en cours sur le fait que ces hommes reviendraient. J\'ai perdu beaucoup de couronnes sur votre bon travail, mercenaire.%SPEECH_OFF%Vous hochez la tête et tendez la main.%SPEECH_ON%Eh bien, il est temps que vous perdiez %reward_completion% couronnes de plus.%SPEECH_OFF% | %employer% vous accueille à sa porte avec un sourire et une bourse de %reward_completion% couronnes.%SPEECH_ON%Nous avions une attente d\'échec ici, mercenaire. Moi, les autres nobles, les habitants de la ville. Personne ne pensait que ces hommes reviendraient un jour et pourtant, les voilà.%SPEECH_OFF% | %employer% veille personnellement à ce que les prisonniers secourus soient pris en charge, le noble distribuant de l\'eau, de la nourriture et des bandages. Cela semble plus fait pour la publicité que par sincérité. %employer% vous voit et vient vers vous, s\'essuyant le dos de la main sur votre manche.%SPEECH_ON%Ah, l\'un d\'eux m\'a saigné dessus. Voici vos %reward_completion% couronnes, mercenaire. Je doute qu\'ils me soient d\'une grande utilité, si je suis honnête, mais c\'est la pensée qui compte.%SPEECH_OFF%Étrangement, vous vous sentez obligé de lui dire de ralentir sur l\'honnêteté. | Vous aidez les prisonniers secourus à franchir les portes de %townname%. %employer% vous attend sur les marches d\'une boutique d\'apothicaire avec une escorte de gardes. Ils aident les hommes à prendre soin d\'eux. Le noble envoie un scribe vers vous avec une bourse de %reward_completion% couronnes. | Vous trouvez %employer% dans sa chambre. Une femme plutôt élancée écrase consciencieusement des feuilles avec un mortier et un pilon. Ne vous voyant pas, elle se tourne vers le noble, tenant le bol.%SPEECH_ON%Cela devrait aider à la cicatrisation.%SPEECH_OFF%%employer% vous voit par-dessus son épaule et se lève d\'un bond.%SPEECH_ON%Mercenaire ! C\'est bon de vous voir ! Je suppose que les prisonniers ont été secourus ?%SPEECH_OFF%Vous rapportez tout ce qui s\'est passé. Le noble fait signe à la femme de s\'avancer avec un sac de %reward_completion% couronnes.%SPEECH_ON%Donnez cet argent à cet homme, ma dame.%SPEECH_OFF% | Vous guidez les prisonniers secourus à travers les portes de %townname%. Une foule de femmes les attend, les épouses entourant leurs maris, les veuves s\'effondrant à genoux.\n\n%employer% s\'approche, une dame à chaque bras. Il fait signe à la scène.%SPEECH_ON%Très triste. Dites, quelle était votre récompense, %reward_completion% couronnes ?%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Freed prisoners from greenskins");
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
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"hurtbro",
			this.m.Dude == null ? "" : this.m.Dude.getName()
		]);

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.BattlesiteTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.BattlesiteTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
		}
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

