this.investigate_cemetery_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		TreasureLocation = null,
		SituationID = 0
	},
	function setDestination( _d )
	{
		this.m.Destination = this.WeakTableRef(_d);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.investigate_cemetery";
		this.m.Name = "Sécuriser le Cimetière"; 
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Destination == null || this.m.Destination.isNull())
		{
			local myTile = this.World.State.getPlayer().getTile();
			local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements();
			local lowestDistance = 9999;
			local best;

			foreach( b in undead )
			{
				local d = myTile.getDistanceTo(b.getTile());

				if (d < lowestDistance && (b.getTypeID() == "location.undead_graveyard" || b.getTypeID() == "location.undead_crypt"))
				{
					lowestDistance = d;
					best = b;
				}
			}

			this.m.Destination = this.WeakTableRef(best);
		}

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
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
					"Securisez " + this.Flags.get("DestinationName")
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
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setLootScaleBasedOnResources(100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				local r = this.Math.rand(1, 100);

				if (r <= 10 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsMysteriousMap", true);
					this.logInfo("map");
					local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);
					this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
					this.Contract.m.Destination.setFaction(bandits.getID());
					bandits.addSettlement(this.Contract.m.Destination.get(), false);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (r <= 40)
				{
					this.logInfo("ghouls");
					this.Flags.set("IsGhouls", true);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Ghouls, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (r <= 70)
				{
					this.Flags.set("IsGraverobbers", true);
					this.logInfo("graverobbers");
					local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);
					this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
					this.Contract.m.Destination.setFaction(bandits.getID());
					bandits.addSettlement(this.Contract.m.Destination.get(), false);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else
				{
					this.logInfo("undead");
					this.Flags.set("IsUndead", true);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Zombies, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsUndead") && this.World.Assets.getBusinessReputation() > 500 && this.Math.rand(1, 100) <= 25 * this.Contract.m.DifficultyMult)
					{
						this.Flags.set("IsNecromancer", true);
						this.Contract.setScreen("Necromancer0");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);

					if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("AttackGhouls");
					}
					else if (this.Flags.get("IsGraverobbers"))
					{
						this.Contract.setScreen("AttackGraverobbers");
					}
					else if (this.Flags.get("IsUndead"))
					{
						this.Contract.setScreen("AttackUndead");
					}
					else if (this.Flags.get("IsMysteriousMap"))
					{
						this.Contract.setScreen("MysteriousMap1");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Necromancer",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}

				this.Contract.m.BulletpointsObjectives = [
					"Sécurisez " + this.Flags.get("DestinationName")
				];
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("Necromancer3");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsNecromancerDead", true);
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);
					this.Contract.setScreen("Necromancer2");
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
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsNecromancer"))
					{
						if (this.Flags.get("IsNecromancerDead"))
						{
							this.Contract.setScreen("Success3");
						}
						else
						{
							this.Contract.setScreen("Necromancer1");
						}
					}
					else if (this.Flags.get("IsUndead"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsMysteriousMapAccepted"))
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							this.Contract.setScreen("Failure1");
						}
						else
						{
							this.Contract.setScreen("Failure2");
						}
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% marche de long en large en s'arrêtant de temps en temps pour vous adresser la parole.%SPEECH_ON%Les gens sont dans la tourmente ! Des tombes du cimetière ont été découvertes ouvertes et fouillées. Un simplet prétend que ce sont les morts qui sortent des tombes - une absurdité superstitieuse. Il s'agit de toute évidence de pilleurs de tombes assez audacieux pour venir à %townname% et nous accablent de leur présence avide !%SPEECH_OFF%Il tape du poing sur la table en signe de colère.%SPEECH_ON%Allez au cimetière et mettez fin à ces nuisibles une fois pour toutes !%SPEECH_OFF% | %employer% s'installe dans son fauteuil, en riant tout seul.%SPEECH_ON%Ne vous alarmez pas, mercenaire, mais on dit qu'il y a des fantômes ! Oui, oui, les paysans du coin empoisonnent mes matinées en parlant constamment de fantômes et de gobelins. Ils disent que ces supposées créatures mettent le cimetière sens dessus dessous, qu'elles font des raids sur les tombes pour agrandir leur armée ou d'autres sornettes. De toute évidence, ce n'est que l'oeuvre d'hommes armés de bêches qui ont l'intention de piller les tombes pour des bijoux. J'ai déjà vu ça avant.%SPEECH_OFF%Il baisse les yeux sur ses mains, en gloussant brièvement.%SPEECH_ON%Bref, je ne peux pas laisser tomber parce que ces paysans ne me lâchent pas d'une semelle. Alors, pour les soulager, il y a... vous. J'ai besoin que vous alliez au cimetière et que vous éliminiez tous les fauteurs de troubles que vous trouverez. La façon de faire est à votre discrétion, mais je vais vous suggérer un bon acier, si vous voyez ce que je veux dire...%SPEECH_OFF% | %employer% a la carte d'un cimetière sur son bureau. La moitié des carrés de terrain semblent avoir été remplis d'encre.%SPEECH_ON%Chaque carré que vous voyez là a été pillé. Chaque nuit, ils viennent, et chaque nuit, je n'arrive pas à les attraper. Je suis à bout de nerfs, alors j'ai décidé d'en finir une fois pour toutes. Je veux que vous alliez dans ce cimetière et que vous tuiez tous les voleurs de tombes que vous voyez. C'est compris ?%SPEECH_OFF% | %employer% est debout près de sa fenêtre, regardant dehors tout en buvant une chope d'hydromel. Il ne semble pas vraiment concentré sur quelque chose en particulier et parle même comme s'il pouvait ne pas se soucier de la conversation.%SPEECH_ON%Les pilleurs de tombes pillent le cimetière. Encore une fois. Je ne vous demande pas grand-chose, mercenaire, si ce n'est d'aller là-bas et de mettre fin à cette affaire stupide. Allez dans ce cimetière et tuez tous les profanateurs que vous voyez. C'est compris ? Bien.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "Parlons argent.",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "Pas intéressé.",
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
			ID = "AttackGhouls",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_69.png[/img]{Vous entendez des craquements. Des mâchouillements. Le ricanement de quelqu'un - ou de quelque chose - qui apprécie un bon repas. En traversant le cimetière, vous tombez sur une clairière remplie de Nachzehrers. Ils sont recroquevillés sur les restes de ce qui semble avoir été les pilleurs de tombes que vous recherchiez. Les monstres hideux se tournent lentement vers vous, leurs yeux rouges s'agrandissant à la vue de la viande fraîche. | Les pierres tombales s'écroulent lorsqu'un groupe de Nachzehrers les escalade. Ils semblent avoir fait une sorte de festin, quelques-uns d'entre eux rongeant encore un bras ou une jambe, vraisemblablement les membres de vos supposés pilleurs de tombes. | Vous entendez un cri strident et tournez rapidement au coin d'un mausolée pour trouver un Nachzehrer enfonçant ses dents dans la nuque d'un homme. La bête, dont la bouche est remplie de sang au point de s'écouler de ses narines, ne fait que lever les yeux vers vous. De plus petits Nachzehrer l'entourent, s'avançant pour s'assurer que leur prochain repas ne s'échappe pas...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AttackGraverobbers",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Les pilleurs de tombes sont là, comme prévu. Vous les surprenez en plein travail, vos frères d'armes sautent par-dessus les pierres tombales avec leurs armes brandi. | En entrant dans le cimetière, vous trouvez les pilleurs de tombes exactement comme %employer% le pensait. Ils vous repèrent tout comme vous les repérez. Vos hommes se déploient, armes dégainées, pour empêcher toute fuite. | Alors que vous passez entre les pierres tombales, quelques voix murmurent de l'autre côté d'un mausolée. Lorsque vous passez le coin, vous trouvez un groupe d'hommes debout au-dessus d'une tombe vide. Ils ont un cercueil ouvert devant eux, quelques-uns des hommes en retirant des bijoux. Vous ordonnez à vos hommes de charger. | %employer% avait raison : il y a eu des pilleurs de tombes ici. Vous repérez un certain nombre de tombes retournées et de tombes creusées. Les traces de boue vous conduisent à trouver les creuseurs en train de travailler sur un nouveau chantier.%SPEECH_ON%Je ne veux pas vous arrêter les gars, mais %employer% paie bien pour s'assurer que ces gens restent dans le sol.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AttackUndead",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Le cimetière est recouvert de brouillard - ou d'un épais miasme dégagé par les morts. Attendez... C'est les morts ! Aux armes ! | Vous regardez une pierre tombale avec un monticule de terre déterré à sa base. Des taches de boue s'éloignent comme une traînée de miettes. Il n'y a pas de pelles... pas d'hommes... En suivant la piste, vous tombez sur une bande de morts-vivants qui gémissent... et qui vous regardent maintenant avec une faim insatiable... | Un homme s'attarde au milieu des rangées de pierres tombales. Il semble vaciller, comme s'il était prêt à s'évanouir. %randombrother% vient à vos côtés et secoue la tête.%SPEECH_ON%Ce n'est pas un homme, monsieur. Il y a des morts-vivants dans la nature.%SPEECH_OFF%Au moment où il finit de parler, l'étranger au loin se tourne lentement et la lumière révèle qu'il lui manque la moitié du visage. | Vous découvrez que beaucoup de tombes ont été vidées. Pas seulement vidées, mais déterrées par en dessous. Ce n'est pas le travail de pilleurs de tombes...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MysteriousMap1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Vous entrez dans le cimetière pour trouver les pilleurs de tombes là où %employer% pensait qu'ils seraient : à genoux dans l'au-delà de quelqu'un d'autre. Dégainant votre épée, vous leur dites de déposer les bijoux avec lesquels ils pensent pouvoir s'enfuir. L'un des hommes se lève, les bras levés, et plaide sa cause.%SPEECH_ON%Avant de nous tuer, je peux dire quelque chose ? Nous avons une carte... Je sais, ça ressemble à un mensonge, mais écoutez-moi... Nous avons une carte qui peut mener à d'immenses trésors. Vous nous laissez partir, et je vous la donne. Tuez-nous et... vous ne la verrez jamais. Qu'est-ce que vous en dites ?%SPEECH_OFF% | Comme %employer% le soupçonnait, il y a des pilleurs de tombes qui rôdent autour des pierres tombales. Vous les arrêtez à mi-chemin et leur demandez s'ils ont un dernier mot à dire avant de rejoindre leurs victimes dans la boue. L'un des hommes implore votre pitié, affirmant qu'il a une carte au trésor qu'il échangera contre toutes leurs vies. | Vous tombez sur des hommes qui essaient d'ouvrir la porte d'un mausolée. Le claquement de votre épée contre votre botte attire leur attention.%SPEECH_ON%Bonsoir Messieurs. %employer% m'envoie.%SPEECH_OFF%Un des hommes laisse tomber ses outils.%SPEECH_ON%Attendez juste une seconde ! Nous avons une carte... oui, une carte ! Et si vous nous épargnez, je vous la donnerai ! Mais seulement si vous nous épargnez ! Si vous ne le faites pas... vous ne verrez jamais cette carte, compris ?%SPEECH_OFF% | Vous prenez de vitesse les pilleurs de tombes, dégainant vos épées alors qu'ils enfoncent leurs pelles dans la terre. L'un des hommes, sentant probablement qu'il est sur le point de rejoindre la tombe dans laquelle il a déjà un pied, négocie avec vous. Apparemment, les hommes ont une carte menant à un mystérieux trésor. Tout ce que vous avez à faire est de les laisser partir et ils vous la donneront. Si vous les tuez, la carte étant cachée, vous ne la verrez jamais, ni les trésors auxquels elle mène.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tuez-les tous!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Très bien, remettez-nous la carte et vous pourrez quitter cet endroit vivant.",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 8, 18, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.TreasureLocation = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/undead_ruins_location", tile.Coords));
						this.Contract.m.TreasureLocation.onSpawned();
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).addSettlement(this.Contract.m.TreasureLocation.get(), false);
						this.Contract.m.TreasureLocation.addToInventory("loot/silverware_item");
						this.Contract.m.TreasureLocation.addToInventory("loot/silver_bowl_item");
						return "MysteriousMap2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MysteriousMap2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Peut-être que %employer% essayait juste de tuer des gens pour un trésor ? Oui, c'est... logique, non ? Vous décidez de laisser partir les hommes en échange d'une carte qui vous indique le chemin vers %treasure_location% %treasure_direction% d'ici. | %employer% n'a rien dit sur le fait que ces hommes avaient une carte... peut-être qu'il essayait de faire disparaître cette information ? Qui sait. Mais la tentation du trésor est trop forte pour vous et vous décidez de laisser partir les hommes en échange de l'information. Leur carte révèle la %treasure_location%. L'endroit se trouve %treasure_direction% d'où vous vous trouvez. | Quand vous étiez enfant, vous faisiez tout le temps des chasses au trésor. C'est... étrangement excitant. Vous ne savez pas pourquoi, mais l'attrait de revivre cette vieille aventure vous pousse à laisser les hommes partir. En retour, ils vous montrent la carte qui révèle %treasure_location%, l'emplacement d'une cache de... dieu seul le sait ? Tout ce que vous savez vraiment, c'est qu'elle se trouve %treasure_direction% d'où vous vous trouvez.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ça a intérêt à valoir le coup.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.TreasureLocation.getTile().Pos, 700.0);
						this.Contract.m.TreasureLocation.setDiscovered(true);
						this.World.getCamera().moveTo(this.Contract.m.TreasureLocation.get());
						this.Contract.m.Destination.fadeOutAndDie();
						this.Contract.m.Destination = null;
						this.Flags.set("IsMysteriousMapAccepted", true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer0",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Après avoir tué tous les morts-vivants, vous trouvez un morceau de tissu qui brille violet dans votre main. Vous ne savez pas ce que c'est, mais pour une raison ou une autre, vous avez envie de le garder. %randombrother% pense que c'est stupide, mais ce n'est pas lui qui commande. | Après la bataille, %randombrother% trouve une tête de pelle avec ce qui semble être un symbole brûlé dessus. Il se demande si peut-être %employer%, votre employeur, sait quelque chose à ce sujet. Vous acceptez et emportez la ferraille avec vous pour voir si quelqu'un du coin pourrait l'identifier. | Une fois les monstruosités neutralisées, vous rengainez votre épée et parcourez le champ de bataille. Dans votre recherche, vous trouvez un étrange talisman fait de plumes de corbeau et de cuir de vache. Vous le mettez dans votre poche, pensant que %employer%, votre employeur, pourrait savoir quelque chose à son sujet.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps de collecter notre dû.",
					function getResult()
					{
						this.Flags.set("DestinationName", this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.NecromancerLair));
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{De retour chez %employer%, vous lui expliquez rapidement qu'il n'y avait pas de pilleurs de tombes, mais plutôt un groupe de morts-vivants. Il semble choqué, mais lorsque vous lui présentez l'artefact que vous avez trouvé, il pince les lèvres et acquiesce solennellement.%SPEECH_ON%Ça... ça provient de %necromancer_location%. Nous pensions pouvoir ignorer cet endroit, mais il semble que j'avais tort. Allez-y, mercenaire, et mettez fin à la terreur de cet endroit maudite une bonne fois pour toutes !%SPEECH_OFF%L'homme baisse un peu de ton.%SPEECH_ON%Oh, et je suis prêt à vous payer %reward_completion% couronnes en plus des %reward_completion% couronnes pour le travail de départ, bien sûr.%SPEECH_OFF% | Vous trouvez %employer% dans son bureau, sirotant solennellement un gobelet.%SPEECH_ON%Je connais déjà la nouvelle. Les morts marchent, oh, c'est effroyable de même juste le dire !%SPEECH_OFF%Vous hochez la tête et présentez l'artefact que vous avez trouvé dans le cimetière.%SPEECH_ON%Vous savez quelque chose à propos de ça ?%SPEECH_OFF%L'homme le regarde comme s'il savait déjà que vous l'aviez.%SPEECH_ON%Oui, ça vient de %necromancer_location%. Nous pensions pouvoir ignorer l'horreur qui vient de là-bas mais... eh bien, écoutez. Vous pouvez peut-être y aller ? Vous pouvez peut-être détruire %necromancer_location% et nous libérer de sa terreur ? Voici votre paiement initial, comme convenu, mais si vous nous aidez à détruire %necromancer_location%, vous recevrez %reward_completion% couronnes supplémentaires. Cela vous convient-il ?%SPEECH_OFF% | Vous entrez dans la chambre de %employer% et vous posez l'artefact sur son bureau. Il le repousse d'un coup de main.%SPEECH_ON%Où avez-vous eu ça ?%SPEECH_OFF%En pointant un doigt sur lui, vous faites pression sur l'homme.%SPEECH_ON%Saviez-vous qu'il y avait des morts-vivants dans le cimetière ?%SPEECH_OFF%Il détourne le regard d'un air penaud, puis acquiesce.%SPEECH_ON%Oui... je le savais. Les morts, et cet artefact, viennent de %necromancer_location%. Une sorte de sorcier sombre y habite et il nous pose des... problèmes depuis un moment maintenant. S'il vous plaît, pourriez-vous aller là-bas et le détruire ? Voici votre paiement pour le contrat initial, mais vous serez grandement récompensé pour nous débarrasser de ce maudit... quoi qu'il soit. Disons... %reward_completion% couronnes supplémentaires ?%SPEECH_OFF% | Vous expliquez à %employer% qu'il n'y avait pas de pilleurs de tombes au cimetière, ni d'humains d'aucune sorte d'ailleurs. Avant qu'il ne puisse parler, vous présentez l'artefact, le tenant dans la lumière pour qu'il puisse le voir. Il recule rapidement.%SPEECH_ON%Posez ça !%SPEECH_OFF%Comme une voix de feu, son cri enflamme l'artefact qui brûle sans douleur du bout de vos doigts, ne laissant que des cendres tourbillonnantes. %employer% met sa tête dans ses mains.%SPEECH_ON%Ça vient de %necromancer_location%. Un... nécromancien y vit, un marionnettiste qui tient les ficelles pour faire renaître les morts. S'il vous plaît, mercenaire, allez-y et détruisez-le. Nous vous serons si reconnaissants...%SPEECH_OFF%Il fait une pause pour sortir une sacoche remplie de couronnes.%SPEECH_ON%C'est ce que nous avions convenu à l'origine. Mais si vous tuez cet homme horrible à %necromancer_location%, il y aura %reward_completion% couronnes de plus qui vous attendront à votre retour.%SPEECH_OFF% | Vous présentez l'artefact que vous avez trouvé dans le cimetière. %employer% est surpris à sa vue, mais son expression se transforme rapidement en une acceptation sombre.%SPEECH_ON%Je vais être honnête avec vous, mercenaire. Il y a un nécromancien qui vit à %necromancer_location% pas loin d'ici.%SPEECH_OFF%Il se procure une sacoche de couronnes et vous la remet.%SPEECH_ON%C'est pour le travail initial. Cependant, j'offrirai %reward_completion% couronnes de plus, c'est tout ce que nous pouvons rassembler, si vous allez tuer cet homme maléfique maintenant.%SPEECH_OFF%Il se penche en arrière, en espérant que vous accepterez ces nouvelles conditions.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Très bien, nous allons traquer ce Nécromancien.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Sécuriser le Cimetière");
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 8, 15, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/undead_necromancers_lair_location", tile.Coords));
						this.Contract.m.Destination.onSpawned();
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).addSettlement(this.Contract.m.Destination.get(), false);
						this.Contract.m.Destination.setName(this.Flags.get("DestinationName"));
						this.Contract.m.Destination.setDiscovered(true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Necromancer, 115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

						if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
						{
							this.Contract.m.Destination.getLoot().clear();
						}

						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Home.getSprite("selection").Visible = false;
						this.Flags.set("IsAttackDialogShown", false);
						this.Contract.setState("Running_Necromancer");
						return 0;
					}

				},
				{
					Text = "Non, la compagnie en a fait assez.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Sécuriser le Cimetière");
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
			}

		});
		this.m.Screens.push({
			ID = "Necromancer2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{L'endroit est aussi épouvantable que vous l'aviez imaginé, une rencontre avec l'irréprochable, le summum de la putridité profane. Vous n'avez pas encore repéré le nécromancien, il serait donc préférable que vous avanciez prudemment... | %necromancer_location% est là où %employer% a dit qu'il serait. Vous trouvez une traînée d'ossements sur le chemin. Certains d'entre eux sont encore couverts de chair, peut-être des erreurs de nécromanciens des expériences qui n'ont pas réussi à passer de la mort à la non-mort. Ignorant ces horreurs, vous commencez à préparer votre attaque... | Un endroit comme %necromancer_location% est tellement envahi par les hautes herbes, les mauvaises herbes et les arbres noircis qu'il n'y a même pas besoin d'un panneau \"Défense d'entrer\". Mais il y en a quand même un. Il se présente sous la forme d'un puzzle squelettique, une horreur d'ossements rapiécés de toutes sortes d'hommes et de bêtes pour éloigner tout aventurier potentiel. Des limaces rampent dans ses orbites et des armées de fourmis pulsent le long de ses membres.\n\n %randombrother% s'approche, un peu perturbé par la vue, et demande comment vous souhaitez attaquer. | Vous trouvez d'abord un rongeur, les membres écartés, chaque petite main ou pied cloué avec une épingle à une planche de bois. Puis il y a le chien, sa tête remplacée par celle d'un chat. Vous jurez que la monstruosité a bougé quand vous vous êtes approché, mais peut-être que vous voyez juste des choses. Et puis... les gens. Il n'y a pas de mots pour décrire ce qui leur est arrivé, mais c'est un immense spectacle gore, le summum de l'atrocité.\n\n%randombrother% se place à vos côtés.%SPEECH_ON%Mettons fin à cette folie.%SPEECH_OFF%Oui, mettons-y fin. La question est, comment attaquer ?}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez l'attaque.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{%necromancer_location% a été nettoyé. Vous vous sentez presque saint pour cela, mais vous vous rappelez que vous avez fait ça pour l'argent, pas pour une cause juste. Non pas que vous préféreriez cette dernière, de toute façon. | Le nécromancien est mort et vous avez sa tête en main. Maintenant, il est temps d'aller le dire à cet idiot d'employeur pour qu'il vous paie ce que vous avez mérité. | Ce n'était pas un combat facile, mais %necromancer_location% est détruit. Le nécromancien est mort et, comme tout homme, est devenu un tas de chair et d'os. Curieux que ses tours de magie puissent ressusciter les morts, mais ne puissant pas être lancés en étant mort. Curieux, mais pas malheureux non plus. Vous prenez la tête du mécréant, juste au cas où. | Vous avez tué le nécromancien mais, craignant que ses tours ne dépassent les frontières de la tombe, vous lui avez coupé la tête et l'avez mise dans un sac. %employer%, votre employeur, devrait être très heureux de la voir. | La bataille est terminée, vous portez une épée au cou du nécromancien et retirez sa tête de ses épaules. Elle vient presque trop facilement, comme si elle voulait être dans vos mains. Quoi qu'il en soit, %employer%, votre employeur, voudra la voir comme preuve de ce que vous avez fait ici.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps de collecter le paiement pour la tête.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% sourit sournoisement quand vous revenez.%SPEECH_ON%Sale affaire, n'est-ce pas ? J'ai déjà entendu les nouvelles, ça va vite par ici. C'est dommage que nous ayons dû procéder de cette façon, mais qui sait ce que vous auriez facturé autrement pour combattre ces... choses.\n\n Hé... vous êtes toujours payé.%SPEECH_OFF%Il désigne un coffre en bois dans un coin.%SPEECH_ON%Les %reward_completion% couronnes sont là-dedans, comme nous l'avions convenu.%SPEECH_OFF% | %employer% écoute votre rapport puis s'adosse lentement à sa chaise.%SPEECH_ON%Il y a eu beaucoup de rumeurs concernant ces... choses. Les morts qui se promènent ?%SPEECH_OFF%Il fixe son bureau, puis vous regarde avec colère.%SPEECH_ON%C'est absurde ! Je ne le croirai pas. Vous obtiendrez %reward_completion% couronnes comme convenu. Vous ne m'extorquerez plus rien avec ces... ces mensonges !%SPEECH_OFF%Vous auriez vraiment dû apporter une ou deux têtes, mais là encore, une tête de mort ressemble remarquablement à une tête morte-vivant... | %employer% écoute votre rapport sur les morts-vivants et hausse les épaules.%SPEECH_ON%Quel dommage.%SPEECH_OFF%Il sirote nonchalamment le bord d'un gobelet et lance une main vers le coin de la pièce.%SPEECH_ON%Votre paie est dans ce coffre. %randomname% vous accompagnera jusqu'à la sortie.%SPEECH_OFF% | %employer% se serre les mains puis les laisse tomber sur ses genoux.%SPEECH_ON%J'ai entendu parler de ces... choses. Ces monstruosités ambulantes. Ce n'est pas bon d'entendre qu'elles sont venues à %townname%, mais je suppose que si elles doivent être quelque part, le cimetière serait le mieux ! Mieux que la place du village, en tout cas.%SPEECH_OFF%Il rit nerveusement tout seul.%SPEECH_ON%%randomname% est devant ma porte avec votre paie. Merci, mercenaire.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Sécuriser le Cimetière");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vous accueille dans son bureau.%SPEECH_ON%Vous les avez tous tués ? C'est sécurisé ?%SPEECH_OFF%Vous haussez les épaules. %SPEECH_ON%Personne ne va creuser des tombes de sitôt.%SPEECH_OFF% | Vous trouvez %employer% blotti dans son fauteuil, tenant une bougie près d'un parchemin bien usé. Il parle sans lever les yeux.%SPEECH_ON%Mon problème, vous vous en êtes occupé ?%SPEECH_OFF%Vous acquiescez.%SPEECH_ON%Je ne serais pas là si je ne l'avais pas fait.%SPEECH_OFF%%employer% pose une main sur le coin de son bureau.%SPEECH_ON%Votre paiement. %reward_completion% couronnes, comme convenu.%SPEECH_OFF% | %employer% est en train de parler à certains de ses hommes quand vous retournez dans sa chambre. Il les écarte et vous demande où en est la tâche. qu'il vous a confiée. Vous lui signalez qu'il est de nouveau possible d'enterrer les être aimés à %townname%. %employer% sourit.%SPEECH_ON%Bien. Bien. Votre paiement.%SPEECH_OFF%Il claque des doigts et l'un des hommes s'avance, vous tendant une sacoche. Il y a %reward_completion% couronnes dedans, comme promis.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Sécuriser le Cimetière");
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
		this.m.Screens.push({
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% with the head of the necromancer. It\'s so incredibly light for what is ostensibly a human head.%SPEECH_ON%Is that the foul creature who has been turning up our graves with the undead?%SPEECH_OFF%Nodding, you set the head down. The face gasps and %employer% leaps away.%SPEECH_ON%He\'s still alive!%SPEECH_OFF%You shrug and drive a dagger through the brainpan. The necromancer\'s eyes turn up toward the hilt and his teeth chatter with laughter, then the eyes recede back into their sockets and a faint tendril of red smoke spools out and then there is nothing more. %employer%, shaking, sits back down and motions toward a satchel in the corner. It\'s your payment and it\'s quite heavy. | %employer% is sitting down when you enter his study, but he immediately stands and backs away at the sight of the necromancer\'s head dangling from your hand.%SPEECH_ON%I-I take it that... that\'s him? Right? That\'s him? It\'s over?%SPEECH_OFF%You nod and toss the head onto the man\'s desk. It turns onto its face, wobbling back and forth on the pinched cheeks of a deathly grin. %employer% knocks it away with a book.%SPEECH_ON%Good. Excellent! As promised, your pay...%SPEECH_OFF%He gestures to a corner where a {wooden box | large satchel} rests. You take it, count it, and make your leave. | %employer% looks up from his book.%SPEECH_ON%By the gods, is that the necromancer\'s head in your hand?%SPEECH_OFF%You nod and toss it to the floor. A cat unspools from its bookshelf-roost and comes down to paw at it. %employer% gets up and takes a few books from the shelf, revealing a large box. He takes it and gives it to you.%SPEECH_ON%I\'d been saving this for special moments and I suppose this would be one.%SPEECH_OFF%You think it\'s going to be an item, maybe an amulet or something mysterious, but instead it\'s just a good pile of crowns. | Returning to %employer%, you\'ve got the necromancer\'s head in hand and the man quickly motions for you to give it over. No qualms doing that...\n\n%employer% lofts it up in both hands, studying it as though a man would a sick baby. After a few moments, he sets the head down in the clutching grip of a broken trident prong.%SPEECH_ON%I think it looks good there. Yes you do, don\'t you?%SPEECH_OFF%The man puts a thumb to the necromancer\'s pale chin. You clear your throat and inquire about payment, to which %employer% motions for one of his guards to come in. A satchel is brought to you from which you count %reward_completion% crowns. Satisfied, you leave %employer% to... whatever it is he\'s doing.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Sécuriser le Cimetière");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% is standing at the window when you enter.%SPEECH_ON%The songbirds seemed rather angry today. As though nothing they\'d say was worth saying. I thought that was interesting. Do you?%SPEECH_OFF%He suddenly turns toward you.%SPEECH_ON%Hmm, mercenary? No? My little birds told me that the graverobbers left town. Alive. Free to go where they please, free to return as they please. What an oddity, because usually dead men aren\'t free to do anything. What did I ask you to make those graverobbers?%SPEECH_OFF%You hesitate. The man answers for you.%SPEECH_ON%I wanted you to make them dead. Now they aren\'t. Now you don\'t get paid. Ah, how simple. And now? Now you get out of my house.%SPEECH_OFF% | %employer% laughs as you enter his room.%SPEECH_ON%I\'m honestly surprised you returned. I should find it insulting, really, that you\'d think I wouldn\'t know better. The graverobbers were spotted on the road. The graverobbers I asked you to kill. Remember that? Remember when I said go and kill them? I\'m sure you do. I\'m also sure you remember when I said that\'s what I was paying you for. So... no dead graverobbers...%SPEECH_OFF%He slams his desk with a fist.%SPEECH_ON%No pay! Now get out of my home!%SPEECH_OFF% | You find %employer% in his chair, rolling an empty goblet between his hands.%SPEECH_ON%It\'s not often I run across someone who tries to cheat me. That\'s what you were going to do, coming back here, right? I know the graverobbers aren\'t dead, sellsword. I\'m no fool. Leave my sight before I have my men butcher you.%SPEECH_OFF% | %employer% is reading a book when you enter his room.%SPEECH_ON%You have ten seconds to turn around and leave. Ten. Nine. Eight...%SPEECH_OFF%You realize he knows that the graverobbers were not taken care of.%SPEECH_ON%...four... three...%SPEECH_OFF%You turn and hastily leave the room.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Damn this!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoralReputation(-1);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% purses his lips.%SPEECH_ON%You\'ve put me in an odd spot, mercenary. You tell me the graverobbers are taken care of, yet... I have no proof. Usually, dead men leave a lot of proof. Especially ones hastily slain before their time.%SPEECH_OFF%He shrugs.%SPEECH_ON%I\'ll pay you half. And you\'ll take that and then leave. Next time, bring proof. If you\'re lying... well, I\'ll figure that out on my own.%SPEECH_OFF% | You Retournez à find %employer% tending to his garden.%SPEECH_ON%Sometimes I plant for one vegetable, and yet what springs forth but another entirely? How does that happen? Did I fool myself? Are you trying to fool me? You say the graverobbers are dead, but my men have scouted the graveyard and have found no such evidence. They also haven\'t found the graverobbers, and please...%SPEECH_OFF%He holds up a hand.%SPEECH_ON%Don\'t try and tell me that you did this or that with their bodies. So this is what we\'re going to do, sellsword. I\'m going to pay you half and then I\'m going to sit here and wonder if you lied to me. Sound good? Good.%SPEECH_OFF% | %employer% smiles as you tell him his problem has been taken care of.%SPEECH_ON%That\'s good news. Unfortunately, my men scouted the cemetery and found no evidence of our dead graverobbers. An interesting development, I\'m sure, but I\'m not going to hold you here while I figure out what, exactly, happened there. So... I\'ll be paying you half. Next time, bring me proof. Or... don\'t lie. I\'m not sure which applies to you here.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Hrm.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						this.World.Assets.addMoralReputation(-1);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() / 2 + "[/color] Couronnes"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"treasure_location",
			this.m.TreasureLocation == null || this.m.TreasureLocation.isNull() ? "" : this.m.TreasureLocation.getName()
		]);
		_vars.push([
			"treasure_direction",
			this.m.TreasureLocation == null || this.m.TreasureLocation.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.TreasureLocation.getTile())]
		]);
		_vars.push([
			"necromancer_location",
			this.m.Flags.get("DestinationName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/terrified_villagers_situation"));
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
				local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
				this.World.FactionManager.getFaction(this.m.Destination.getFaction()).removeSettlement(this.m.Destination);
				this.m.Destination.setFaction(zombies.getID());
				zombies.addSettlement(this.m.Destination.get(), false);
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
			if (this.m.Destination == null || this.m.Destination.isNull())
			{
				return false;
			}

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

