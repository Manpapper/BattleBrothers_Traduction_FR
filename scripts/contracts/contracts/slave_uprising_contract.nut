this.slave_uprising_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsEscortUpdated = false,
		IsPlayerAttacking = false
	},
	function setLocation( _l )
	{
		this.m.Destination = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 105) * 0.01;
		this.m.Type = "contract.slave_uprising";
		this.m.Name = "Révolte des Endettés";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 450 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("SpartacusName", this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)] + " " + this.Const.Strings.SouthernNamesLast[this.Math.rand(0, this.Const.Strings.SouthernNamesLast.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Renversez le soulèvement des endettés à %location% près de %townname%"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					this.Flags.set("IsOutlaws", true);
					this.Contract.m.Destination.setActive(false);
					this.Contract.m.Destination.spawnFireAndSmoke();
				}
				else if (r <= 40)
				{
					this.Flags.set("IsSpartacus", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsFleeing", true);
				}
				else
				{
					this.Flags.set("IsFightingBack", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Renversez le soulèvement des endettés à %location% près de %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = true;
				this.Contract.m.Destination.setOnEnterCallback(this.onDestinationEntered.bindenv(this));
			}

			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsSpartacus"))
					{
						this.Contract.setScreen("Spartacus4");
					}
					else if (this.Flags.get("IsFightingBack"))
					{
						this.Contract.setScreen("FightingBack2");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationEntered( _dest )
			{
				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Fleeing1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsOutlaws"))
				{
					this.Contract.setScreen("Outlaws1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSpartacus"))
				{
					this.Contract.setScreen("Spartacus1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFightingBack"))
				{
					this.Contract.setScreen("FightingBack1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "SlaveUprisingContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Outlaws",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Chassez les endettés qui ont maintenant recourt au banditisme autour de %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("Outlaws3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;
				this.World.Contracts.showCombatDialog();
			}

		});
		this.m.States.push({
			ID = "Running_Fleeing",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Chassez les endettés qui s\'enfuit de %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("Fleeing3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Fleeing2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{Normalement entouré d\'une opulence contemplative, %employer% se trouve dans un torrent de conseillers et de vizirs, chacun conseillant l\'autre en claquant des doigts et en pointant agressivement sur une carte. Malgré cette frénésie, un petit serviteur se faufile dans la foule et vient vous voir avec un parchemin. Il explique habilement que les endettés ont pris le dessus sur leurs maîtres à %location% dans %townname%.%SPEECH_ON%Les services d\'un mercenaire sont demandés. Si vous souhaitez participer à la restauration des statuts habituels pour tous les partis concernés, et pour l\'amélioration de la situation des endettés et des maîtres, veuillez prendre cette plume et faire une croix ici sur le parchemin.%SPEECH_OFF%Il vous fixe et vous le fixez. Il soupire et touche la page.%SPEECH_ON%Votre salaire, s\'il est accepté, est ici. %reward% couronnes.%SPEECH_OFF% | En vous approchant du bureau de %employer%, deux gardes s\'apprêtent à vous frapper avec le bout de leurs hallebardes. Cela provoque des cris et des bruits de pas précipités dans le couloir, alors qu\'un serviteur interfére après être arrivé en courant.%SPEECH_ON%Gardes ! Ces voyageurs mal habillés sont des mercenaires. Excusez-nous, mercenaire, mais nous sommes sur les nerfs pour la même raison que les vizirs ont besoin de votre aide : les endettés ont envahi %location% à %townname%. Le mouvement de révolte risque de s\'étendre à partir de là.%SPEECH_OFF%Le serviteur sort un parchemin et le tend. Il indique que %reward% couronnes attendent ceux qui écraseront la révolte des endettés, et le parchemin porte le sigle des différents vizirs de %townname%. | Les vizirs de %townname% sont réunis dans leur salle de guerre et il y a plus de tension que d\'habitude dans l\'air. Vous ne pouvez pas vous approcher d\'eux. Vous ne savez pas trop comment, mais de gros lingots d\'or ont été descendus du grenier. Ils discutent entre eux, hochant la tête de temps à autre, avant de tendre un parchemin à un serviteur. Vous observez le serviteur qui se précipite vers vous. Il vous le remet, puis en répète les mots de mémoire.%SPEECH_ON%Les endettés ont renversé leurs maîtres et se sont donc emparés de %location%. %reward% couronnes sont disponibles pour alimenter les coffres de l\'homme ou des hommes qui écraseront cette bande de rebelles.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ils n\'ont aucune chance. | Nous allons en faire un exemple. | Nous reprendrons %location%.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Je ne pense pas. | Nous n\'avons pas vocation à combattre d\'anciens esclaves.}",
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
			ID = "FightingBack1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Les endettés à %location% vous voient arriver et vous espérez que la présence de vos armes les dissuadera de poursuivre leur quête de liberté. Chose choquante, ils ne déposent pas les armes, mais s\'unissent pour se dresser contre vous. Il s\'agit d\'une bande hétéroclite, d\'un arrangement de ceux que le travail forcé et le recrutement a marqué. | Vous trouvez les endettés et ils vous regardent avec une compréhension très claire de la raison de votre présence. L\'arrangement des participants, vous-même armé jusqu\'aux dents, venant par la ville, les endettés, armés de ce qu\'ils ont récupéré, loin de leurs chaînes. Ils forment un triste regroupement hétéroclite, mais vous savez bien que ce qui leur manque en armement, ils le compensent largement en volonté. Le goût de la liberté leur donne du courage à se battre. | Comme décrit, les endettés ont pris le contrôle de %location% et se sont armés de tout ce qu\'ils ont pu trouver. En vous voyant, ils se hâtent de se regrouper, mais ils manquent d\'entraînement, de discipline, de nourriture et de bien d\'autres choses encore. Ce qu\'ils ont, par contre, c\'est le désir de ne pas retourner d\'où ils viennent, ce qui peut être un acier aussi tranchant et dangereux que n\'importe quel autre.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Détruisez-les !",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.OrientalBanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.desert_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						p.Tile = tile;
						p.CombatID = "SlaveUprisingContract";
						p.TerrainTemplate = "tactical.desert";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.NomadRaiders, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Slaves, 55 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FightingBack2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Le soulèvement a été écrasé. Dans la mort, les visages des esclaves semblent porter un certain soulagement, comme si la fin de toutes choses était préférable à la cruauté implacable de la vie à la chaîne. %employer% et les vizirs attendront votre retour.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Notre travail est terminé.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Outlaws1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_176.png[/img]{Vous arrivez à %location% pour la trouver brûlée et saccagée. Un survivant sort des cendres noircies d\'un bâtiment. Il explique que les endettés se sont attaqués à tous ceux qui étaient là, ravissant les femmes, tuant les enfants, volant tout ce qui avait de la valeur, puis se sont dispersés dans l\'arrière-pays. | Le soulèvement des endettés a depuis longtemps quitté %location%, laissant derrière lui un sillage de destruction et de mort. Un certain nombre de survivants ramassent leurs affaires en titubant. Ceux qui peuvent encore parler parlent d\'horreurs, les endettés s\'attaquant à la région comme des sauvages, tuant, ravageant, volant. Un homme dont les yeux sont recouverts de chiffons dit qu\'il les a entendus parler de se diriger vers la campagne et de s\'y séparer.%SPEECH_ON%Ce sont de simples bandits maintenant. Des animaux qui ont goûté au sang, pour eux il n\'y a pas de retour à la sécurité des chaines. Ils sont perdus.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous allons les chasser.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.Target.getPos(), 400.0);
						this.World.getCamera().moveTo(this.Contract.m.Target);
						this.Contract.setState("Running_Outlaws");
						return 0;
					}

				}
			],
			function start()
			{
				local cityTile = this.Contract.m.Home.getTile();
				local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(cityTile);
				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_nomads.getFaction()).spawnEntity(tile, "Endettés", false, this.Const.World.Spawn.NomadRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier(), this.Contract.getMinibossModifier());
				party.setDescription("Un groupe d\'endettées qui se sont tournées vers le banditisme.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getSprite("banner").setBrush(nearest_nomads.getBanner());
				party.getSprite("body").setBrush("figure_nomad_03");
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(8);
				roam.setMaxRange(12);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
			}

		});
		this.m.Screens.push({
			ID = "Outlaws3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Vous regardez le cadavre d\'un esclave, le corps modelé par les travaux d\'une vie passée, mais dans ses mains et autour de son cou les ornements d\'armes et de butins volés. Dans un cruel retournement de pensée, vous trouvez étrange qu\'ils auraient été plus faciles à abattre s\'ils n\'avaient eu d\'autre ambition que leur liberté. Mais c\'est leur avidité et leur sens du désir qui les ont rendus d\'autant plus dangereux. Mais... Ils sont morts. Et les vizirs de %townname% seront heureux, quels que soient les nobles objectifs des endettés.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Notre travail est terminé.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{Vous trouvez les endettés assis au milieu des rochers du désert et ils ne se lèvent pas à votre arrivée. Au lieu de cela, c\'est un homme qui vient à vous. Malgré sa puissante carrure, vous sentez qu\'il est venu pour négocier, une langue diplomatique enfouie dans tous ses muscles.%SPEECH_ON%Mercenaire, je me doutais que vous viendriez. Mon nom est %spartacus%, le chef élu de ces chercheurs de liberté, dans la mesure où la cage ouverte est le chef de l\'oiseau qui souhaite voler. Vous arrivez à nous par l\'appel des couronnes, conduits par la chaîne d\'or invisible, des promesses dont vous ne pouvez garantir le respect, et c\'est sur ces faux accords, ces arrangements mal compris, que vous devez venir nous tuer ou nous capturer. Est-ce bien le cas ?%SPEECH_OFF%Vous acquiescez. %spartacus% répond par un signe de tête.%SPEECH_ON%Il en est donc bien ainsi ainsi. Avant de nous engager à respecter nos accords, à être maîtres de nos mains et esclaves de la puissante couronne, permettez-moi d\'essayer de négocier d\'une manière que vous, mercenaire, jugerez bénéfique.%SPEECH_OFF%L\'homme s\'agenouille.%SPEECH_ON%Je suis le descendant d\'une famille perdue, d\'un héritage perdu, d\'un domaine perdu. Ces gens, ces hommes, sont ma famille aujourd\'hui. Mais de ma vie antérieure, je tiens quelque chose qui pourrait vous être utile.%SPEECH_OFF%Il tend une feuille de papier.%SPEECH_ON%Laissez-nous partir et j\'écrirai sur ce papier l\'emplacement des trésors que vous ne trouverez pas ailleurs. Attaquez-nous, et j\'emporterai dans la tombe les derniers héritages de ma famille, et je rendrai mon dernier souffle, non pas pour me préoccuper de ces richesses perdues, mais pour respirer le feu féroce de la liberté elle-même, scintillant dans mes poumons, la douleur étant préférable au confort de n\'importe quelle chaîne.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "J\'accepte vos conditions. Vous aurez votre liberté.",
					function getResult()
					{
						return "Spartacus2";
					}

				},
				{
					Text = "Ce n\'est que du business. Votre petite rébellion est sur le point d\'être écrasée.",
					function getResult()
					{
						return "Spartacus3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{Vous tendez la main. %spartacus% tend la sienne. Il parle.%SPEECH_ON%Qu\'il en soit ainsi.%SPEECH_OFF%Il brandit un crayon fait de roche et d\'un peu de poudre noire à son extrémité. Il pointe du doigt une pierre éloignée.%SPEECH_ON%Lorsque nous partirons, j\'écrirai l\'emplacement des objets de ma famille. Maintenant, je vois sur votre visage la question de savoir si je mens ou non. Cette incertitude est le prix de la liberté, non ? Ne pas savoir où l\'on va, mais le faire de son plein gré. C\'est cela la vraie liberté. Le confort de la cage est pour les oiseaux qui ne veulent pas voler, mercenaire. Que vos voyages sur la route de l\'or soient aussi fructueux que nos premiers pas.}",		
			Image = "",
			List = [],
			Options = [
				{
					Text = "Profitez de votre liberté tant qu\'elle dure.",
					function getResult()
					{
						local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local location;
						local lowest_distance = 9000;

						foreach( b in bases )
						{
							if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation"))
							{
								local d = b.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(1, 5);

								if (d < lowest_distance)
								{
									location = b;
									lowest_distance = d;
								}
							}
						}

						if (location == null)
						{
							bases = this.World.EntityManager.getLocations();

							foreach( b in bases )
							{
								if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation") && !b.isAlliedWithPlayer() && b.isLocationType(this.Const.World.LocationType.Lair))
								{
									local d = b.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(1, 5);

									if (d < lowest_distance)
									{
										location = b;
										lowest_distance = d;
									}
								}
							}
						}

						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.getFlags().set("IsEventLocation", true);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationMajorOffense, "S\'est rangé du côté des endettés lors de leur soulèvement");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus3",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{%spartacus% tend sa main, mais vous ne tendez pas la vôtre. Au lieu de cela, vous tirez votre épée. Le chef de la rébellion hoche la tête.%SPEECH_ON%D\'accord. Il vous est interdit de quitter la cage de la couronne, je vois, et vous êtes invité à vous rendre sur la route dorée. Votre asservissement est si urgent, votre captivité si grande, que lorsque la porte est ouverte, vous n\'ouvrez pas vos ailes, mais vous vous contentez d\'un simple saut jusqu\'au doigt du maître. Que la bataille nous traite bien, mercenaire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.OrientalBanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.desert_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						p.Tile = tile;
						p.CombatID = "SlaveUprisingContract";
						p.TerrainTemplate = "tactical.desert";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.NomadRaiders, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Slaves, 55 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus4",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Vous vous tenez au-dessus de %spartacus%. Malgré son goût pour la liberté, le chef défunt de la rébellion ne sourit pas dans son dernier moment de liberté. Son visage est déchiré par la douleur et ses blessures révèlent les motifs glissants de ce qui se cache sous la chair. Mais ses yeux. Il y a là une étincelle qui fixe le ciel. Une ombre traverse ses yeux et vous levez la tête, vous attendant à voir un oiseau, mais il n\'y a rien. Quand on baisse les yeux, l\'étincelle a disparu et le mort n\'est plus qu\'un mort.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Notre travail est terminé.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fleeing1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Vous trouvez un tas de chaînes brûlantes qui sont chaudes au toucher. Un vieil homme pointe sa main vers le nord.%SPEECH_ON%Les hommes libérés sont partis par là.%SPEECH_OFF%Curieux, vous lui demandez pourquoi il dénoncerait les endettés. Il sourit.%SPEECH_ON%J\'ai des travaux à finir et parfois les vizirs m\'en prêtent quelques-uns. Il est difficile d\'accomplir un bon travail avec mes seules mains.%SPEECH_OFF% | Vous tombez sur une longue piste de sable, de terre et de broussailles qui a manifestement subi des dégâts. Parmi les détritus du chemin, vous trouvez une chaîne, la dernière preuve dont vous avez besoin. Les endettés se sont tournés vers le nord et vous devrez les traquer. | Vous trouvez une manille qui s\'agite dans un buisson du désert. Un vieil homme sirotant de l\'eau dans une tasse grogne et indique la direction du nord.%SPEECH_ON%Les endettés sont passés par là. Si vous réussissez à les ramener au Vizir, vous pourrez peut-être parler de moi en bien. J\'aurais besoin d\'un homme ou deux pour aller chercher de l\'eau. Aucun endetté ne m\'a jamais apporté d\'eau.%SPEECH_OFF%Vous ne parlerez pas pour personne, mais remerciez-le quand même et partez vers le nord.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous allons les traquer.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.Target.getPos(), 400.0);
						this.World.getCamera().moveTo(this.Contract.m.Target);
						this.Contract.setState("Running_Fleeing");
						return 0;
					}

				}
			],
			function start()
			{
				local cityTile = this.Contract.m.Home.getTile();
				local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(cityTile);
				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_nomads.getFaction()).spawnEntity(tile, "Indebted", false, this.Const.World.Spawn.Slaves, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Un groupe d\'endettés.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getSprite("banner").setBrush("banner_deserters");
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				local c = party.getController();
				local randomVillage;
				local northernmostY = 0;

				for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
				{
					local v = this.World.EntityManager.getSettlements()[i];

					if (v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2)
					{
						northernmostY = v.getTile().SquareCoords.Y;
						randomVillage = v;
					}
				}

				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(randomVillage.getTile());
				c.addOrder(move);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Destination.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nomads, 0.75);
			}

		});
		this.m.Screens.push({
			ID = "Fleeing2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Vous rattrapez enfin les endettés. Ce sont de rudes voyageurs à présent, le morne terrain qu\'ils ont traversé ayant laissé ses marques sur eux comme sur n\'importe qui. Mais ils ne sont pas venus jusqu\'ici pour abandonner : ils s\'arment tous à votre vue et s\'approchent. | Les endettés se trouvent dans un état désespéré, car si le voyage leur a permis de respirer librement, ils l\'ont payé de leur corps et de leur esprit. Les hommes brûlés par le soleil, épuisés et en haillons s\'approchent avec des yeux à la fois écarquillés et fatigués. Vous savez à leurs regards féroces qu\'ils n\'ont plus d\'espoir. Ils se battront d\'une manière ou d\'une autre.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Détruisez-les !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fleeing3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Il est facile d\'en finir avec les endettés une fois que tout a été dit et fait. Les survivants se rendent incapables de revenir, préférant la mort par l\'acier. A leur place, vous n\'êtes pas sûr que vous auriez choisi autre chose. Vous rassemblez les preuves que vous pouvez et vous préparez à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Notre travail est terminé.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Vous ne trouverez pas %employer% avec un harem ou nageant dans le vin. Au contraire, il se pavane avec une cage à oiseaux vide à ses côtés. Il déclare sombrement que son oiseau préféré est sorti et s\'est envolé.%SPEECH_ON%Ne me considérez pas comme un idiot, Mercenaire, je vois que vous pourriez trouver des similitudes entre mon animal de compagnie et mes endettés. Sentez-vous libre, si je puis dire, de le faire. Mais vous manquez de perspicacité en pensant de la sorte. Mon oiseau volera librement et ne servira à rien d\'autre qu\'à être consommé. Mais ce n\'est pas la liberté, Mercenaire, de reprendre un devoir que la naissance lui a donné. La liberté lui a permis d\'échapper à une telle fatalité, de s\'échapper vers mon monde, une échappatoire que peu de ses congénères ont la chance de connaître.%SPEECH_OFF%Le vizir claque des doigts et un serviteur semble surgir de nulle part. Il vous tend une bourse de pièces. Vous levez les yeux pour voir le vizir poser la cage et s\'éloigner. | %employer% est enterré parmi les membres de son \"harem préféré\", comme le dit le gardien. Il ouvre la bouche et on a l\'impression que ses yeux vous fixent depuis le creux d\'un genou en sueur, bien qu\'il n\'y ait rien à dire.%SPEECH_ON%Le mercenaire victorieux revient pour se délecter de mes plus belles marchandises. C\'est ainsi, disent mes éclaireurs, que vous avez détruit ces endettés rebelles et que le message de leur mort a été réédité sous la forme d\'une nouvelle utilité, un mot gentil, écrit de votre main, Mercenaire, en guise d\'avertissement à tous les autres endettés.%SPEECH_OFF%Le vizir disparaît momentanément, puis réapparaît entre les cuisses d\'une femme.%SPEECH_ON%Serviteurs ! Payez le Mercenaire.%SPEECH_OFF%Deux garçons en armure portent un petit coffre et le déposent à vos pieds. Il est assez lourd et on ne vous aide pas à le porter. | Un homme enchaîné vient à votre rencontre à l\'extérieur des locaux de %employer%. Il a une chaîne attachée à chaque bras. L\'une des chaînes est accrochée au mur, l\'autre traverse le sol jusqu\'à un coffre contenant des couronnes. Les deux chaînes sont retenues par un cadenas. Et c\'est cet homme qui en a la clé. Il vous regarde fixement, ses doigts serrant et desserrant la clé, son souffle irrégulier. Il s\'accroupit enfin et déverrouille le cadenas deu coffre, que vous saisissez et reculez. L\'esclave tient la clé sur sa poitrine, jette un coup d\'œil à l\'autre serrure, replie sa main autour de la clé, incline la tête et fait un bruit dont vous ne savez que faire. Un garde lui dit de se taire avant de vous raccompagner à la porte.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Les couronnes sont des couronnes.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Réprimer une révolte d\'endettées");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination.getRealName()
		]);
		_vars.push([
			"spartacus",
			this.m.Flags.get("SpartacusName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/slave_revolt_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnEnterCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
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

		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(location));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

