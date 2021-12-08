this.drive_away_nomads_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_nomads";
		this.m.Name = "Repoussez les Nomades";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Repoussez les nomades à  " + this.Flags.get("DestinationName") + " %direction% de %origin%"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.Contract.m.Destination.resetDefenderSpawnDay();
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 700)
					{
						this.Flags.set("IsSandGolems", true);
					}
				}
				else if (r <= 25)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 300)
					{
						this.Flags.set("IsTreasure", true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 150 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 35)
				{
					if (this.World.Assets.getBusinessReputation() > 800)
					{
						this.Flags.set("IsAssassins", true);
					}
				}
				else if (r <= 45)
				{
					if (this.World.getTime().Days >= 3)
					{
						this.Flags.set("IsNecromancer", true);
						this.Contract.m.Destination.clearTroops();
						local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
						this.Contract.m.Destination.setFaction(zombies.getID());
						zombies.addSettlement(this.Contract.m.Destination.get(), false);
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NecromancerSouthern, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsFriendlyNomads", true);
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

					if (this.Flags.get("IsNecromancer"))
					{
						this.Contract.m.Destination.m.IsShowingDefenders = false;
					}
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsTreasure"))
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.setScreen("Treasure2");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsSandGolems"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SandGolems");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.SandGolem.Cost);

						for( local i = 0; i < e; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.SandGolem,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/enemies/sand_golem",
								Faction = this.Const.Faction.Enemy
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsTreasure") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Treasure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNecromancer") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Necromancer");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssassins"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Assassins");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.Assassin.Cost);

						for( local i = 0; i < e; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.Assassin,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/assassin",
								Faction = this.Contract.m.Destination.getFaction()
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
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
			Text = "[img]gfx/ui/events/event_163.png[/img]{Il n\'y a pas de trompettes, pas de confettis, pas d\'acclamations, mais il y a quand même une certain cérémonie quand vous entrez dans le bureau de %employer%. Le bureau est tellement décorée d\'or et d\'argent, de bijoux complexes fabriqués par de véritables artisans, et d\'un harem composé uniquement des femmes les plus séduisantes, que n\'importe qui ne pourrait s\'empêcher de faire tout ce que l\'on demande, ne serait-ce que pour avoir la chance de participer à ces festivités apparemment quotidiennes. %employer% est assis sur une pile de coussins.%SPEECH_ON%Ah, Mercenaire. Je vous attendais. S\'il vous plaît, n\'approchez pas, vous allez effrayer mes invités. J\'ai une tâche simple pour vous. Des nomades ont pillé mes caravanes, et voilà que je me retrouve avec moins de pièces dans mes coffres. Je suis sûr que vous comprenez ce que c\'est que d\'être privé de quelque chose qui vous appartient, n\'est-ce pas? Ah, vous semblez si stupide. Si ignorant. Tellement, hum... impliqué dans ce que vous faites. Je veux que ces nomades soient tués, et je suis prêt à payer %reward% couronnes pour que ce soit fait. Ce langage plaît-il à ce qui réside entre vos oreilles ?%SPEECH_OFF% | %employer% est en partie assis sur un trône de coussins de soie, et en partie sur les corps d\'un harem de femmes séduisantes. Il lève la main.%SPEECH_ON%Si vous faites un pas de plus, Mercenaire, ce que vous verrez s\'aggrandira mais votre vision d\'ensemble diminuera, compris ? Un homme intelligent sait où est sa place. J\'ai une tâche simple pour votre main armée. Des nomades en dehors de %townname% ont pris goût au vol et à la violence. En échange d\'une bonne poignée de couronnes, j\'ai besoin que vous annihiliez ces hommes qui ont rendu ma vie inconfortable.%SPEECH_OFF% | Vous trouvez %employer% en train de nourrir un oiseau dans une cage. L\'oiseau est un mélange de couleurs et vous n\'êtes pas sûr d\'avoir déjà vu certaines. Suspectant votre présence, ou peut-être la sentant, %employer% se retourne avec un soupçon de dégoût.%SPEECH_ON%Vous effrayez mon oiseau, mercenaire, alors je vais être bref pour son bien. Il y a des nomades qui errent à la périphérie de mes terres et je dois les détruire. Je suis sûr qu\'un homme de votre, euh, rang, serait prêt à entreprendre une tâche aussi simple et facile ?%SPEECH_OFF% | Vous entrez dans le bureau de %employer%. Il se nourrit de fruits et sa moitié inférieure est immergée dans une mer de chair, un harem de soignants qui s\'affairent bruyamment. Resté inactif depuis bien trop longtemps, vous ouvrez la bouche mais l\'homme lève une main. Il désigne l\'un de ses serviteurs et claque des doigts. Le serviteur traverse le bureau sur des sandales à la semelle de soie. Il vous présente un morceau de papier. On y lit :%SPEECH_ON%Pour les mercenaires intéressés, des nomades ont commencé à troubler la paix dans la ville de %townname%. Ils doivent être éliminés en toute hâte pour une récompense de %reward% couronnes. Les personnes non intéressées doivent partir immédiatement.%SPEECH_OFF%Le serviteur vous regarde pour obtenir une réponse. | %employer% soupire en entrant dans sa chambre.%SPEECH_ON%Ah, un mercenaire, j\'avais presque oublié que j\'avais demandé à votre espèce de venir gâcher ma journée.%SPEECH_OFF%Vous fixez le Vizir qui est bien trop fatigué pour s\'extraire d\'une mer de coussins et du harem de femmes qui sont là pour les complémenter.%SPEECH_ON%Eh bien, je suppose que je vais gâcher une heure, ne serait-ce que pour régler cette affaire. Les nomades ravagent mes caravanes, comme ils ont l\'habitude de le faire, et voilà que mes marchés sont privés de certaines marchandises que je souhaite avoir. J\'offre %reward% couronnes pour trouver et détruire ces acariens du sable.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons un peu du paiement. | Je peux faire disparaître ce problème.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Nous avons d\'autres importants problèmes à régler. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
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
			ID = "Treasure1",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Les nomades sont étonnamment immobiles et étonnamment nombreux, mais il semble qu\'il y ait une raison à cela : vous trouvez les habitants du sable regroupés autour d\'un trou dans le sol. Ils ont construit des poulies autour et travaillent fébrilement pour remonter ce qu\'ils ont trouvé dans le désert. D\'après le sourire de l\'homme qui supervise l\'opération, il s\'agit sans aucun doute d\'un trésor. Vous pouvez attaquer maintenant, et faire face à plus d\'opposition, ou vous pouvez attendre qu\'ils aient fini et qu\'ils soient partis avec ce qu\'ils ont déterré.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On attaque maintenant !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Nous attendrons qu\'ils aient fini et que le camp soit moins bien défendu.",
					function getResult()
					{
						return "Treasure1A";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure1A",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Vous attendez que les nomades sortent le trésor. Comme prévu, c\'est un coffre. Lorsqu\'ils l\'ouvrent, un soupçon de satisfaction se lit sur leur visage. Et, comme prévu, les nomades se séparent, avec un contingent de leurs hommes les plus forts qui partent avec le trésor, sans doute pour le vendre quelque part. Le camp des nomades est maintenant plus faible et beaucoup plus vulnérable aux attaques...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à l\'attaque !",
					function getResult()
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Les nomades tués, vous allez voir ce qu\'ils creusaient dans la terre. Vous vous tenez au-dessus de la poulie qu\'ils ont installée et regardez fixement dans le trou. On peut voir un coffre avec des cordes déjà attachées autour. Vous remerciez les nomades morts pour tout le travail qu\'ils ont fait, puis vous vous retournez pour tirer facilement le coffre vers le haut et hors du sol. Vous l\'ouvrez pour trouver...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Trésor !",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local e = 2;

				for( local i = 0; i < e; i = ++i )
				{
					local item;
					local r = this.Math.rand(1, 4);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/loot/ancient_gold_coins_item");
						break;

					case 2:
						item = this.new("scripts/items/loot/silverware_item");
						break;

					case 3:
						item = this.new("scripts/items/loot/jade_broche_item");
						break;

					case 4:
						item = this.new("scripts/items/loot/white_pearls_item");
						break;
					}

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
			ID = "SandGolems",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{Alors que vous vous préparez à attaquer, un homme surgit soudain du sabls. Surpris, il s\'éloigne en hurlant et dévale la dune en direction du camp des nomades. Vous le poursuivez, arme au poing, prêt à tuer. Dans votre périphérie, vous pouvez voir les nomades grimper les uns sur les autres et renverser les tentes pour atteindre leurs armes. Lorsque vous vous retournez vers le guetteur, il a disparu soudainement dans un amas de sable, et un bras de sable sort de la dune et s\'élève devant vous, la poussière, le sable et la terre renforce ses formes.\n\nVous êtes à peine capable de comprendre ce que vous voyez, mais les nomades semblent tous crier la même chose : \"Ifrit ! Ifrit ! Ifrit!\" Et cet \"Ifrit\" sans visage, n\'a aucune allégeance dans le combat à venir. | Vous foncez sur les nomades à travers les dunes. Surpris, ils aboient des ordres et courent chercher leurs armes. Alors que vous approchez du camp, une vague de sable souffle sur le coin du camp et quelques nomades volent. Une seconde plus tard, un rocher surgit du nuage de poussière et pulvérise entièrement un nomade. Une énorme créature terrestre s\'avance en mugissant et en trépignant. \"Ifrit ! Ifrit!\'\', crient les nomades, et vous supposez que cet \"Ifrit\" ne sera du côté d\'aucun homme.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Assassins",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_165.png[/img]{Vous pénétrez dans le camp juste à temps pour voir un homme en noir sortir de l\'une des tentes. Il serre la main du chef des nomades, ce qui n\'est probablement pas le meilleur signe. Les deux hommes s\'arrêtent au milieu de la poignée de main et regardent fixement votre attaque, ce qui est probablement aussi mauvais signe. Le chef nomade crie, exigeant que les assassins méritent leur salaire. Le tueur au visage noirci acquiesce et sort une lame, et une troupe d\'autres assassins sortent de la tente à leur tour pour rejoindre les nomades dans la bataille !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Des tentes déchiquetées. Des paniers défaits. Des vêtements qui roulent sur le sable. Et au milieu de tout cela est assis un homme dans un manteau noir, son visage effroyable regardant à travers son capuchon.%SPEECH_ON%Vous êtes à la fois en retard et à l\'heure.%SPEECH_OFF%Il dit et se lève. Les toiles frémissent, les paniers basculent, les vêtements s\'écartent, la terre s\'anime. Soudain, le sable glisse dans des canaux caverneux et des nomades inamicaux sortent du sol, certains bondissent comme pour se revivifier à l\'air frais, d\'autres se redressent du talon à la pointe du pied, le corps droit comme un mât de drapeau. Ils se déplacent de façon troublante, guindés et inclinés, et l\'homme en noir sourit derrière leur formation ambulante. Ce n\'est pas un blagueur ordinaire, mais un nécromancien !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux Armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Un serviteur vous empêche de rencontrer %employer%. Il vous remet un parchemin ainsi qu\'une sacoche. Bien qu\'il vous ait déjà remis le papier, le serviteur met ses mains derrière son dos et regarde le plafond en récitant.%SPEECH_ON%Le mercenaire est récompensé de %reward_completion% couronnes conformément aux arrangements préalables. Après avoir reçu sa récompense, il est renvoyé de la propriété en toute hâte.%SPEECH_OFF%Le serviteur vous regarde et hoche la tête.%SPEECH_ON%Partez.%SPEECH_OFF%Dit-il. | Vous essayez d\'entrer dans la chambre de %employer% mais un grand garde balafré abaisse le bout de son arme de poing pour bloquer l\'accès à la porte.%SPEECH_ON%Aucun visiteur.%SPEECH_OFF%Vous déclarez que vous avez affaire avec le Vizir. Le garde secoue la tête. Un serviteur arrive derrière vous et vous met une sacoche dans les bras, puis repart tout aussi vite. Le garde remet son arme à sa place d\'origine.%SPEECH_ON%Vos futilités avec le vizir ont pris fin lorsque vous avez quitté sa présence. Vous ne devez plus empoisonner son humeur. Partez. Maintenant. Avant d\'empoisonner la mienne.%SPEECH_OFF% | En vous approchant du bureau de %employer%, une femme applaudit depuis l\'autre côté du hall. Vous regardez et elle est déjà bien trop proche. Quatre oiseaux sont perchés sur ses épaules et ils se balancent à chacun de ses pas.%SPEECH_ON%Mercenaire.%SPEECH_OFF%Elle sort une sacoche et la tend.%SPEECH_ON%%employer% n\'a pas besoin de vous sentir encore une fois, être rentré aussi loin dans sa maison est déjà suffisant. Comptez si vous voulez nous insulter, partez si vous voulez nous faire plaisir.%SPEECH_OFF%Elle tourne sur ses talons et s\'éloigne, sa robe d\'un autre univers flottant d\'un côté à l\'autre. L\'un des oiseaux tourne sur son épaule et vous regarde en gloussant.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Eh bien, nous avons été payés.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Détruire un campement de nomades");
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
			"totalenemy",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.beautifyNumber(this.m.Destination.getTroops().len()) : 0
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0 && this.World.getTime().Days > 3 && this.Math.rand(1, 100) <= 50)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
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

				if (this.m.Flags.get("IsNecromancer"))
				{
					local nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits);
					this.World.FactionManager.getFaction(this.m.Destination.getFaction()).removeSettlement(this.m.Destination);
					this.m.Destination.setFaction(nomads.getID());
					nomads.addSettlement(this.m.Destination.get(), false);
				}
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
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

