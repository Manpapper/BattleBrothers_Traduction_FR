this.drive_away_bandits_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_bandits";
		this.m.Name = "Repoussez les Brigands";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function generateName()
	{
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];
		return this.buildTextFromTemplate(this.Const.Strings.BanditLeaderNames[this.Math.rand(0, this.Const.Strings.BanditLeaderNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("RobberBaronName", this.generateName());
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
					"Repoussez les bandits à " + this.Flags.get("DestinationName") + " %direction% de %origin%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 0.95 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsRobberBaronPresent", true);

					if (this.World.Assets.getBusinessReputation() > 600 && this.Math.rand(1, 100) <= 50)
					{
						this.Flags.set("IsBountyHunterPresent", true);
					}
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
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("RobberBaronDead");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10)
					{
						this.Contract.setScreen("Survivors1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsRobberBaronPresent"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AttackRobberBaron");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BanditTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.BanditLeader,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/bandit_leader",
							Faction = _dest.getFaction(),
							Callback = this.onRobberBaronPlaced.bindenv(this)
						});
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onRobberBaronPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsRobberBaron", true);
				_entity.setName(this.Flags.get("RobberBaronName"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsRobberBaron") == true)
				{
					this.Flags.set("IsRobberBaronDead", true);
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
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsRobberBaronDead") && this.Flags.get("IsBountyHunterPresent") && !this.TempFlags.get("IsBountyHunterTriggered") && this.World.Events.getLastBattleTime() + 7.0 < this.Time.getVirtualTimeF() && this.Math.rand(1, 1000) <= 2)
				{
					this.Contract.setScreen("BountyHunters1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBountyHunterRetreat"))
				{
					this.Contract.setScreen("BountyHunters3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
					this.Flags.set("IsBountyHunterRetreat", true);
					this.Flags.set("IsRobberBaronDead", false);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% secoue rageusement la tête.%SPEECH_ON%Les brigands ont ravagé ces régions depuis bien trop longtemps ! J\'ai envoyé un garçon, le fils de %randomname%, pour les trouver. Et vous savez quoi ? Seule sa tête est revenue. Bien sûr, ces idiots de brigands ont envoyé l\'un des leurs pour la livrer. Nous l\'avons capturé et interrogé... donc maintenant nous savons où ils sont.%SPEECH_OFF%L\'homme se penche en arrière, en déplaçant ses pouces l\'un sur l\'autre pour réfléchir.%SPEECH_ON%Je n\'ai pas les hommes, mais j\'ai les couronnes - et si j\'en glissais quelques-unes vers vous, et vous glissiez une épée vers eux ?%SPEECH_OFF% | %employer% se sert un verre, fixe la tasse et s\'en sert encore. Il semble la vider d\'un trait avant de cracher ses nouvelles.%SPEECH_ON%Les brigands ont tué %randomname% et toute sa famille. Vous pouvez croire ça ? Je sais que vous ne savez pas qui ils étaient, mais c\'était une famille très appréciée dans le coin. Je suis sûr que vous pouvez déjà imaginer, mais je veux en finir avec ces brigands. J\'ai perdu la moitié de mes hommes à trouver leur camp, maintenant je suis prêt à perdre une partie de mes couronnes pour que vous alliez les tuer. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% regarde par la fenêtre et fait glisser un doigt sur le bord d\'un verre en réfléchissant.%SPEECH_ON%Des brigands sont partis avec du précieux bétail. Ils viennent la nuit, les brigands je veux dire, et coupent les cloches pour partir tranquillement. Je suis sûr que le bétail n\'est pas important pour vous, mais un veau, une vache, un taureau ? C\'est une fortune pour certaines personnes dans ces régions.\n\nL\'autre jour, j\'ai demandé à un garçon de suivre les traces d\'animaux en dehors de la ville et maintenant il me dit exactement où se trouvent ces brigands. Comme vous pouvez le deviner, je n\'ai pas assez d\'hommes pour affronter ces vagabonds, mais les couronnes... je ne suis pas à court de couronnes. Si je devais arroser vos paumes de couronnes, seriez-vous prêt à arroser ces brigands d\'acier ?%SPEECH_OFF% | %employer% soupire comme s\'il était fatigué de tous ces ennuis, comme s\'il était sur le point d\'entamer une conversation qu\'il a déjà eu de nombreuses fois auparavant.%SPEECH_ON%%randomname%, un homme d\'importance ici, déclare que des brigands se sont attaqués à ses filles. Il s\'inquiète maintenant de ce qu\'ils feront la prochaine fois. Heureusement, cet homme est assez riche et a pu facilement retrouver ces brigands. Si je vous payais une somme décente, pourriez-vous enfoncer l\'une de vos épées dans un ou deux brigands ?%SPEECH_OFF% | %employer% prend place dans un fauteuil assez grand pour être confortable pour deux. Il agite une tasse dans tous les sens.%SPEECH_ON%Les brigands nous harcèlent depuis des semaines et hier encore, ils ont essayé de mettre le feu à un pub. Vous pouvez croire ça ? Qui met le feu à une telle chose ? Heureusement, nous l\'avons éteint juste à temps, mais les choses vont mal par ici. S\'ils menacent notre précieuse boisson, que feront-ils ensuite ? Heureusement, nous avons réussi à trouver où ces vagabonds se cachent. Alors... oui, je vois votre regard. C\'est une tâche simple, mercenaire : nous voulons que vous alliez tuer tous les brigands jusqu\'au dernier. Êtes-vous prêt à travailler pour nous ?%SPEECH_OFF% | Alors que vous vous installez dans la pièce, %employer% termine un gobelet de vin et jette la coupe par la fenêtre. Vous entendez le bruit que le gobelet fait en s\'entrechoquant au loin, très loin. Il se tourne vers vous.%SPEECH_ON%Alors que je marchais sur les routes, des brigands ont attaqué mon chariot et se sont emparés de tous mes biens ! Ils m\'ont laissé la vie sauve, ce qui est bien, mais le culot de ce qu\'ils ont fait m\'empêche de dormir la nuit. Je vois leurs visages narquois... j\'entends leurs rires... Je crois que c\'était un message, pour me poursuivre, parce que j\'ai refusé de payer leur \"péage\". Eh bien, maintenant je suis prêt à payer un péage - à vous, mercenaire. Si vous allez massacrer ces vagabonds, je paierai un bon prix. Qu\'en dites-vous ?%SPEECH_OFF% | Alors que vous vous apprêtez à vous asseoir, %employer% vous lance un parchemin. Il se déplie au moment où vous l\'attrapez. Vous commencez à lire, mais %employer% commence quand même à vous donner des informations.%SPEECH_ON%Les commerçants de %randomtown% ont tous accepté de ne plus fréquenter %townname% tant que notre petit problème de brigands ne sera pas réglé. L\'histoire est assez simple, car je suis sûr que vous connaissez les méthodes des brigands, mais ces satanés vagabonds ont harcelé les routes, pillé les caravanes et tué les marchands.\n\nJe sais exactement où ils sont, j\'ai juste besoin d\'un homme de cran et en manque de gloire - ou d\'or ! - pour aller les tuer. Alors qu\'en dites-vous, mercenaire ? Donnez-moi un prix et nous pourrons discuter.%SPEECH_OFF% | %employer% tremble quand vous le saluez. Il écume pratiquement de colère - ou peut-être qu\'il est juste vraiment ivre.%SPEECH_ON%Les citoyens de cette belle ville sont affamés. Pourquoi ? Parce que des brigands se faufilent pendant la nuit pour piller les greniers ! Et si on les attrape, ils brûlent les bâtiments ! Maintenant, nous ne pouvons pas nous défendre en restant assis... Maintenant... Je veux me défendre en les tuant tous.%SPEECH_OFF%L\'homme vacille un instant, comme s\'il était sur le point de se renverser sur son bureau. Il se stabilise avant de poursuivre.%SPEECH_ON%Je veux que vous alliez tuer ces vagabonds, évidemment. Tout ce que vous avez à faire est d\'être intéressé et... -Hic-... dire votre prix.%SPEECH_OFF% | %employer% regarde solennellement le sol. Il déploie un parchemin, vous montrant un visage.%SPEECH_ON%Voici %randomname%, un brigand en liberté que nous avons capturé l\'autre jour. Il était à la tête d\'une bande de vagabonds qui harcelaient et pillaient notre ville nuit et jour . Le problème est qu\'il n\'est pas vraiment la tête du serpent, mais la tête d\'une hydre. Tuez une tête criminelle, une autre prend sa place. Alors quelle est la réponse ? Eh bien, les tuer tous, bien sûr. Et c\'est exactement ce que je veux que vous fassiez, mercenaire. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% se tourne vers vous alors que vous cherchez un endroit où vous asseoir.%SPEECH_ON%Bonjour, mercenaire, depuis combien de temps n\'avez-vous pas trempé votre épée dans le sang d\'hommes mauvais et cruels ?%SPEECH_OFF%Il laisse tomber le sarcasme et vous vous dites que vous resterez debout.%SPEECH_ON%Ici, à %townname%, nous avons un petit problème avec des brigands locaux. Pour nous, c\'est-à-dire avec leur petit trou à rat pas loin d\'ici. Évidemment, je pense que la solution à ce problème est d\'engager des hommes finement armés comme votre petite compagnie de bons hommes. Alors, cela vous intéresse-t-il, mercenaire, ou dois-je trouver des hommes plus robustes pour cette tâche ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{De combien de Couronnes parle-t-on? | Combien est prêt à payer %townname% pour leur sécurité? | Parlons argent.}",
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
			ID = "AttackRobberBaron",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{En espionnant le campement de brigands, vous remarquez le profil d\'un homme que les habitants du coin décrivent presque avec ferveur : il s\'agit de %robberbaron%, un célèbre baron voleur qui terrorise ces régions. Il a une escorte d\'hommes à l\'air brutal qui le suivent partout où il va.\n\nVous misez sur le fait que sa tête vaut quelques couronnes supplémentaires. | Vous n\'aviez pas prévu de le voir, mais il ne fait aucun doute que c\'est l\'homme en chair et en os : %robberbaron% est au campement des brigands. Le célèbre tueur est apparemment en train de rendre visite à l\'une de ses filiales criminelles, marchant prudemment au milieu des voleurs, pointant du doigt ceci ou cela, faisant des remarques sur la qualité de ceci et de cela.\n\nQuelques gardes du corps le suivent partout. Vous estimez qu\'entre lui et le reste des brigands, il y a environ %totalenemy% hommes qui se baladent. | Le contrat ne prévoyait que l\'élimination des brigands, mais il semblerait qu\'un gros bonnet, soit de la partie : %robberbaron%, le tristement célèbre tueur et pilleur de grand chemin, est au camp. Suivi d\'un garde du corps, le baron voleur semble évaluer une de ses affaires criminelles.\n\nVous vous demandez combien coûterait la tête de %robberbaron% en couronnes... | %robberbaron%. C\'est lui, vous le savez. En regardant à travers une lorgnette, vous pouvez facilement voir la silhouette de l\'infâme baron voleur alors qu\'il se déplace dans le campement des brigands. Il n\'était pas dans vos plans, ni mentionné dans le contrat, mais il y a peu de doute que si vous ramenez sa tête en ville, vous obtiendrez un petit extra pour votre peine. | Alors que vous espionnez les brigands - vous comptez environ %totalenemy% d\'hommes en mouvement - vous apercevez une silhouette à laquelle vous ne vous attendiez pas du tout : %robberbaron%, le tristement célèbre baron voleur. L\'homme et son garde du corps doivent être en train d\'inspecter l\'état du camp.\n\nQuelle chance ! Si vous pouviez rapporter sa tête à votre employeur, vous pourriez gagner un petit bonus.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à l\'attaque !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RobberBaronDead",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{La bataille achevée, vous vous dirigez vers le corps de %robberbaron% et retirez sa tête avec deux coups rapides de votre épée, le premier coup coup coupant la viande, le second l\'os. Vous enfoncez un crochet dans la chair du cou et tirez une corde de manière à l\'attacher à votre hanche. | Le combat terminé, vous cherchez et trouvez rapidement le cadavre de %robberbaron% parmi les morts. Il a toujours l\'air méchant même si la couleur a quitté son corps. Il a l\'air toujours aggressif même après avoir retirer ça tête de son corps et bien que vous ne puissiez plus voir son visage lorsque vous jetez sa tête dans un sac en toile, vous supposez qu\'il a l\'air toujours aggressif. | %robberbaron% gît mort à vos pieds. Vous retournez le corps et tendez le cou, donnant à votre épée un meilleur angle de frappe. Il vous faut deux bons coups pour retirer la tête que vous mettez rapidement dans un sac. | Maintenant qu\'il est mort, %robberbaron% vous rappelle soudain beaucoup d\'hommes que vous avez connus. Vous ne vous contentez pas longtemps de ce sentiment de déjà vu : en quelques coups d\'épée rapides, vous enlevez la tête de l\'homme avant de la jeter dans un sac. | %robberbaron% s\'est bien battu et son cou en a fait autant, les tendons et les os ne laissant pas sa tête partir facilement alors que vous collectez votre prime. | Vous avez récupéré la tête de %robberbaron%. %randombrother% la montre du doigt alors que vous passez devant lui.%SPEECH_ON%Qu\'est-ce que c\'est ? Est-ce que c\'est %robberbaron%... ?%SPEECH_OFF%Vous secouez la tête.%SPEECH_ON%Non, cet homme est mort. Ça, c\'est juste un complément de salaire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On bouge !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Sur le chemin du retour pour récupérer votre paie, quelques hommes s\'avancent sur la route. L\'un d\'eux pointe du doigt la tête de %robberbaron%. %SPEECH_ON%Nous sommes les chasseurs de primes les mieux payés de la région et je crois que vous nous volez une partie de nos affaires. Donnez-nous cette tête et tout le monde pourra dormir dans son lit ce soir.%SPEECH_OFF%Vous riez.%SPEECH_ON%Vous devrez proposer mieux que ça. La tête de %robberbaron% vaut beaucoup de couronnes, mon ami.%SPEECH_OFF%Le chef de ces supposés chasseurs de primes vous répond en riant. Il soulève un sac rempli et lourd.%SPEECH_ON%Voici %randomname%, l\'un des types les plus recherchés dans le coin. Et là...%SPEECH_OFF%Il montre un autre sac.%SPEECH_ON%C\'est la tête de l\'homme qui l\'a tué. Vous comprenez ? Alors remettez nous la tête pour la prime et nous pourrons tous partir.%SPEECH_OFF% | Un homme s\'avance sur la route, se redresse et se dirige vers vous.%SPEECH_ON%Bonjour, messieurs. Je crois que vous avez la tête de %robberbaron%.%SPEECH_OFF%Vous acquiescez. L\'homme sourit.%SPEECH_ON%Auriez-vous l\'amabilité de me la remettre ?%SPEECH_OFF%Vous riez et secouez la tête. L\'homme ne sourit pas, il lève une main et claque des doigts. Une foule d\'hommes bien armés sortent des buissons voisins et s\'avancent sur la route au son d\'un bruit de métal lourd. Ils ressemblent à ce à quoi un condamné à mort pourrait rêver la nuit précédant son jugement. Leur chef affiche un sourire en coin.%SPEECH_ON%Je ne vais pas vous le redemander.%SPEECH_OFF% | Alors que vous parlez à %randombrother%, un cri fort attire votre attention. Vous regardez la route pour voir une foule d\'hommes se tenant sur votre chemin. Ils ont toutes sortes d\'armes et d\'armures. Leur chef de file s\'avance, annonçant qu\'ils sont de célèbres chasseurs de primes.%SPEECH_ON%Nous souhaitons seulement avoir la tête de %robberbaron%.%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%On a tué l\'homme, on garde sa tête. Maintenant, dégagez de notre chemin.%SPEECH_OFF%Quand vous faites un pas en avant, les chasseurs de primes lèvent leurs armes. Leur chef fait un pas vers vous.%SPEECH_ON%Il y a un choix à faire ici qui pourrait faire tuer beaucoup d\'hommes bons. Je sais que ce n\'est pas facile, mais je vous suggère d\'y réfléchir très sérieusement.%SPEECH_OFF% | Un sifflement aigu attire votre attention et celle de vos hommes. Vous vous tournez sur le côté de la route pour voir un groupe d\'hommes sortir de quelques buissons. Tout le monde sort son arme, mais les inconnus ne bougent pas d\'un pas. Leur meneur s\'avance. Il a une bandoulière avec des oreilles autour de sa poitrine un résumé de son travail.%SPEECH_ON%Bonjour les gars. Nous sommes des chasseurs de primes, si vous n\'avez pas remarqué, et je crois que vous avez une de nos primes.%SPEECH_OFF%Vous levez la tête de %robberbaron%.%SPEECH_ON%Vous voulez dire ça ?%SPEECH_OFF%Le chef sourit chaleureusement.%SPEECH_ON%Bien sûr. Maintenant, si vous pouviez me la remettre, ça nous arrangerait, moi et mes amis.%SPEECH_OFF%En tapant sur la poignée de son épée, l\'homme sourit.%SPEECH_ON%C\'est juste une question d\'affaires. Je suis sûr que vous comprenez.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prenez cette satanée tête et partez.",
					function getResult()
					{
						this.Flags.set("IsRobberBaronDead", false);
						this.Flags.set("IsBountyHunterPresent", false);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						return "BountyHunters2";
					}

				},
				{
					Text = "{Vous devrez la payer de votre sang si vous la voulez tant. | Si vous voulez que votre tête rejoigne celle-ci, allez-y, tentez votre chance.}",
					function getResult()
					{
						this.TempFlags.set("IsBountyHunterTriggered", true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "BountyHunters";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters2",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Vous avez vu assez de carnage pour aujourd\'hui et vous leur remettez la tête.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Passons à autre chose. Nous avons encore un paiement à collecter.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters3",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Les chasseurs de primes sont trop forts pour %companyname% ! Ne voulant pas que vos hommes soient tués inutilement, vous ordonnez une retraite anticipée. Malheureusement, la tête de %robberbaron% a été perdue dans le chaos...",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tant pis. Nous avons encore le paiement pour la quête à collecter.",
					function getResult()
					{
						this.Flags.set("IsBountyHunterRetreat", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Alors que la bataille touche à sa fin, quelques ennemis se mettent à genoux et implorent la pitié. %randombrother% se tourne vers vous pour savoir quoi faire ensuite. | Après la bataille, vos hommes rassemblent les brigands qui restent. Les survivants supplient pour leur vie. L\'un d\'eux ressemble plus à un enfant qu\'à un homme, mais c\'est le plus calme de tous. | Réalisant leur défaite, les quelques derniers brigands debout jettent leurs armes et demandent la pitié. Vous vous demandez maintenant ce qu\'ils feraient s\'ils étaient à votre place. | La bataille est terminée, mais des décisions doivent encore être prises : quelques brigands ont survécu à la bataille. %randombrother% se tient au-dessus de l\'un d\'eux, son épée au cou du prisonnier, et il vous demande ce que vous souhaitez faire.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Trancher leurs gorges.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivors2";
					}

				},
				{
					Text = "Prenez leurs armes et chassez-les.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivors3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{L\'altruisme s\'est pour les naïfs. Vous faites massacrer les prisonniers. | Vous vous rappelez combien de fois des brigands ont tué d\'infortunés marchands. Cette pensée est à peine sortie de votre esprit que vous donnez l\'ordre d\'exécuter les prisonniers. Ils émettent une brève protestation, mais elle est interrompue par des épées et des lances. | Vous vous retournez.%SPEECH_ON%A travers leur cou. Faites vite.%SPEECH_OFF%Les mercenaires suivent l\'ordre et on entend bientôt les râles des hommes mourants. Ce n\'est pas rapide du tout. | Vous secouez la tête. Les prisonniers crient, mais les hommes sont déjà sur eux, ils tailladent, tranchent et poignardent. Les plus chanceux sont décapités avant même d\'avoir pu réaliser l\'immédiateté de leur propre mort. Ceux qui se battent encore souffrent jusqu\'à la fin. | La pitié demande du temps. Du temps pour regarder par-dessus votre épaule. Du temps pour se demander si c\'était la bonne décision. Vous n\'avez pas le temps. Vous n\'avez pas de pitié. Les prisonniers sont exécutés et cela prend peu de temps.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous avons des choses plus importantes à régler.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Il y a eu assez de morts et de blessés aujourd\'hui. Vous laissez partir les prisonniers, prenez leurs armes et armures avant de les envoyer au loin. | La clémence pour les voleurs et les brigands n\'est pas fréquente, alors quand vous libérez les prisonniers, ils vous baisent pratiquement les pieds comme s\'ils étaient attachés à un dieu. | Vous réfléchissez un moment, puis vous acquiescez.%SPEECH_ON%Partons pour la pitié. Prenez leur équipement et relâchez-les.%SPEECH_OFF%Les prisonniers sont relâchés, laissant derrière eux les armes et les armures qu\'ils avaient sur eux. | Vous faites déshabiller les brigands jusqu\'à leurs sous-vêtements - s\'ils en ont - puis vous laissez partir les hommes. %randombrother% fouille dans l\'équipement laissé derrière eux tandis que vous regardez un groupe d\'hommes à moitié nus s\'éloigner.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous ne sommes pas payés pour les tuer.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Juste au moment où la bataille se termine et que les choses commencent à se calmer, vous entendez un homme crier. Vous vous dirigez vers le bruit pour trouver un prisonnier des brigands. Il a des cordes sur sa bouche et ses mains que vous défaites rapidement. Alors qu\'il reprend son souffle, il demande docilement s\'il peut rejoindre votre compagnie. | Vous trouvez un prisonnier attaché dans le camp des brigands. En le libérant, il explique qu\'il vient de %randomtown%, et qu\'il a été kidnappé par les vagabonds il y a quelques jours. Il demande s\'il pourrait rejoindre votre groupe de mercenaires. | En fouillant dans ce qui reste du camp des brigands, vous découvrez un de leurs prisonniers. En le libérant, l\'homme s\'assied et explique que les brigands l\'ont kidnappé alors qu\'il se rendait à %randomtown% en quête de travail. Vous vous demandez s\'il ne pourrait pas plutôt travailler pour vous... | Un homme est laissé derrière après la bataille. Ce n\'est pas un brigand, mais en fait un de leurs prisonniers. Lorsque vous lui demandez qui il est, il mentionne qu\'il vient de %randomtown% et qu\'il cherche du travail. Vous lui demandez s\'il sait manier l\'épée. Il acquiesce.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Vous pourriez aussi bien nous rejoindre.",
					function getResult()
					{
						return "Volunteer2";
					}

				},
				{
					Text = "Rentrez chez vous.",
					function getResult()
					{
						return "Volunteer3";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Volunteer2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{L\'homme rejoint vos rangs, s\'immergeant dans une foule de frères d\'armes qui semblent l\'accueillir assez chaleureusement pour un groupe de tueurs à gages. Le nouvel engagé déclare qu\'il est doué avec toutes les armes, mais vous vous dites que c\'est vous qui déciderez avec quoi il est le plus doué. | Le prisonnier sourit d\'une oreille à l\'autre lorsque vous acceptez qu\'il rejoigne la compagnie. Quelques frères demandent quelles armes ils doivent lui donner, mais vous haussez les épaules et vous vous dites que vous allez voir vous-même avec quoi l\'armer.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Voyons voir s\'il y a une arme pour toi.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getPlayerRoster().add(this.Contract.m.Dude);
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude.onHired();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Volunteer3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Vous secouez la tête pour dire non. L\'homme fronce les sourcils.%SPEECH_ON%Etes-vous sûr ? Je suis plutôt bon avec...%SPEECH_OFF%Vous lui coupez la parole.%SPEECH_ON%J\'en suis sûr. Maintenant, profite de cette liberté retrouvée, étranger.%SPEECH_OFF% | Vous évaluez l\'homme et vous vous dites qu\'il n\'est pas fait pour la vie de mercenaire.%SPEECH_ON%Nous apprécions l\'offre, étranger, mais la vie de mercenaire est dangereuse. Rentrez chez vous, dans votre famille, votre travail, votre maison.%SPEECH_OFF% | Vous avez assez d\'hommes pour vous en sortir, bien que vous soyez tenté de remplacer %randombrother% juste pour voir la réaction de l\'homme en se faisant rétrograder. Au lieu de cela, vous offrez une poignée de main au prisonnier et le renvoyez chez lui. Bien que déçu, il vous remercie de l\'avoir libéré.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Vous pouvez y aller.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez à %townname% et parlez à %employer%. Les détails de votre voyage sont simples : vous avez tué les brigands. Il acquiesce, sourit brièvement avant de vous remettre votre paiement comme convenu.%SPEECH_ON%Bon travail, messieurs. Ces brigands nous ont donné beaucoup de fil à retordre.%SPEECH_OFF% | %employer% vous ouvre la porte lorsque vous arrivez chez lui. Il a une sacoche à la main et la brandit.%SPEECH_ON%J\'en déduis par votre retour que les brigands sont morts ?%SPEECH_OFF%Vous acquiescez. L\'homme soulève la sacoche dans votre direction. Vous lui dites que vous pourriez mentir. %employer% hausse les épaules.%SPEECH_ON%Peut-être, mais les mots voyagent vite pour ceux qui mordent les mains qui les nourrissent. Bon travail, mercenaire. A moins que vous ne mentiez bien sûr, alors je viendrai vous trouver.%SPEECH_OFF% | %employer% sourit lorsque vous entrez dans son bureau et posez une tête dans un sac sur son bureau.%SPEECH_ON%Vous n\'avez pas besoin de tacher mes parures pour montrer que vous avez accompli la tâche, mercenaire. J\'ai déjà eu des nouvelles de votre succès - les oiseaux dans ces terres voyagent vite, n\'est-ce pas ? Votre paiement est dans le coin de la pièce.%SPEECH_OFF% | Alors que vous terminez votre rapport, %employer% s\'essuie le front avec un bout de tissu.%SPEECH_ON%Vraiment, ils sont tous morts alors ? Bon sang... vous n\'avez pas idée du poids que vous avez enlevé des mes épaules, mercenaire. Aucune idée du tout ! Vos couronnes, comme promis.%SPEECH_OFF%Il pose une sacoche sur son bureau et vous la prenez rapidement. Tout est là, comme promis. | %employer% sirote son gobelet et acquiesce.%SPEECH_ON%Vous savez, je n\'aime pas trop votre genre, mais vous avez fait du bon travail, mercenaire. %randomname% m\'en a informé, avant même votre arrivée, que tous les brigands avaient été tués. C\'était du très bon travail d\'après sa description. Et, aussi...%SPEECH_OFF%Il soulève une sacoche sur le bureau.%SPEECH_ON%Voilà un très bon salaire, comme promis.%SPEECH_OFF% | %employer% se penche sur sa chaise et croise ses bras sur ses genoux.%SPEECH_ON%Les mercenaires ne plaisent pas à beaucoup de gens, je suppose parce que vous avez tué et détruit des villages entiers sur un coup de tête, mais j\'admets que vous avez bien trazvaillé cette fois-ci.%SPEECH_OFF%Il fait un signe de tête vers un coin de la pièce où se trouve un coffre en bois non ouvert.%SPEECH_ON%Tout est là, mais je ne serai pas offensé si vous avez besoin de compter.%SPEECH_OFF%Vous comptez, et tout est bien là. | Le bureau de %employer% est couvert de parchemins sales et déroulés. Il leur sourit chaleureusement comme s\'il chantait sur un tas de trésor.%SPEECH_ON%Offres commerciales ! Des accords commerciaux partout ! Des agriculteurs heureux ! Familles heureuses ! Tout le monde est heureux ! Ah, c\'est bon d\'être moi. Et, bien sûr, c\'est bon d\'être vous, mercenaire, parce que vos poches viennent de s\'alourdir un peu plus !%SPEECH_OFF%L\'homme vous jette un petit sac à main, puis un autre et un autre.%SPEECH_ON%J\'aurais bien payé avec une plus grande sacoche, mais j\'aime bien faire ça.%SPEECH_OFF%Il lance effrontément une autre bourse que vous attrapez avec l\'aplomb non amusé d\'un homme qui a encore du sang frais sur son épée.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "A détruit un campement de brigands");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous jetez la tête du criminel sur la table de %employer%. Avec un sourire, vous la montrez du doigt.%SPEECH_ON%C\'est %robberbaron%.%SPEECH_OFF%%employer% se lève et dévoile le sac de jute qui recouvre le trophée. Il fait un signe de tête.%SPEECH_ON%Oui, c\'est bien lui. Je suppose que vous aurez un supplément pour ça.%SPEECH_OFF%Vous êtes payé une somme importante de %reward% couronnes pour avoir tué les brigands et détruit le chef de nombreux camps voisins. | %employer% se penche en arrière lorsque vous entrez dans son bureau , portant une tête par les cheveux. Heureusement, elle ne dégouline pas.%SPEECH_ON%C\'est %robberbaron%. Ou devrais-je dire était ?%SPEECH_OFF%Se levant lentement, %employer% jette un coup d\'œil rapide.%SPEECH_ON%\"était\" fonctionne... Donc, non seulement vous avez détruit le trou à rats des brigands, mais vous m\'avez apporté la tête de leur chef. C\'est du très bon travail, mercenaire, et vous aurez un bonus pour ça.%SPEECH_OFF%L\'homme vous donne une sacoche de %original_reward% couronnes puis prend une bourse de ses propres fonds et la lance vers vous. | Vous tenez la tête de %robberbaron%, son regard incliné se tourne vers les cordes de cheveux ensanglantés. Un lent sourire se dessine sur le visage de %employer%.%SPEECH_ON%Vous savez ce que vous avez fait, sellsword ? Savez-vous combien de soulagement vous avez apporté à ces régions juste en retirant la tête des épaules de cet homme  ? Vous allez obtenir plus que ce que nous avions négocié ! %original_reward% couronnes pour la tâche de départ et...%SPEECH_OFF%L\'homme fait glisser un grosse bourse sur sa table.%SPEECH_ON%Un petit quelque chose pour ce... poids supplémentaire que vous avez sur vous.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "A détruit un campement de brigands");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.Contract.m.OriginalReward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"original_reward",
			this.m.OriginalReward
		]);
		_vars.push([
			"robberbaron",
			this.m.Flags.get("RobberBaronName")
		]);
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
		if (this.m.SituationID == 0)
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
		_out.writeI32(0);

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
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

