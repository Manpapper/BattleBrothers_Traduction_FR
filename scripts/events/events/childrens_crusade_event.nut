this.childrens_crusade_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Traveller = null
	},
	function create()
	{
		this.m.ID = "event.childrens_crusade";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 300.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]Sur le chemin, vous rencontrez une petite armée d\'enfants. Le plus âgé et le plus grand d\'entre eux a probablement quinze ans tout au plus, avec une chevelure orange touffue et avec une lance comme arme. Il mène la troupe, une petite force de combat provinciale sur le chemin ce qui  est déjà plus dans certaines ville ou village. Lorsqu\'ils vous croisent, ce petit chef incline sa tête vers vous.%SPEECH_ON%Faites place ! Nous sommes en marche pour la justice et rien ne doit nous arrêter !%SPEECH_OFF%Curieux, vous demandez où ils vont. L\'enfant répond comme s\'il était étonné que vous ne le sachiez pas.%SPEECH_ON%Eh bien, laissez-moi vous le dire, mercenaire. Nous nous dirigeons vers le nord à travers les régions gelées. Les tribus incultes et non civilisées ont besoin d\'entendre parler des anciens dieux, que ce soit par la parole ou par l\'épée.%SPEECH_OFF%Il lève la lance. Un \"cri de guerre\" plutôt joyeux s\'élève de l\'armée. Il semble qu\'une certaine ferveur religieuse se soit emparée de ce groupe errant et inoffensif, et donc suicidaire.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Vous devriez rentrer chez vos parents, les enfants.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "%monk%, tu parles au nom des anciens dieux. Qu\'en dis-tu ?",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Traveller != null)
				{
					this.Options.push({
						Text = "%walker%, tu as voyagé là-bas. Dis quelque chose.",
						function getResult( _event )
						{
							return "Traveller";
						}

					});
				}

				this.Options.push({
					Text = "Je vais vous épargner la longue marche et vous débarrasser de tout objet de valeur ici.",
					function getResult( _event )
					{
						return "C";
					}

				});
				this.Options.push({
					Text = "Bonne chance, j\'imagine.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_97.png[/img]Vous dites aux enfants de rentrer chez leurs parents. Le chef rit et les autres lui emboîtent le pas, comme des gamins facilement impressionnés par leur grand frère. Il secoue la tête.%SPEECH_ON%Pourquoi pensez-vous que nous sommes allés si loin ? Nos parents savent où nous sommes, et ils savent que là où nous sommes, c\'est pour la bonne cause. Les anciens dieux doivent être connus dans tout le pays ! Maintenant, faites place !%SPEECH_OFF%Les enfants se dépêchent. Une petite bannière passe devant vous et il y a beaucoup de cliquetis de leurs petites armes, principalement des bouteilles, des lance-pierres et de la vaisselle.\n\nIl ne fait aucun doute qu\'ils marchent vers une mort certaine. Les voleurs et les vagabonds sont sûrs de s\'en prendre à eux, comme des faucons à des rongeurs, et les esclavagistes n\'hésitent pas à faire disparaître des enfants apparemment orphelins. S\'ils vont au-delà de ces menaces, les terres du nord leur fourniront un cercueil gelé dans lequel ils mourront.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bonne chance.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_97.png[/img]%monk% le moine s\'avance et rassemble les enfants. Ils respectent instantanément l\'homme, car il représente en partie la cause même qu\'ils souhaitent promouvoir. Il plie un genou.%SPEECH_ON%Est-ce que ce sont les anciens dieux qui vous ont dit de sortir et de faire ça ?%SPEECH_OFF%Le petit chef acquiesce.%SPEECH_ON%Ils m\'ont parlé dans mon sommeil.%SPEECH_OFF%Le moine acquiesce, se frotte le menton et réfléchit. Il tapote le garçon sur sa tête.%SPEECH_ON%Les anciens dieux me parlent et je parle pour eux. L\'interprétation de leur message demande des années d\'étude, laissez-moi vous le dire ! Es-tu certain que c\'est toi, petit, qui devais porter ce fardeau ? Peut-être devais-tu être le messager, non ? Regarde-nous, nous sommes des guerriers. Des hommes en pleine forme, capables de tuer ceux qui méprisent et abaissent les anciens dieux. Tu n\'es pas encore comme nous, mais tu as une voix forte et le commandement d\'un vrai chef. Je crois que les anciens dieux voulaient t\'utiliser pour ton charisme, pas pour tes muscles.%SPEECH_OFF%Le moine donne au garçon une tape sur l\'épaule. Il sourit, réalisant la pertinence de ce que le moine a à dire. Le petit chef dit à son groupe qu\'ils doivent rentrer chez eux car le moine a certainement raison. Certains hommes sont reconnaissants que ces enfants aient été dissuadés d\'aller vers une mort certaine.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Des enfants idiots.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.World.Assets.addMoralReputation(2);
				local resolve = this.Math.rand(1, 2);
				_event.m.Monk.getBaseProperties().Bravery += resolve;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] de Détermination"
				});
				_event.m.Monk.improveMood(1.0, "A sauvé des enfants d\'une mort certaine");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Monk.getID() && this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(0.5, "Est heureux que " + _event.m.Monk.getName() + " ait sauvé des enfants d\'une mort certaine");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "Traveller",
			Text = "[img]gfx/ui/events/event_97.png[/img]%walker% enlève ses bottes et montre le dessous de ses pieds aux enfants. Ils reculent, s\'étouffent et se couvrent la bouche. Une petite fille laisse échapper un long \"beurk\" pour bien faire passer le message. L\'homme remue son pied dans tous les sens, montrant une peau calleuse et dégoûtante.%SPEECH_ON%J\'ai passé des années sur la route et la plupart d\'entre elles sans une bonne chaussure pour marcher. Je sais comment c\'est dehors. J\'en connait les dangers. Des gens qui se poignardent les uns les autres dans leur sommeil. Tuer pour une bouchée de biscuit. Des étrangers se lient d\'amitié avec vous pour vous trahir ensuite. Et tout ça c\'est quand tout va bien ! Quand ça va mal, ça devient... eh bien, ça devient vraiment moche. Les enfants, vous n\'avez rien à faire ici. Vous serez violés, assassinés, réduits en esclavage, torturés, donnés en pâture aux chiens, mangés par les sangliers, les ours, les loups, toutes les choses qui vous regardent comme si vous étiez leurs repas sur deux pattes. Rentrez chez vous. Tous autant que vous êtes.%SPEECH_OFF%La bande d\'enfants murmure entre eux. L\'un d\'eux annonce qu\'il va retourner chez sa mère. Une petite fille déclare qu\'elle ne voulait même pas être ici de toute façon et qu\'elle n\'a jamais eu les friandises promises. Sentant que le moral est au plus bas, le petit chef tente de rassembler les enfants, mais c\'est inutile. Le groupe se sépare et, heureusement, commence à rentrer chez lui. Certains des hommes sont soulagés car ils ne souhaitaient pas voir les petits poursuivre leur voyage mortel.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu devrais probablement faire examiner ces pieds.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Traveller.getImagePath());
				this.World.Assets.addMoralReputation(2);
				local resolve = this.Math.rand(1, 2);
				_event.m.Traveller.getBaseProperties().Bravery += resolve;
				_event.m.Traveller.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Traveller.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] de Détermination"
				});
				_event.m.Traveller.improveMood(1.0, "A sauvé des enfants d\'une mort certaine");

				if (_event.m.Traveller.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Traveller.getMoodState()],
						text = _event.m.Traveller.getName() + this.Const.MoodStateEvent[_event.m.Traveller.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Traveller.getID() && this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(0.5, "Est heureux que " + _event.m.Traveller.getName() + " ait sauvé des enfants d\'une mort certaine");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]Vous doutez que vous puissiez faire sortir la passion de ces enfants avec des mots, mais en vous fiant à l\'éducation que vous avez eu de votre père, vous pouvez probablement la leur faire sortir avec les poings. Avec un ordre rapide, vous faites en sorte que la compagnie s\'en prenne aux enfants, les frappant et prenant leurs affaires. Le petit chef essaie de piquer un mercenaire et se fait battre à plate couture.\n\nCe n\'est pas la plus belle des choses à faire et ce serait vraiment mal vu si quelqu\'un voyait la compagnie battre des enfants, mais cette \"fin\" à leur croisade est préférable aux plus méchantes qui les attendent sur la route.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mangez de la terre, petits avortons.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-4);
				local item = this.new("scripts/items/loot/silverware_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/weapons/militia_spear");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 11,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(1.0, "A été consterné par votre ordre de voler des enfants");

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
	}

	function onUpdateScore()
	{
		if (this.World.FactionManager.isGreaterEvil())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];
		local candidates_traveller = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.messenger" || bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee")
			{
				candidates_traveller.push(bro);
			}
		}

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		if (candidates_traveller.len() != 0)
		{
			this.m.Traveller = candidates_traveller[this.Math.rand(0, candidates_traveller.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"walker",
			this.m.Traveller != null ? this.m.Traveller.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Traveller = null;
	}

});

