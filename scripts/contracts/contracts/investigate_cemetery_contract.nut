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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez voir %employer% avec la tête du nécromancien en main. Elle est incroyablement légère pour une tête humaine.%SPEECH_ON%Est-ce l'immonde créature qui a transformé nos morts en morts-vivants ?%SPEECH_OFF%En hochant la tête, vous la posez. Le visage halète et %employer% s'éloigne d'un bond.%SPEECH_ON%Il est toujours en vie !%SPEECH_OFF%Vous haussez les épaules et enfoncez une dague dans le crâne. Les yeux du nécromancien se tournent vers la lame et éclate de rire, puis ses yeux se rétractent dans leurs orbites et un léger filet de fumée rouge s'échappe, puis il n'y a plus rien. %employer%, tremblant, se rassoit et fait signe vers une sacoche dans un coin de la pièce. C'est votre paiement et il est assez important. | %employer% est assis lorsque vous entrez dans son bureau, mais il se lève immédiatement et recule à la vue de la tête du nécromancien qui pend de votre main.%SPEECH_ON%Je... je suppose que... c'est lui ? C'est ça ? C'est lui ? C'est fini ?%SPEECH_OFF%Vous acquiescez et jetez la tête sur le bureau de votre employeur. Elle tourne jusqu'à ce que le visage regarde le plafond, puis continue de vaciller de droite à gauche sur les joues tout cela pendant que le visage affiche un sourire de mort. %employer% la repousse avec un livre.%SPEECH_ON%Bien. Excellent ! Comme promis, votre salaire...%SPEECH_OFF%Il fait un geste vers un coin où repose une {boîte en bois | grande sacoche}. Vous la prenez, comptez les couronnes et partez. | %employer% lève les yeux de son livre.%SPEECH_ON%Par les dieux, est-ce la tête du nécromancien dans votre main ?%SPEECH_OFF%Vous acquiescez et la jetez par terre. Un chat se détache de son perchoir et descend pour la tripoter. %employer% se lève et prend quelques livres de l'étagère, révélant une grande boîte. Il la prend et vous la donne.%SPEECH_ON%J'avais économisé ça pour les moments spéciaux et je suppose que c'en est un.%SPEECH_OFF%Vous pensez qu'il s'agit d'un objet, peut-être une amulette ou quelque chose de mystérieux, mais au lieu de cela, c'est juste un bon tas de couronnes. | De retour chez %employer%, vous avez la tête du nécromancien en main et l'homme vous fait rapidement signe de la lui remettre. Vous n'avez aucun scrupule à le faire...\n\n%employer% la soulève à deux mains, l'étudiant comme le ferait un homme avec un bébé malade. Après quelques instants, il pose la tête dans la tête d'un trident brisé.%SPEECH_ON%Je pense que ça rend bien là. Oui ça rend bien, n'est-ce pas ?%SPEECH_OFF%L'homme pose un pouce sur le menton pâle du nécromancien. Vous vous raclez la gorge et demandez à être payé, ce à quoi %employer% fait signe à l'un de ses gardes d'entrer. On vous apporte une sacoche dans laquelle vous comptez %reward_completion% couronnes. Satisfait, vous laissez %employer% à... ce qu'il est en train de faire.}",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% se tient à la fenêtre quand vous entrez.%SPEECH_ON%Les oiseaux chanteurs semblaient plutôt en colère aujourd'hui. Comme si rien de ce qu'ils disaient ne valait la peine d'être dit. J'ai trouvé ça intéressant. Et vous ?%SPEECH_OFF%Il se tourne soudainement vers vous.%SPEECH_ON%Hmm, mercenaire ? Non ? Mes petits oiseaux m'ont dit que les pilleurs de tombes ont quitté la ville. Vivants. Libres d'aller où ils veulent, libres de revenir quand ils veulent. Quelle bizarrerie, car d'habitude les morts ne sont pas libres de faire quoi que ce soit. Que vous ai-je demandé de faire de ces pilleurs de tombe?%SPEECH_OFF%Vous hésitez. L'homme répond à votre place.%SPEECH_ON%Je voulais que vous les tuiez. Mais ils ne le sont pas. Et maintenant vous n'êtes pas payé. Ah, comme c'est simple. Et maintenant ? Maintenant, vous sortez de chez moi.%SPEECH_OFF% | %employer% rit quand vous entrez dans son bureau.%SPEECH_ON%Je suis honnêtement surpris que vous soyez revenu. Je trouve ça insultant, vraiment, que vous pensiez que je ne saurais pas ce qu'il s'est passé. Les pilleurs de tombes ont été repérés sur la route. Les pilleurs de tombes que je vous ai demandé de tuer. Vous vous souvenez de ça ? Vous vous souvenez que je vous ai dit d'aller les tuer ? Je suis sûr que oui. Je suis aussi sûr que vous vous rappelez quand j'ai dit que c'était pour ça que je vous payais. Donc... pas de profanateurs morts...%SPEECH_OFF%Il frappe son bureau du poing.%SPEECH_ON%Pas de paiement ! Maintenant, sortez de chez moi !%SPEECH_OFF% | Vous trouvez %employer% dans son fauteuil, faisant tourner un gobelet vide entre ses mains.%SPEECH_ON%Ce n'est pas souvent que je tombe sur quelqu'un qui essaie de me rouler. C'est ce que vous alliez faire en revenant ici, non ? Je sais que les pilleurs de tombes ne sont pas morts, mercenaire. Je ne suis pas un imbécile. Hors de ma vue avant que mes hommes ne te massacrent.%SPEECH_OFF% | %employer% est en train de lire un livre quand vous entrez dans son bureau.%SPEECH_ON%Vous avez dix secondes pour vous retourner et partir. Dix. Neuf. Huit...%SPEECH_OFF%Vous réalisez qu'il sait que les pilleurs de tombes n'ont pas été tués.%SPEECH_ON%...quatre... trois...%SPEECH_OFF%Vous vous retournez et quittez précipitamment la pièce.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Merde !",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% se pince les lèvres.%SPEECH_ON%Vous m'avez mis dans une situation étrange, mercenaire. Vous me dites que vous vous êtes coccupé des pilleurs de tombes, et pourtant... Je n'ai aucune preuve. Habituellement, les hommes morts laissent beaucoup de preuves. Surtout ceux tués à la hâte avant leur heure.%SPEECH_OFF%Il hausse les épaules.%SPEECH_ON%Je vous paierai la moitié. Et vous prendrez ça et vous partirez. La prochaine fois, apportez des preuves. Si vous mentez... eh bien, je le découvrirai par moi-même.%SPEECH_OFF% | Vous retournez voir %employer% en train de s'occuper de son jardin.%SPEECH_ON%Parfois, je plante un légume, et pourtant, qu'est-ce qui pousse, sinon un tout autre ? Comment cela se fait-il ? Me suis-je trompé moi-même ? Essayez-vous de me tromper ? Vous dites que les pilleurs de tombes sont morts, mais mes hommes ont fouillé le cimetière et n'ont trouvé aucune preuve. Ils n'ont pas non plus trouvé les pilleurs de tombes, et s'il vous plaît...%SPEECH_OFF%Il lève la main.%SPEECH_ON%N'essayez pas de me dire que vous avez fait ceci ou cela avec leurs corps. Alors voilà ce qu'on va faire, mercenaire. Je vais vous payer la moitié et ensuite je vais m'asseoir ici et me demander si vous m'avez menti. Ça vous convient ? Bien.%SPEECH_OFF% | %employer% sourit lorsque vous lui dites que son problème a été réglé.%SPEECH_ON%Ce sont de bonnes nouvelles. Malheureusement, mes hommes ont fouillé le cimetière et n'ont trouvé aucune trace de nos pilleurs de tombes. Un développement intéressant, j'en suis sûr, mais je ne vais pas vous retenir ici pendant que je découvre ce qui s'est passé exactement là-bas. Donc... je vais vous payer la moitié. La prochaine fois, apportez-moi une preuve. Ou... ne mentez pas. Je ne suis pas sûr de ce qui s'applique à vous ici.%SPEECH_OFF%}",
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

