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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% secoue rageusement la tête.%SPEECH_ON%Les brigands ont ravagé ces régions depuis bien trop longtemps ! J'ai envoyé un garçon, le fils de %randomname%, pour les trouver. Et vous savez quoi ? Seule sa tête est revenue. Bien sûr, ces idiots de brigands ont envoyé l'un des leurs pour la livrer. Nous l'avons capturé et interrogé... donc maintenant nous savons où ils sont.%SPEECH_OFF%L'homme se penche en arrière, en déplaçant ses pouces l'un sur l'autre pour réfléchir.%SPEECH_ON%Je n'ai pas les hommes, mais j'ai les couronnes - et si j'en glissais quelques-unes vers vous, et vous glissiez une épée vers eux ?%SPEECH_OFF% | %employer% se sert un verre, fixe la tasse et s'en sert encore. Il semble la vider d'un trait avant de cracher ses nouvelles.%SPEECH_ON%Les brigands ont tué %randomname% et toute sa famille. Vous pouvez croire ça ? Je sais que vous ne savez pas qui ils étaient, mais c'était une famille très appréciée dans le coin. Je suis sûr que vous pouvez déjà imaginer, mais je veux en finir avec ces brigands. J'ai perdu la moitié de mes hommes à trouver leur camp, maintenant je suis prêt à perdre une partie de mes couronnes pour que vous alliez les tuer. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% regarde par la fenêtre et fait glisser un doigt sur le bord d'un verre en réfléchissant.%SPEECH_ON%Des brigands sont partis avec du précieux bétail. Ils viennent la nuit, les brigands je veux dire, et coupent les cloches pour partir tranquillement. Je suis sûr que le bétail n'est pas important pour vous, mais un veau, une vache, un taureau ? C'est une fortune pour certaines personnes dans ces régions.\n\nL'autre jour, j'ai demandé à un garçon de suivre les traces d'animaux en dehors de la ville et maintenant il me dit exactement où se trouvent ces brigands. Comme vous pouvez le deviner, je n'ai pas assez d'hommes pour affronter ces vagabonds, mais les couronnes... je ne suis pas à court de couronnes. Si je devais arroser vos paumes de couronnes, seriez-vous prêt à arroser ces brigands d'acier ?%SPEECH_OFF% | %employer% soupire comme s'il était fatigué de tous ces ennuis, comme s'il était sur le point d'entamer une conversation qu'il a déjà eu de nombreuses fois auparavant.%SPEECH_ON%%randomname%, un homme d'importance ici, déclare que des brigands se sont attaqués à ses filles. Il s'inquiète maintenant de ce qu'ils feront la prochaine fois. Heureusement, cet homme est assez riche et a pu facilement retrouver ces brigands. Si je vous payais une somme décente, pourriez-vous enfoncer l'une de vos épées dans un ou deux brigands ?%SPEECH_OFF% | %employer% prend place dans un fauteuil assez grand pour être confortable pour deux. Il agite une tasse dans tous les sens.%SPEECH_ON%Les brigands nous harcèlent depuis des semaines et hier encore, ils ont essayé de mettre le feu à un pub. Vous pouvez croire ça ? Qui met le feu à une telle chose ? Heureusement, nous l'avons éteint juste à temps, mais les choses vont mal par ici. S'ils menacent notre précieuse boisson, que feront-ils ensuite ? Heureusement, nous avons réussi à trouver où ces vagabonds se cachent. Alors... oui, je vois votre regard. C'est une tâche simple, mercenaire : nous voulons que vous alliez tuer tous les brigands jusqu'au dernier. Êtes-vous prêt à travailler pour nous ?%SPEECH_OFF% | Alors que vous vous installez dans la pièce, %employer% termine un gobelet de vin et jette la coupe par la fenêtre. Vous entendez le bruit que le gobelet fait en s'entrechoquant au loin, très loin. Il se tourne vers vous.%SPEECH_ON%Alors que je marchais sur les routes, des brigands ont attaqué mon chariot et se sont emparés de tous mes biens ! Ils m'ont laissé la vie sauve, ce qui est bien, mais le culot de ce qu'ils ont fait m'empêche de dormir la nuit. Je vois leurs visages narquois... j'entends leurs rires... Je crois que c'était un message, pour me poursuivre, parce que j'ai refusé de payer leur \"péage\". Eh bien, maintenant je suis prêt à payer un péage - à vous, mercenaire. Si vous allez massacrer ces vagabonds, je paierai un bon prix. Qu'en dites-vous ?%SPEECH_OFF% | Alors que vous vous apprêtez à vous asseoir, %employer% vous lance un parchemin. Il se déplie au moment où vous l'attrapez. Vous commencez à lire, mais %employer% commence quand même à vous donner des informations.%SPEECH_ON%Les commerçants de %randomtown% ont tous accepté de ne plus fréquenter %townname% tant que notre petit problème de brigands ne sera pas réglé. L'histoire est assez simple, car je suis sûr que vous connaissez les méthodes des brigands, mais ces satanés vagabonds ont harcelé les routes, pillé les caravanes et tué les marchands.\n\nJe sais exactement où ils sont, j'ai juste besoin d'un homme de cran et en manque de gloire - ou d'or ! - pour aller les tuer. Alors qu'en dites-vous, mercenaire ? Donnez-moi un prix et nous pourrons discuter.%SPEECH_OFF% | %employer% tremble quand vous le saluez. Il écume pratiquement de colère - ou peut-être qu'il est juste vraiment ivre.%SPEECH_ON%Les citoyens de cette belle ville sont affamés. Pourquoi ? Parce que des brigands se faufilent pendant la nuit pour piller les greniers ! Et si on les attrape, ils brûlent les bâtiments ! Maintenant, nous ne pouvons pas nous défendre en restant assis... Maintenant... Je veux me défendre en les tuant tous.%SPEECH_OFF%L'homme vacille un instant, comme s'il était sur le point de se renverser sur son bureau. Il se stabilise avant de poursuivre.%SPEECH_ON%Je veux que vous alliez tuer ces vagabonds, évidemment. Tout ce que vous avez à faire est d'être intéressé et... -Hic-... dire votre prix.%SPEECH_OFF% | %employer% regarde solennellement le sol. Il déploie un parchemin, vous montrant un visage.%SPEECH_ON%Voici %randomname%, un brigand en liberté que nous avons capturé l'autre jour. Il était à la tête d'une bande de vagabonds qui harcelaient et pillaient notre ville nuit et jour . Le problème est qu'il n'est pas vraiment la tête du serpent, mais la tête d'une hydre. Tuez une tête criminelle, une autre prend sa place. Alors quelle est la réponse ? Eh bien, les tuer tous, bien sûr. Et c'est exactement ce que je veux que vous fassiez, mercenaire. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% se tourne vers vous alors que vous cherchez un endroit où vous asseoir.%SPEECH_ON%Bonjour, mercenaire, depuis combien de temps n'avez-vous pas trempé votre épée dans le sang d'hommes mauvais et cruels ?%SPEECH_OFF%Il laisse tomber le sarcasme et vous vous dites que vous resterez debout.%SPEECH_ON%Ici, à %townname%, nous avons un petit problème avec des brigands locaux. Pour nous, c'est-à-dire avec leur petit trou à rat pas loin d'ici. Évidemment, je pense que la solution à ce problème est d'engager des hommes finement armés comme votre petite compagnie de bons hommes. Alors, cela vous intéresse-t-il, mercenaire, ou dois-je trouver des hommes plus robustes pour cette tâche ?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_54.png[/img]{En espionnant le campement de brigands, vous remarquez le profil d'un homme que les habitants du coin décrivent presque avec ferveur : il s'agit de %robberbaron%, un célèbre baron voleur qui terrorise ces régions. Il a une escorte d'hommes à l'air brutal qui le suivent partout où il va.\n\nVous misez sur le fait que sa tête vaut quelques couronnes supplémentaires. | Vous n'aviez pas prévu de le voir, mais il ne fait aucun doute que c'est l'homme en chair et en os : %robberbaron% est au campement des brigands. Le célèbre tueur est apparemment en train de rendre visite à l'une de ses filiales criminelles, marchant prudemment au milieu des voleurs, pointant du doigt ceci ou cela, faisant des remarques sur la qualité de ceci et de cela.\n\nQuelques gardes du corps le suivent partout. Vous estimez qu'entre lui et le reste des brigands, il y a environ %totalenemy% hommes qui se baladent. | Le contrat ne prévoyait que l'élimination des brigands, mais il semblerait qu'un gros bonnet, soit de la partie : %robberbaron%, le tristement célèbre tueur et pilleur de grand chemin, est au camp. Suivi d'un garde du corps, le baron voleur semble évaluer une de ses affaires criminelles.\n\nVous vous demandez combien coûterait la tête de %robberbaron% en couronnes... | %robberbaron%. C'est lui, vous le savez. En regardant à travers une lorgnette, vous pouvez facilement voir la silhouette de l'infâme baron voleur alors qu'il se déplace dans le campement des brigands. Il n'était pas dans vos plans, ni mentionné dans le contrat, mais il y a peu de doute que si vous ramenez sa tête en ville, vous obtiendrez un petit extra pour votre peine. | Alors que vous espionnez les brigands - vous comptez environ %totalenemy% d'hommes en mouvement - vous apercevez une silhouette à laquelle vous ne vous attendiez pas du tout : %robberbaron%, le tristement célèbre baron voleur. L'homme et son garde du corps doivent être en train d'inspecter l'état du camp.\n\nQuelle chance ! Si vous pouviez rapporter sa tête à votre employeur, vous pourriez gagner un petit bonus.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à l'attaque !",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{La bataille achevée, vous vous dirigez vers le corps de %robberbaron% et retirez sa tête avec deux coups rapides de votre épée, le premier coup coup coupant la viande, le second l'os. Vous enfoncez un crochet dans la chair du cou et tirez une corde de manière à l'attacher à votre hanche. | Le combat terminé, vous cherchez et trouvez rapidement le cadavre de %robberbaron% parmi les morts. Il a toujours l'air méchant même si la couleur a quitté son corps. Il a l'air toujours aggressif même après avoir retirer ça tête de son corps et bien que vous ne puissiez plus voir son visage lorsque vous jetez sa tête dans un sac en toile, vous supposez qu'il a l'air toujours aggressif. | %robberbaron% gît mort à vos pieds. Vous retournez le corps et tendez le cou, donnant à votre épée un meilleur angle de frappe. Il vous faut deux bons coups pour retirer la tête que vous mettez rapidement dans un sac. | Maintenant qu'il est mort, %robberbaron% vous rappelle soudain beaucoup d'hommes que vous avez connus. Vous ne vous contentez pas longtemps de ce sentiment de déjà vu : en quelques coups d'épée rapides, vous enlevez la tête de l'homme avant de la jeter dans un sac. | %robberbaron% s'est bien battu et son cou en a fait autant, les tendons et les os ne laissant pas sa tête partir facilement alors que vous collectez votre prime. | Vous avez récupéré la tête de %robberbaron%. %randombrother% la montre du doigt alors que vous passez devant lui.%SPEECH_ON%Qu'est-ce que c'est ? Est-ce que c'est %robberbaron%... ?%SPEECH_OFF%Vous secouez la tête.%SPEECH_ON%Non, cet homme est mort. Ça, c'est juste un complément de salaire.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]{Sur le chemin du retour pour récupérer votre paie, quelques hommes s'avancent sur la route. L'un d'eux pointe du doigt la tête de %robberbaron%. %SPEECH_ON%Nous sommes les chasseurs de primes les mieux payés de la région et je crois que vous nous volez une partie de nos affaires. Donnez-nous cette tête et tout le monde pourra dormir dans son lit ce soir.%SPEECH_OFF%Vous riez.%SPEECH_ON%Vous devrez proposer mieux que ça. La tête de %robberbaron% vaut beaucoup de couronnes, mon ami.%SPEECH_OFF%Le chef de ces supposés chasseurs de primes vous répond en riant. Il soulève un sac rempli et lourd.%SPEECH_ON%Voici %randomname%, l'un des types les plus recherchés dans le coin. Et là...%SPEECH_OFF%Il montre un autre sac.%SPEECH_ON%C'est la tête de l'homme qui l'a tué. Vous comprenez ? Alors remettez nous la tête pour la prime et nous pourrons tous partir.%SPEECH_OFF% | Un homme s'avance sur la route, se redresse et se dirige vers vous.%SPEECH_ON%Bonjour, messieurs. Je crois que vous avez la tête de %robberbaron%.%SPEECH_OFF%Vous acquiescez. L'homme sourit.%SPEECH_ON%Auriez-vous l'amabilité de me la remettre ?%SPEECH_OFF%Vous riez et secouez la tête. L'homme ne sourit pas, il lève une main et claque des doigts. Une foule d'hommes bien armés sortent des buissons voisins et s'avancent sur la route au son d'un bruit de métal lourd. Ils ressemblent à ce à quoi un condamné à mort pourrait rêver la nuit précédant son jugement. Leur chef affiche un sourire en coin.%SPEECH_ON%Je ne vais pas vous le redemander.%SPEECH_OFF% | Alors que vous parlez à %randombrother%, un cri fort attire votre attention. Vous regardez la route pour voir une foule d'hommes se tenant sur votre chemin. Ils ont toutes sortes d'armes et d'armures. Leur chef de file s'avance, annonçant qu'ils sont de célèbres chasseurs de primes.%SPEECH_ON%Nous souhaitons seulement avoir la tête de %robberbaron%.%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%On a tué l'homme, on garde sa tête. Maintenant, dégagez de notre chemin.%SPEECH_OFF%Quand vous faites un pas en avant, les chasseurs de primes lèvent leurs armes. Leur chef fait un pas vers vous.%SPEECH_ON%Il y a un choix à faire ici qui pourrait faire tuer beaucoup d'hommes bons. Je sais que ce n'est pas facile, mais je vous suggère d'y réfléchir très sérieusement.%SPEECH_OFF% | Un sifflement aigu attire votre attention et celle de vos hommes. Vous vous tournez sur le côté de la route pour voir un groupe d'hommes sortir de quelques buissons. Tout le monde sort son arme, mais les inconnus ne bougent pas d'un pas. Leur meneur s'avance. Il a une bandoulière avec des oreilles autour de sa poitrine un résumé de son travail.%SPEECH_ON%Bonjour les gars. Nous sommes des chasseurs de primes, si vous n'avez pas remarqué, et je crois que vous avez une de nos primes.%SPEECH_OFF%Vous levez la tête de %robberbaron%.%SPEECH_ON%Vous voulez dire ça ?%SPEECH_OFF%Le chef sourit chaleureusement.%SPEECH_ON%Bien sûr. Maintenant, si vous pouviez me la remettre, ça nous arrangerait, moi et mes amis.%SPEECH_OFF%En tapant sur la poignée de son épée, l'homme sourit.%SPEECH_ON%C'est juste une question d'affaires. Je suis sûr que vous comprenez.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]Vous avez vu assez de carnage pour aujourd'hui et vous leur remettez la tête.",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{With the battle drawing to a close, a few enemies drop to their knees and beg for mercy. %randombrother% looks to you for what to do next. | Après la bataille, your men round-up what brigands remain. The survivors beg for their lives. One looks more like a kid than a man, but he is the quietest of them all. | Realizing their defeat, the few last standing brigands drop their weapons and ask for mercy. You now wonder what they would do were the shoe on the other foot. | The battle\'s over, but decisions are still yet to be made: a few brigands survived the battle. %randombrother% stands over one, his sword to the prisoner\'s neck, and he asks you what you wish to do.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Slit their throats.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivors2";
					}

				},
				{
					Text = "Take their arms and chase them away.",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Altruism is for the naive. You have the prisoners slaughtered. | You recall how many times brigands slew hapless merchants. The thought is barely out of your mind when you give the order to have the prisoners executed. They pipe up a brief protest, but it is cut short by swords and spears. | You turn away.%SPEECH_ON%Through their necks. Make it quick.%SPEECH_OFF%The mercenaries follow the order and you soon here the gargling of dying men. It is not quick at all. | You shake your head \'no\'. The prisoners cry out, but the men are already upon them, hacking and slashing and stabbing. The lucky ones are decapitated before they can even realize the immediacy of their own demise. Those with some fight in them suffer to the very end. | Mercy requires time. Time to look over your shoulder. Time to wonder if it was the right decision. You\'ve no time. You\'ve no mercy. The prisoners are executed and that takes little time at all.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We have more important things to take care of.",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{There\'s been enough killing and dying today. You let the prisoners go, taking their arms and armor before sending them off. | Clemency for thieves and brigands doesn\'t come often, so when you let the prisoners go they practically kiss your feet as though they were attached to a god. | You think for a time, then nod.%SPEECH_ON%Mercy it is. Take their equipment and cut them loose.%SPEECH_OFF%The prisoners are let go, leaving behind what arms and armor they had with them. | You have the brigands strip to their skivvies - if they even have them - then let the men go. %randombrother% rummages through what equipment is left behind as you watch a group of half-naked men hurry away.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'re not getting paid for killing them.",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Just as the battle ends and things begin to quiet, you hear a man shouting. You move toward the noise to find a prisoner of the brigands. He\'s got ropes over his mouth and hands which you quickly undo. As he catches his breath, he meekly asks if maybe he could join your outfit. | You find a prisoner tied up in the brigands\' camp. Freeing him, he explains that he is from %randomtown%, and was kidnapped by the vagabonds just a few days ago. He asks if maybe he could join your band of mercenaries. | Rummaging what\'s left of the brigands\' camp, you discover a prisoner of theirs. Freeing him, the man sits up and explains that the brigands kidnapped him as he was traveling to %randomtown% in seek of work. You wonder if maybe he could work for you instead... | A man is left behind Après la bataille. He\'s not a brigand, but in fact a prisoner of theirs. When you ask who he is, he mentions that he is from %randomtown% and that he\'s looking for work. You ask if he can wield a sword. He nods.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "You might as well join us.",
					function getResult()
					{
						return "Volunteer2";
					}

				},
				{
					Text = "Go home.",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{The man joins your ranks, immersing himself in a crowd of brothers who seem to take to him warmly enough for a group of paid killers. The newly hired states he\'s good with all weapons, but you figure you\'ll be the one to decide what he\'s best with. | The prisoner grins from ear to ear as you wave him in. A few brothers ask what weapons they should give him, but you shrug and figure you\'ll see to yourself what to arm the man with.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Let\'s see about a weapon for you.",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{You shake your head no. The man frowns.%SPEECH_ON%Are you sure? I\'m pretty good with...%SPEECH_OFF%You cut him off.%SPEECH_ON%I\'m sure. Now enjoy your newfound freedom, stranger.%SPEECH_OFF% | You appraise the man and figure he\'s not fit for the life of a sellsword.%SPEECH_ON%We appreciate the offer, stranger, but the mercenary life is a dangerous one. Go home to your family, your work, your home.%SPEECH_OFF% | You\'ve enough men to see you through, although you find yourself tempted to replace %randombrother% just to see the man\'s reaction to a demotion. Instead, you offer the prisoner a handshake and send him on his way. Although disappointed, he does thank you for freeing him.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Off you go.",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %townname% and talk to %employer%. The details of your journey are simple: you killed the brigands. He nods, smiling tersely before handing over your payment as agreed upon.%SPEECH_ON%Good work, men. Those brigands were giving us plenty of trouble.%SPEECH_OFF% | %employer% opens the door for you as you get to his home. He\'s got a satchel in hand and holds it up.%SPEECH_ON%I take it by your return that the brigands are dead?%SPEECH_OFF%You nod. The man heaves the satchel your way. You tell him you could be lying. %employer% shrugs.%SPEECH_ON%Could be, but word travels fast for those who bite the hands that feed. Good work, sellsword. Unless you\'re lying of course, then I\'ll come find you.%SPEECH_OFF% | %employer% grins as you enter his room and lay a sacked head on his desk.%SPEECH_ON%You need not stain my fineries to show you\'ve completed the task, sellsword. I\'ve already gotten news of your success - the birds in these lands do travel fast, don\'t they? Your payment is in the corner.%SPEECH_OFF% | As you finish your report, %employer% wipes his forehead with a handkerchief.%SPEECH_ON%Really, they\'re all dead then? Boy... you have no idea how much you\'ve lifted off my shoulders, sellsword. No idea at all! Your crowns, as promised.%SPEECH_OFF%He sets a satchel on his desk and you quickly take it. All is there, as promised. | %employer% sips his goblet and nods.%SPEECH_ON%You know, I don\'t take kindly to your sort, but you did a good job, mercenary. %randomname% reported to me, before you even got here, that all the brigands had been slain. It was some mighty fine work by the way he describes it. And, well...%SPEECH_OFF%He heaves a satchel onto the desk.%SPEECH_ON%Here\'s some mighty fine pay, as promised.%SPEECH_OFF% | %employer% leans back in his chair, folding his hands over his lap.%SPEECH_ON%Sellswords don\'t sit right with many folks, I suppose on the account of y\'all killing and destroying whole villages on a shortchanged whim, but I\'ll admit you\'ve done good.%SPEECH_OFF%He nods to a corner of the room where a wooden chest lays unopened.%SPEECH_ON%It\'s all there, but I won\'t be offended if you need to count it.%SPEECH_OFF%You do count it, and it is indeed all there. | %employer%\'s desk is blanketed in dirtied and unfurled scrolls. He\'s smiling warmly over them as if he\'s crooning over a pile of treasure.%SPEECH_ON%Trade deals! Trade deals everywhere! Happy farmers! Happy families! Everyone\'s happy! Ah, it\'s good to be me. And, of course, it\'s good to be you, sellsword, because your pockets just got a little bit heavier!%SPEECH_OFF%The man tosses a small purse your way, then another and another.%SPEECH_ON%I would\'ve paid with a larger satchel, but I just like doing that.%SPEECH_OFF%He cheekily tosses another purse which you casually catch with the sort of unamused aplomb of a man who still has fresh blood on his sword.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Destroyed a brigand encampment");
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You throw the criminal\'s head on %employer%\'s table. With a grin, you point at it.%SPEECH_ON%That\'s %robberbaron%.%SPEECH_OFF%%employer% stands up and unveils the burlap sack covering the trophy. He nods.%SPEECH_ON%Aye, that\'s him alright. I guess you\'ll be getting extra for that.%SPEECH_OFF%You\'re paid a tidy sum of %reward% crowns for killing the brigands as well as destroying the leadership of many nearby syndicates. | %employer% leans back as you enter his room, carrying a head by its hair. Luckily, it is not dripping.%SPEECH_ON%This here is %robberbaron%. Or should I say was?%SPEECH_OFF%Slowly standing, %employer% takes a cursory look.%SPEECH_ON%\'Was\' works... So, not only did you destroy the brigands\' rat hole, but you\'ve brought me the head of their leader. That is some mighty fine work, sellsword, and you\'ll be getting extra for this.%SPEECH_OFF%The man forks over a satchel of %original_reward% crowns and then takes a purse off his own self and pitches it toward you. | You hold %robberbaron%\'s head up, its sloped gaze turning to the ropes of bloodied hair. A slow smile etches across %employer%\'s face.%SPEECH_ON%You know what you\'ve done, sellsword? Do you know how much relief you\'ve brought to these parts just by removing that man\'s head from his shoulders? You\'ll be getting more than what you bargained for! %original_reward% crowns for the original task and...%SPEECH_OFF%The man slides a chunky purse across his table.%SPEECH_ON%A little something for that... extra weight you\'ve been carrying around.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Destroyed a brigand encampment");
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

