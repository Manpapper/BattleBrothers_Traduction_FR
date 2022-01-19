this.civilwar_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_deserter";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img]{En chemin, vous rencontrez deux soldats de l\'armée de %noblehouse% et ils se préparent à pendre ce qui semble être l\'un des leurs. La tête de l\'homme est passée dans un noeud coulant, mais en vous voyant, il crie.%SPEECH_ON%Ils voulaient que je tue des enfants ! C\'est ce que je reçois pour ne pas suivre les ordres ?%SPEECH_OFF%%randombrother% vous regarde avec un visage qui signifie \'peut-être que nous pouvons faire quelque chose\'. | Vous trouvez deux hommes de l\'armée de %noblehouse% en train d\'attacher un homme qui a les yeux bandés. Curieux, vous demandez quel était son crime. L\'un des bourreaux rit.%SPEECH_ON%Il a reçu l\'ordre de brûler un petit village et il a refusé. Vous n\'opposez jamais de refus à la noblesse, de peur que ceci n\'arrive.%SPEECH_OFF%L\'homme aux yeux bandés crache.%SPEECH_ON%Au diable vous tous. J\'aurai au moins ma dignité et mon honneur jusqu\'au bout.%SPEECH_OFF% | Sur le côté du chemin, vous voyez un homme enrouler une corde autour d\'une branche d\'arbre. Un deuxième homme pousse un prisonnier aux yeux bandés vers l\'avant, lui passant le noeud autour du cou. Les bourreaux vous voient et lèvent la main.%SPEECH_ON%Reculez, mercenaires. Cet homme doit être exécuté sous les ordres de %noblehouse%. Interférez, et vous serez traité de la même manière.%SPEECH_OFF%Le prisonnier aboie.%SPEECH_ON%Ils voulaient que je tue des femmes et des enfants. C\'est le prix que je paie pour ignorer de telles ordres, mais au moins je quitterai ce monde horrible avec mon honneur intact.%SPEECH_OFF% | Le chemin s\'ouvre sur un homme enchaîné assis dans l\'herbe tandis que deux hommes enfilent avec colère une corde sur une branche d\'arbre. Ils la testent avec quelques bonnes tractions avant de hocher la tête et de mettre un baril en dessous, vraisemblablement pour que le prisonnier puisse se tenir debout. Le prisonnier vous voit et vous appelle.%SPEECH_ON%Mercenaires, sauvez-moi ! Tout ce que j\'ai fait, c\'est refuser de réduire en cendres un temple !%SPEECH_OFF%Un des bourreaux donne un coup de pied à l\'homme.%SPEECH_ON%Ce temple abritait des rebelles, des rebelles qui ont tué notre lieutenant, imbécile ! Vous méritez ce sort plus que quiconque. Si %noblehouse% doit gagner cette guerre, nous ne pouvons pas avoir des rats comme vous parmi nous.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Libérez cet homme!",
					function getResult( _event )
					{
						local roster = this.World.getTemporaryRoster();
						_event.m.Dude = roster.create("scripts/entity/tactical/player");
						_event.m.Dude.setStartValuesEx([
							"deserter_background"
						]);
						_event.m.Dude.setTitle("the Honorable");
						_event.m.Dude.getBackground().m.RawDescription = "Autrefois un soldat d\'une armée noble, %name% a failli être pendu pour avoir refusé des ordres, jusqu\'à ce qu\'il soit sauvé par vous et %companyname%.";
						_event.m.Dude.getBackground().buildDescription(true);

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
						}

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
						}

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Ce n\'est pas notre affaire.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Vous ordonnez aux bourreaux de laisser partir l\'homme. Ils rient et sortent leurs épées, mais c\'est à peu près la dernière chose qu\'ils font alors que %nom de l\'entreprise% s\'abattent sur eux avec une fureur libératrice, attaquant les deux soldats en quelques secondes à peine. Le prisonnier vous remercie et, en échange de son sauvetage, vous propose de vous servir au combat. | Vous ne tolérerez pas une telle exécution et ordonnez aux %companyname% d\'intervenir. Ils dégainent rapidement leurs armes et descendent sur les soldats, les massacrant en un instant. Le prisonnier libéré tombe à genoux devant vous.%SPEECH_ON%S\'il vous plaît, laissez-moi combattre dans vos rangs, c\'est le moins que je puisse offrir !%SPEECH_OFF% | Vous commandez aux %companyname% de sauver le prisonnier. C\'est une étrange série d\'images et de sons, de voir des hommes qui se croyaient les bourreaux être si soudainement massacrés. De tels revers de fortune font jaillir des cris sauvages et féminins. Vos hommes auraient fait plus vite s\'ils n\'avaient pas essayé de s\'enfuir, mais un homme qui a l\'intention de se sauver meurt souvent plus lentement. Le prisonnier, quant à lui, tombe à vos pieds et vous fait allégeance.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Bienvenue chez %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Rentrez chez vous avec votre famille, soldat.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationUnitKilled);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Vous ordonnez de sauver l\'homme. L\'un des soldats tire son épée et est immédiatement abattu pour sa confiance mal placée. L\'autre soldat, apparemment plus vif d\'esprit, s\'est déjà enfui. Nul doute qu\'il dira à %noblehouse% ce que vous avez fait ici. Le prisonnier secouru vient personnellement vers vous, mettant un genou à terre en s\'inclinant.%SPEECH_ON%Merci, mercenaire. Vous avez ma lame pour ce jour et jusqu\'à mon dernier souffle.%SPEECH_OFF% | Dans votre esprit, il est peu probable que les deux bourreaux abandonnent leurs nobles drapeaux pour vous rejoindre. Mais il est fort probable que le prisonnier combattrait à vos côtés, si vous le libériez. Alors vous ordonnez son sauvetage. L\'un des soldats tire son épée et prête allégeance au %noblehouse%. C\'est la dernière chose qu\'il fait. L\'autre soldat s\'enfuit. Vous auriez peut-être pu le recruter, mais il est peu probable qu\'il revienne étant donné le meurtre rapide de son partenaire. Très probablement, il informera ses supérieurs de vos actions ici.\n\n Vous allez voir le prisonnier libéré. Il s\'incline précipitamment et propose de se battre pour le %companyname%. | Vous ordonnez aux soldats de laisser partir l\'homme. L\'un d\'eux rit et serre simplement l\'étau autour du cou et commence à le pendre. %randombrother% saute en avant et jette un bourreau au sol. Il lui frappe le visage avec une pierre pendant que le deuxième soldat s\'enfuit. Nul doute qu\'il dira à ses commandants ce que vous avez fait ici.\n\n Libéré, le prisonnier vient vous voir personnellement et s\'incline, offrant allégeance en échange de son sauvetage.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Bienvenue chez %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Rentrez chez vous avec votre famille, soldat.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Tué un de leurs hommes");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Bien que vous ne puissiez pas nécessairement reprocher à l\'homme d\'avoir ignoré ses ordres, la décision était la sienne, pas la vôtre, tout comme sa punition sera la sienne et non la vôtre. Vous commandez au %companyname% de continuer à marcher. | Vous n\'avez aucune raison d\'impliquer les %companyname% dans la politique des nobles qui se querellent. Le prisonnier hoche la tête, compréhensif. Il lève la tête haute avant qu\'ils ne le pendent. | Les bourreaux vous jettent un coup d\'oeil, sentant peut-être que vous pourriez intervenir pour ruiner complètement leur journée. Au lieu de cela, vous dites au prisonnier que c\'est son choix qui l\'a amené ici. Il hoche la tête solennellement. Les bourreaux se précipitent pour le pendre, de peur que ce dangereux étranger qui croise leur chemin ne change d\'avis.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Sa guerre n\'était pas la nôtre.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.deserter")
					{
						bro.worsenMood(0.75, "Tu n\'as pas aidé un déserteur, lieutenant");

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
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Dude = null;
	}

});

