this.intercept_raiding_parties_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Objectives = [],
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.intercept_raiding_parties";
		this.m.Name = "Arrêter les groupes de pillard";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local towns = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isIsolated() || s.isCoastal() || s.isMilitary() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getActiveAttachedLocations().len() < 2)
			{
				continue;
			}

			if (this.World.getTileSquare(s.getTile().SquareCoords.X, s.getTile().SquareCoords.Y - 12).Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			towns.push(s);
		}

		towns.sort(function ( _a, _b )
		{
			if (_a.getTile().SquareCoords.Y < _b.getTile().SquareCoords.Y)
			{
				return -1;
			}
			else if (_a.getTile().SquareCoords.Y > _b.getTile().SquareCoords.Y)
			{
				return 1;
			}

			return 0;
		});
		this.m.Destination = this.WeakTableRef(towns[this.Math.rand(0, this.Math.min(1, towns.len() - 1))]);
		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("LastLocationDestroyed", "");
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Interceptez tous les groupes de pillards du Sud autour de %objective%",
					"Ne les laissez bruler aucun emplacement"
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
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsAssassins", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSlavers", true);
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					this.Flags.set("IsThankfulVillagers", true);
				}

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "Took sides in the war");
				}

				this.Contract.m.Destination.setLastSpawnTimeToNow();
				local locations = [];

				foreach( a in this.Contract.m.Destination.getActiveAttachedLocations() )
				{
					if (a.isUsable() && a.isActive())
					{
						locations.push(a);
					}
				}

				local cityState = cityStates[this.Math.rand(0, cityStates.len() - 1)];

				for( local i = 0; i < 2; i = ++i )
				{
					local r = this.Math.rand(0, locations.len() - 1);
					this.Contract.m.Objectives.push(locations[r].getID());
				}

				local g = this.Contract.getDifficultyMult() > 1.1 ? 3 : 2;

				for( local i = 0; i < g; i = ++i )
				{
					local tile = this.Contract.getTileToSpawnLocation(this.World.getTileSquare(this.Contract.m.Destination.getTile().SquareCoords.X, this.Contract.m.Destination.getTile().SquareCoords.Y - 12), 0, 10);
					local party;

					if (i == 0 && this.Flags.get("IsAssassins"))
					{
						party = cityState.spawnEntity(tile, "Regiment of " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(70, 90) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.Assassins, this.Math.rand(30, 40) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsAssassins", true);
					}
					else if (i == 0 && this.Flags.get("IsSlavers"))
					{
						party = cityState.spawnEntity(tile, "Slavers", true, this.Const.World.Spawn.Southern, this.Math.rand(60, 80) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsSlavers", true);
					}
					else
					{
						party = cityState.spawnEntity(tile, "Regiment of " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());

						if (this.Math.rand(1, 100) <= 33)
						{
							this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, this.Math.rand(10, 30));
						}
					}

					party.setDescription("Conscripted soldiers loyal to their city state.");
					party.setAttackableByAI(false);
					party.getLoot().Money = this.Math.rand(50, 200);
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Medicine = this.Math.rand(0, 3);
					party.getLoot().Ammo = this.Math.rand(0, 30);
					local r = this.Math.rand(1, 4);

					if (r <= 2)
					{
						party.addToInventory("supplies/rice_item");
					}
					else if (r == 3)
					{
						party.addToInventory("supplies/dates_item");
					}
					else if (r == 4)
					{
						party.addToInventory("supplies/dried_lamb_item");
					}

					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local wait = this.new("scripts/ai/world/orders/wait_order");
					wait.setTime(80.0 + i * 12.0);
					c.addOrder(wait);

					for( local j = 0; j < 2; j = ++j )
					{
						local raid = this.new("scripts/ai/world/orders/raid_order");
						raid.setTargetTile(j == 0 ? locations[0].getTile() : locations[1].getTile());
						raid.setTime(60.0);
						c.addOrder(raid);
					}

					this.Contract.m.UnitsSpawned.push(party.getID());
				}

				this.Flags.set("ObjectivesAlive", 2);
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

				foreach( i, id in this.Contract.m.UnitsSpawned )
				{
					local p = this.World.getEntityByID(id);

					if (p != null && p.isAlive())
					{
						p.getSprite("selection").Visible = true;
						p.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				local alive = 0;

				foreach( i, id in this.Contract.m.Objectives )
				{
					local p = this.World.getEntityByID(id);

					if (p != null && p.isAlive())
					{
						if (p.isActive())
						{
							alive = ++alive;
						}
						else
						{
							this.Flags.set("LastLocationDestroyed", p.getRealName());
						}
					}
				}

				if (alive < this.Flags.get("ObjectivesAlive"))
				{
					this.Flags.set("ObjectivesAlive", alive);
					this.Contract.setScreen("LocationDestroyed");
					this.World.Contracts.showActiveContract();
				}
				else if (alive == 0 || this.Contract.m.UnitsSpawned.len() == 0)
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() < 4.0 && alive > 0)
					{
						if (this.Flags.get("IsThankfulVillagers") && this.Contract.isPlayerNear(this.Contract.m.Destination, 500))
						{
							this.Contract.setScreen("ThankfulVillagers");
						}
						else
						{
							this.Contract.setScreen("PartiesDefeated");
						}
					}
					else
					{
						this.Contract.setScreen("Lost");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p == null || !p.isAlive())
						{
							this.Contract.m.UnitsSpawned.remove(i);
							break;
						}
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsEngagementDialogShown"))
				{
					this.Flags.set("IsEngagementDialogShown", true);

					if (_dest.getFlags().has("IsAssassins"))
					{
						this.Contract.setScreen("Assassins");
					}
					else if (_dest.getFlags().has("IsSlavers"))
					{
						this.Contract.setScreen("Slavers");
					}
					else
					{
						this.Contract.setScreen("InterceptParty");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerInitiated, true, true);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local alive = 0;

					foreach( id in this.Contract.m.Objectives )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.isActive())
						{
							alive = ++alive;
						}
					}

					if (alive == 0)
					{
						this.Contract.setScreen("Lost");
					}
					else if (alive == 1)
					{
						this.Contract.setScreen("Success1");
					}
					else
					{
						this.Contract.setScreen("Success2");
					}

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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Le bureau de %employer% est sombre et silencieux. Enfin, il serait noir et silencieux s\'il n\'y avait pas quelques bougies qui brûlent et des oiseaux qui piaillent. Debout dans l\'ombre, le noble parle.%SPEECH_ON%Les merdes du sud ont envoyé des raids vers le nord. C\'est une affaire gênante, vous savez, d\'avoir une paire de bâtards à la peau bronzée qui se baladent, pillant, tuant et violant. Ils veulent que je retire mes forces principales à l\'arrière, mais je ne veux pas. C\'est pourquoi vous êtes ici, mercenaire. J\'ai besoin que vous recherchiez ces parasites et que vous les tuiez tous. Il y a %reward% couronnes qui vous attendent si vous êtes à la hauteur de la tâche.%SPEECH_OFF% | Vous trouvez %employer% en pleine discussion avec ses lieutenants. Il a deux piles de jetons, l\'une beaucoup plus haute que l\'autre. Il prend dans la pile la plus haute et la met sur la plus petite.%SPEECH_ON%Et si j\'en affectais encore autant?%SPEECH_OFF%Les lieutenants secouent la tête.%SPEECH_ON%C\'est précisément ce que veulent les sudistes. Si nous retirons des hommes de la ligne de front, ils le sauront sûrement et en profiteront pour attaquer.%SPEECH_OFF%Tous les hommes lèvent soudain les yeux vers vous. %employer% sourit.%SPEECH_ON%Ah-ha, il semble que notre sauveur ne soit autre qu\'un mercenaire ! Oh, j\'ose dire qu\'un mercenaire peut s\'occuper de ça pour nous. Vous ici, capitaine, j\'ai besoin de combattants pour rester dans les environs de %townname% et la défendre contre les saboteurs et les pilleurs du sud. Vous aurez %reward% couronnes en échange de la bonne exécution de cette tâche !%SPEECH_OFF%Les lieutenants de l\'armée semblent hésiter à faire cette offre à un mercenaire tel que vous, mais vous avez le sentiment que les temps sont durs et qu\'ils n\'ont pas vraiment d\'autres alternatives. | Vous êtes conduit à la bibliothèque de %employer% où vous le trouvez en train de lire des parchemins. Il en brandit un.%SPEECH_ON%Dans des moments comme celui-ci, que pensez-vous que je lise ?%SPEECH_OFF%Vous supposez que les problèmes sont d\'ordre militaire. L\'homme secoue la tête.%SPEECH_ON%Agrarisme. Vous voyez, je suis actuellement en guerre. Mais les guerres ne sont pas seulement menées avec des hommes, mais avec des chaînes d\'approvisionnement, de la logistique, de la nourriture. Et ce sont toutes ces choses que le front intérieur fournit. Les bâtards du sud comprennent ce concept aussi bien que nous, et ils ont envoyé des pilleurs et des infiltrateurs pour nous détruire de l\'intérieur. Pour me distraire, pour distraire mes soldats. J\'ai besoin de vous pour extirper ces bâtards et protéger nos maisons, nos magasins, nos fermes. Si vous réussissez, je vous offrirai %reward% couronnes en récompense.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{C\'est peut-être le bon type de travail pour nous. | Repousser les envahisseurs du sud ? Notre compagnie répond à l\'appel ! | Très bien. Discutons davantage du paiement.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé autre part. | Cela va prendre trop de notre temps.}",
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
			ID = "LocationDestroyed",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{La fumée s\'élève au loin. Des cris sous les nuages, et des silhouettes fugaces dans les feux qui les ont produits. C\'est %location% à %objectif%, et elle a sans doute été détruite.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devons arrêter ça avant qu\'il ne soit trop tard.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "InterceptParty",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_156.png[/img]{Les habitants du sud apparaissent devant vous en pleine transition vestimentaire, à moitié vêtus de leurs propres vêtements et de ceux du nord, mais aussi chargés de coffres remplis de butins pillés. Un homme s\'amuse à virevolter dans une robe de mariée nordique. On pourrait croire à une fête amicale en les approchant s\'ils n\'étaient pas aussi couverts de sang et de cendres. Au combat ! | Vous trouvez le groupe de Sudistes qui se dirige vers le nord. A en juger par le sang sur eux, vous pariez qu\'ils ont déjà pavé une route de chaos à travers les fermiers de l\'arrière-pays. Au combat !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à les engager.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "PartiesDefeated",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Vous trouvez le dernier Sudiste qui respire et le saisissez par les cheveux pour le montrer à tous. Les paysans et les fermiers vous regardent lui couper la gorge jusqu\'à ce que son corps se libère et que sa tête tienne bien haut dans vos mains. La foule applaudit.%SPEECH_ON%Notre sauveur !%SPEECH_OFF%Nul doute que %employer% sera heureux d\'entendre parler de votre travail. | Les sudistes sont tués, et ceux qui ont survécu à leurs blessures sont attaqués par les locaux. C\'est une affaire de torture, avec beaucoup d\'écorchement, de coupe de bite, et de créativité sanglante. Mais vous n\'avez aucune sympathie pour les pilleurs. L\'attente du paiement de %employer%, cependant, suscite un peu d\'intérêt pour vous. | Les derniers Sudistes ayant été mis à mort, vous savez que %employer% sera plus qu\'heureux de vous payer ce que vous valez. En partant, vous trouvez quelques locaux en train de mutiler les cadavres des pilleurs, comme le veut la tradition dans cette région et dans toutes les autres parties de ce monde. | Avec un cri terrifiant trahissant son ancien sentiment de contrôle sur ce monde, le dernier pillard est mis à mort. Ses frères d\'armes sont traînés par les habitants, les cadavres sont découpés en morceaux ou brûlés. Vous regardez pendant un moment, mais vous finissez par avancer, sachant que %employer% vous attendra. | Les plus chanceux parmi les pillards sont les morts, car les blessés graves ne bénéficient d\'aucune pitié. Les habitants et les paysans se pressent sur le champ de bataille pour réclamer leurs victimes, certains d\'entre eux échangeant même des couronnes pour cela, et les pillards sélectionnés sont ensuite souillés, mutilés et torturés. Aucun n\'est tué et, en fait, dans un cas, un guérisseur semble être présent juste pour prolonger la souffrance. C\'est un beau spectacle, mais un spectacle encore plus beau serait que %employer% dépose une grosse récompense dans vos coffres.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez les hommes à partir.",
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
			ID = "Lost",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_94.png[/img]{L\'ennemi est parti, mais leur oeuvre est terminée. La fumée flotte autour des bâtiments incendiés, et les habitants qui n\'ont pas été pris comme esclaves pour être vendus dans le sud gisent morts dans les rues.\n\nIl est inutile que vous retourniez voir votre employeur, car vous avez peu de chances d\'être payé pour un échec. Mieux vaut chercher un nouveau travail ailleurs.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous avons échoué.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "N\'a pas réussi à défendre " + this.Contract.m.Destination.getName() + " des pillards du sud");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Assassins",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_165.png[/img]{Vous trouvez un fermier mort sur la route avec une dague incurvée dans le dos. Personne ne laisse une si belle dague derrière soi, et au moment où vous vous en doutez, ses meurtriers sont toujours là : un groupe d\'assassins du Sud. Ils se déplacent comme des ombres, et leurs lames d\'acier aiguisées brillent à chaque mouvement. Au combat ! | Une femme se précipite vers vous, sa robe en lambeaux s\'agite, ses bras se balancent, ses yeux sont écarquillés, le blanc des yeux se fond dans une mer de sang rouge comme des coquillages sur une plage cramoisie. Avant qu\'elle ne puisse dire un mot, elle grogne et tombe au sol en un instant. Une dague est plantée à l\'arrière de son crâne, et plus loin derrière elle, un homme en noir se tient accompagné d\'un groupe d\'assassins !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Slavers",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Le groupe de pilleurs du sud ressemble à un groupe d\'hommes comme on en verrait partout dans le monde. C\'est en regardant de plus près que vous réalisez qu\'ils sont des esclavagistes ! Le mélange de maîtres et d\'esclaves se déplace vers %companyname%, une formation agitée de personnes entraînées et non entraînées. Vous pouvez voir qu\'il y a des visages nordiques parmi la foule, mais malheureusement, ils sont brisés et préfèrent lever les armes contre la compagnie plutôt que de se battre pour la liberté. | Vous tombez sur les sudistes, mais ce ne sont pas du tout des pillards, ce sont des esclavagistes ! Ils ont des charrettes de femmes et d\'enfants, et lorsque vous les découvrez, les esclavagistes se dépêchent de décapiter tout homme récemment asservi qui représente une menace, tandis que le reste du groupe charge %companyname%. Avec le carnage dans l\'air, vous foncez sur le groupe en toute impunité !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ThankfulVillagers",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Vous avez mis à terre les derniers pillards du sud. Alors que vous ordonnez à la compagnie de collecter tout ce qui a de la valeur, un couple de villageois sort avec ses propres biens.%SPEECH_ON%Nous pensions que c\'était la fin du monde, et pourtant vous êtes là, nos chevaliers.%SPEECH_OFF%Bien que vous ne soyez pas un chevalier, vous n\'hésitez pas à accepter les louanges d\'un chevalier - et la récompense d\'un chevalier : les villageois vous offrent des cadeaux ! | Les pillards ayant été éliminés, vous vous retrouvez lentement entouré de villageois. Ils ont l\'air hagards et effrayés, mais ils apportent avec eux des paniers de marchandises. On vous les offre comme récompense pour les avoir sauvés. Ils semblent vous confondre avec les soldats de %employer%, mais vous ne pensez même pas à révéler que vous êtes un mercenaire. Vous acceptez les offrandes, vous tirez même votre chapeau et vous dites que c\'est juste votre travail, ce qui est le cas.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C\'est agréable d\'être apprécié.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				local p = this.Contract.m.Destination.getProduce();

				for( local i = 0; i < 2; i = ++i )
				{
					local item = this.new("scripts/items/" + p[this.Math.rand(0, p.len() - 1)]);
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vous salue, bien que ce ne soit pas un accueil aussi radieux que vous l\'auriez espéré. Son ton est quelque part dans le domaine de la déception paternelle.%SPEECH_ON%Vous avez un couple de pillard du sud. Pas génial, mais pas terrible non plus. Je vous paierai pour chaque groupe éliminé, mais j\'aurais aimé que vous fassiez mieux.%SPEECH_OFF%Vous avez presque envie de vous excuser, mais vous savez que tout signe de faiblesse de votre part pourrait entraîner un manque à gagner et vous gardez cela pour vous. Il vous paie les %reward% couronnes qui vous reviennent. | %employer% a quelques gardes avec lui quand vous entrez, bien qu\'il y ait quelques visages manquants dans la foule. L\'homme parle sombrement.%SPEECH_ON%Vous avez fait ce que vous pouviez, mercenaire. Il était peu probable que vous puissiez attraper tous les pillards. Je m\'en rends compte maintenant. Je vous offre, bien sûr, un peu de répit. Pour ce que j\'en sais, j\'ai engagé le mauvais homme, mais je ne le déciderai pas aujourd\'hui. Il y a trop de choses à reconstruire. Vous recevrez %reward% de récompense, comme convenu, pour chaque groupe d\'assaillants éliminé.%SPEECH_OFF% |  Vous entrez dans la chambre de %employer% pour trouver votre récompense de %reward% couronnes déjà calculée et sur la table. Il la désigne d\'un geste désinvolte de la main.%SPEECH_ON%Les pillards sont venus, vous vous êtes occupés de quelques-uns, les autres ont pillé et assassiné. Donc. Prenez votre paie de %reward% couronnes, mercenaire. C\'est en accord avec la qualité de votre travail, alors ne soyez pas surpris si vous trouvez que les couronnes sont un peu insuffisantes.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						this.World.Assets.addMoney(this.Math.round(this.Contract.m.Payment.getOnCompletion() / 2));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "A défendu " + this.Contract.m.Destination.getName() + " des pillards du sud");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
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
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous trouvez %employer% non pas dans sa salle de guerre, mais dans son bureau annexe avec un certain nombre de dames qui s\'agitent. Elles s\'occupent des toiles d\'araignée dans les coins, classent des parchemins dans une étagère ou dépoussièrent les meubles. Et elles sont toutes nues, bien sûr. L\'homme ouvre ses bras.%SPEECH_ON%J\'ai pensé qu\'il fallait fêter ça, car %townname% a été sauvé, sauvé par des gens comme toi, mercenaire !%SPEECH_OFF%Il est ivre, et les femmes s\'écartent doucement de son chemin lorsqu\'il déambule dans la pièce.%SPEECH_ON%Maintenant... maintenant -hic- maintenant je vous assure, que je n\'ai pas pioché dans vos %reward% couronnes. Tout est là -hic- là comme promis. La populace est satisfaite, et je suis satisfait. Très satisfait.%SPEECH_OFF%Il serre l\'une des femmes et elle réagit avec autant de vivacité qu\'un tapis tacheté. Vous prenez la bourse et partez, et quelques jeunes filles vous accompagnent tandis que %employer% tombe dans une stupeur muette. | Vous trouvez %employer% à l\'extérieur de sa salle de guerre  dans sa bibliothèque dont il y a peut-être plus d\'étagères que de livres. Mais il semble tout de même impressionné.%SPEECH_ON%Votre travail là-bas était splendide, mercenaire. Absolument splendide. Bien sûr, il y a eu des pertes, mais dans l\'ensemble les choses sont là où elles devraient être et ces merdes du sud ont été chassées. Avec votre aide, nos lignes de front n\'ont pas eu à se relâcher pour s\'occuper des foyers. Voici vos %reward% couronnes comme promis.%SPEECH_OFF%Lorsque l\'homme s\'écarte du chemin, vous voyez qu\'il a stocké un crâne fraîchement lustré sur l\'étagère. Il le montre du doigt avec un petit sourire enfantin.%SPEECH_ON%C\'est un de leurs crânes. Je vais y boire du vin, ou pisser dedans. Je n\'ai pas encore décidé.%SPEECH_OFF% | %employer% est assis à son bureau avec une pyramide de trois crânes. Sa main est posée dessus comme si l\'on caressait la tête d\'un chien. Vous remarquez qu\'il y a encore des lambeaux de chair et même des cheveux sur ces crânes. L\'homme parle joyeusement.%SPEECH_ON%Mes soldats peuvent rester en première ligne grâce à vous, mercenaire. Avoir géré ces pillards n\'a pas seulement sauvé la vie de beaucoup ici, mais a peut-être empêché la chute du premier domino d\'une série de nombreux autres. Sans votre aide, les pères, les frères et les fils sur le front auraient pu se replier pour s\'occuper de leurs familles et toute cette guerre aurait été foutue.%SPEECH_OFF%De sa main libre, il pousse en avant une bourse.%SPEECH_ON%Vos %reward% couronnes. Un paquet de pièces bien mérité, je dirais.%SPEECH_OFF%Il sourit sinistrement et tourne la tête vers les crânes.%SPEECH_ON%Je pense qu\'ils seraient d\'accord, mais je dois dire que dans cette affaire, je parlerai pour eux.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A défendu " + this.Contract.m.Destination.getName() + " des pillards du sud");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
		_vars.push([
			"objective",
			this.m.Destination.getName()
		]);
		_vars.push([
			"location",
			this.m.Flags.get("LastLocationDestroyed")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			foreach( id in this.m.UnitsSpawned )
			{
				local p = this.World.getEntityByID(id);

				if (p != null && p.isAlive())
				{
					p.getSprite("selection").Visible = false;
					p.setOnCombatWithPlayerCallback(null);
				}
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.getFaction());

		foreach( s in f.getSettlements() )
		{
			if (s.isIsolated() || s.isCoastal() || s.isMilitary() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getActiveAttachedLocations().len() < 2)
			{
				continue;
			}

			if (this.World.getTileSquare(s.getTile().SquareCoords.X, s.getTile().SquareCoords.Y - 12).Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			return true;
		}

		return false;
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

		_out.writeU8(this.m.Objectives.len());

		for( local i = 0; i < this.m.Objectives.len(); i = ++i )
		{
			_out.writeU32(this.m.Objectives[i]);
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

		local numObjectives = _in.readU8();

		for( local i = 0; i < numObjectives; i = ++i )
		{
			this.m.Objectives.push(_in.readU32());
		}

		this.contract.onDeserialize(_in);
	}

});

