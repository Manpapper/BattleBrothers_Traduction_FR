this.anatomist_exhumes_hero_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Graver = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_exhumes_hero";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Dans la ville de %nombreux%, vous avez entendu parler d\'un héros local qui a été enterré récemment. Pour vous, c\'est une nouvelle sans intérêt. L\'homme n\'était probablement même pas un héros si on le compare à quoi que ce soit d\'autre qu\'un tueur de rats, alors vous n\'y faites pas attention. Naturellement, les anatomistes sont d\'un autre genre, et prennent la nouvelle comme des mouches sur le cul d\'un cadavre. Ils proposent à la compagnie de déterrer le cadavre de ce héros afin de voir par sa forme et sa composition ce qui différencie cet \"élément héroïque\" de l\'homme ordinaire. %anatomiste% explique.%SPEECH_ON%Le cadavre d\'un héros n\'est pas juste un simple cadavre. Il est animé par quelque chose d\'entier, un certain charme qui le sépare du reste d\'entre nous.%SPEECH_OFF%Ayant rouler votre bosse, vous assurez aux anatomistes que le cadavre ressemblera à n\'importe quel autre. Ils sont cependant très attachés à ce que l\'on jette quand même un coup d\'œil, même si cela offense la foule.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, allons le déterrer.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Pas de déterrage de tombes aujourd\'hui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Graver != null)
				{
					this.Options.push({
						Text = "%graver%, Que faites-vous ici?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Après de nombreuses discussions, les anatomistes arrivent a leurs fins et vous acceptez d\'aller jusqu\'à la tombe. Le corps froid d\'un prétendu héros vous attends à l\'intérieur. Vous vous faufilez dans le cimetière comme une bande de gamins sur le point de faire une bêtise, ce qui correspond assez bien à la réalité. La tombe du héros est assez facile à repérer, car elle est ornée de fleurs et d\'autres subtilités.\n\n%anatomiste% dégage les fleurs d\'un coup de pied et jette le jouet d\'un enfant à travers le cimetière. Il plante rapidement sa pelle et commence à creuser. Ça ne prend pas longtemps, le sol ayant été récemment remué. Quelques objets gisent dans la tombe, et à côté d\'eux se trouve le corps lui-même: un homme ordinaire au visage pâle. Il est soulevé et sorti de la tombe, les anatomistes le jetant par-dessus bord comme un morceau de contreplaqué et, lorsqu\'il atterrit dans l\'herbe, ils poursuivent leur tâche comme des gremlins, le découpant et le fouillant avec une ferveur inquiétante. Lorsqu\'ils ont terminé, ils remettent le corps dans la tombe, sa forme étant plus déchiquetée qu\'auparavant. Ils se plaignent que vous aviez peut-être raison, que le corps d\'un héros ne présente aucun aspect inhabituel. Mais plutôt que de se ranger à l\'avis d\'un mercenaire inculte, ils concluent qu\'il n\'était peut-être pas du tout un héros et que leur recherche devra se poursuivre. Vous êtes heureux d\'avoir eu raison.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dégueulasse. Partons d\'ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.improveMood(1.0, "Got to examine a hero\'s cadaver");
						bro.worsenMood(0.5, "Was misled about the peculiarities of said cadaver");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						bro.addXP(150, false);
						bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+150[/color] Experience"
						});
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Après de nombreuses tractations, les anatomistes brisent vos maigres défenses et vous acceptez d\'aller chercher le corps froid et mort du héros local dans la tombe. Vous vous faufilez dans le cimetière comme une bande de gamins sur le point de faire une bêtise, ce qui correspond assez bien à la réalité. Vous arrivez au cimetière et vous demandez si l\'un d\'entre eux connaît le nom du héros.%anatomist% dit qu\'il pense que c\'était, ironiquement, Mortimer.\n\nVous trouvez la tombe et commencez à creuser, mais lorsque vous arrivez au fond, vous trouvez juste un chat mort, recroquevillé, gris et décrépit, avec plus de vers que de poils. Au moment où les anatomistes le brandissent, un cri retentit depuis les arbustes qui se trouvent juste derrière vous. Vous vous retournez pour voir un jeune garçon en train de pleurer et de montrer du doigt. Avant que vous puissiez l\'attraper, il se retourne et s\'enfuit en criant une prose plutôt descriptive de vos actions. Vous entendez les murmures de la foule qi vous fait face, leurs paroles se perdent dans une certaine frénésie, mais on peut encore entendre resonner le nom de la compagnie %companyname% malgré le vacarme que font les fourches lorsqu\'elles s\'entrechoquent. Vous vous retournez pour dire aux anatomistes d\'arrêter de creuser, mais vous constatez qu\'ils sont déjà en train de courir pour sauver leur peau tout en étant à mi-chemin de la sortie du cimetière. En maudissant, vous les rejoignez dans cette retraite déshonorante puis vous quittez la ville.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ils m\'ont mis dans une sacrée merde...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Your company was caught graverobbing");
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Your relation to " + f.getName() + " has suffered"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.worsenMood(0.75, "Was unable to exhume an unusual corpse");

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

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_46.png[/img]{%graver% est désormais à vos côtés. L\'habitué du cimetière enfonce un pouce dégoûtant dans sa poitrine.%SPEECH_ON%Vous voulez déterrer un cadavre? Je suis votre homme.%SPEECH_OFF%Avec son expertise à portée de main, vous décidez de suivre les plans sinistres de l\'anatomiste. Vous trouvez le cimetière et le traversez à la recherche de la tombe du héros. L\'endroit est un terrain misérable, vous finissez par trouver un emplacement couvert de fleurs fraîches et d\'autres ornements que les hommes piétinent et chassent d\'un coup de pied gracieux. Le travail de fond est rapidement entamé et, avec %gravier% sous la main, le corps est déterré à une vitesse incroyable. Les anatomistes se sont mis au travail sur le cadavre, penchés sur lui et se murmurant les uns aux autres, leurs formes recroquevillées et enveloppées comme des buses. Pendant ce temps, %graver% fouille dans la tombe elle-même avant de trouver une arme qui était cachée dans un coin. C\'est une belle trouvaille, tout bien considéré, et cela rend presque cette série d\'événements intéressante. Vous vous retournez pour voir les anatomistes repousser le corps dans la tombe, ses membres se déformant et se balançant avec raideur dans tous les sens, tandis que le visage du héros s\'immobilise, les yeux ouverts, fixant le sol remué où les vers apparents cherchent de l\'air. Tout le monde ayant obtenu ce dont il avait besoin, vous quittez rapidement l\'endroit avant que les habitants ne se montrent et vous lynchent jusqu\'au dernier.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.improveMood(1.0, "Got to examine a hero\'s unusual cadaver");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						bro.addXP(150, false);
						bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+150[/color] Experience"
						});
					}
				}

				_event.m.Graver.improveMood(1.0, "Put his grave-exhuming skills to use");

				if (_event.m.Graver.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Graver.getMoodState()],
						text = _event.m.Graver.getName() + this.Const.MoodStateEvent[_event.m.Graver.getMoodState()]
					});
				}

				local weaponList = [
					"arming_sword",
					"hand_axe",
					"military_pick",
					"boar_spear"
				];
				local item = this.new("scripts/items/weapons/" + weaponList[this.Math.rand(0, weaponList.len() - 1)]);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Graver.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local graver_candidates = [];
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				graver_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (graver_candidates.len() > 0)
		{
			this.m.Graver = graver_candidates[this.Math.rand(0, graver_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() > 1)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 10 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"graver",
			this.m.Graver != null ? this.m.Graver.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Graver = null;
		this.m.Town = null;
	}

});

