this.wardogs_fight_each_other_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null,
		Otherbrother = null,
		Wardog1 = null,
		Wardog2 = null
	},
	function create()
	{
		this.m.ID = "event.wardogs_fight_each_other";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_37.png[/img]Une série d\'aboiements suivis de grognements sourds interrompt votre travail. Vous sortez de votre tente pour voir que les deux chiens de garde, %randomwardog1% et %randomwardog2% se battent. Ils ont verrouillé leurs mâchoires sur la nuque de l\'autre. Quelques frères tentent d\'intervenir, mais à chaque fois, les chiens de guere se séparent brièvement et s\'en prennent aux humains comme pour dire que ce combat est entre eux et eux seuls.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Laissez les chiens s\'en occuper eux-mêmes.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Que quelqu\'un sépare les chiens de guerre !",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndmaster%, tu es un maître de chien, occupe-toi de ça !",
						function getResult( _event )
						{
							return "I";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_37.png[/img]Vous choisissez de prendre du recul et de laisser la nature suivre son cours. Une fois la poussière retombée, vous vous avancez pour voir comment tout s\'est déroulé.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alors ?",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 20)
						{
							return "E";
						}
						else if (r <= 35)
						{
							return "F";
						}
						else
						{
							return "G";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_37.png[/img]Vous criez à %otherbrother% deséparer les deux chiens de guerre. Il prend un long bâton et l\'abaisse dans la mêlée furieuse. Les chiens glapissent lorsque le métal s\'interpose entre eux. L\'un d\'eux saisit le manche du bâton et l\'arrache, entraînant le frère dans la mêlée. L\'homme et la bête se confondent alors que tous les trois luttent pour leur propre survie, chacun prenant son tour pour combattre l\'autre. Lorsque la poussière retombe, vous faites l\'inventaire de ce qui est encore debout.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alors ?",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 10)
						{
							return "E";
						}
						else if (r <= 50)
						{
							return "F";
						}
						else if (r <= 90)
						{
							return "G";
						}
						else
						{
							return "H";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Otherbrother.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_37.png[/img]Malheureusement, les deux chiens sont morts. Ils sont morts la fourrure ensanglantée serrée dans leurs mâchoires, chacun partageant à la fois la victoire et la défaite. Vous dites à %randombrother% d\'aller enterrer les corps de peur que leur odeur n\'attire des bêtes encore plus furieuses.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pauvres bêtes",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog1.getIcon(),
					text = "Vous perdez " + _event.m.Wardog1.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog1);
				_event.m.Wardog1 = null;
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog2.getIcon(),
					text = "Vous perdez " + _event.m.Wardog2.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog2);
				_event.m.Wardog2 = null;
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_27.png[/img]La bataille terminée, vous demandez à %randombrother% de jeter un coup d\'oeil aux wardogs. Ils grognent lorsqu\'il s\'approche, mais c\'est tout ce qu\'ils font, car le combat est terminé pour eux. Il signale quelques dents cassées et ils boitent tout les deux, mais ils n\'ont rien de cassé. Avec le temps, ils seront comme neufs pour se battre. Espérons qu\'ils ne se battront pas entre eux à nouveau...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est dans leur nature.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_37.png[/img]Un wardog s\'éloigne de la mêlée en boitant, laissant derrière lui un clébard mort. Le fait que le vainqueur n\'ait même pas mangé ou essayé de manger le perdant montre tout ce que vous devez savoir sur l\'homonyme de ces animaux. Vous demandez à %randombrother% de s\'occuper du survivant pendant que d\'autres frères enterrent le corps du défunt.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pauvre bête.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog1.getIcon(),
					text = "Vous perdez " + _event.m.Wardog1.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog1);
				_event.m.Wardog1 = null;
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_34.png[/img]%otherbrother% parvient à séparer les deux chiens de garde avant qu\'ils ne s\'entretuent. Malheureusement, il a payé un lourd tribut de morsures et de griffures. Il survivra, mais on ne peut s\'empêcher de remarquer qu\'il est très capricieux et méfiant envers les chiens maintenant.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce sont des bêtes féroces, c\'est sûr.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Otherbrother.getImagePath());
				local injury = _event.m.Otherbrother.addInjury(this.Const.Injury.DogBrawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Otherbrother.getName() + " souffre de " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_27.png[/img]Vous ordonnez à %houndmaster% le maître des chiens de faire quelque chose. Il acquiesce et s\'avance, marchant calmement entre les deux chiens de combat. Ils aboient et grognent l\'un contre l\'autre, mais tous deux s\'arrêtent pour regarder l\'homme qui entre. L\'un grogne, mais s\'assoit. L\'autre recule, sa queue remuant furieusement, mais il y a toujours du feu dans ses yeux. Le maître des chiens s\'accroupit et les caresse tous les deux sur la tête. L\'un des chiens se baisse, et l\'autre fait de même. L\'homme rapproche lentement les chiens, en touchant pratiquement leurs nez, puis leur chuchote à tous les deux. Lentement, mais sûrement, l\'énergie bestiale quitte les chiens et leurs dispositions adoucies semblent plus appropriées pour surveiller des enfants que pour combattre dans une bande de mercenaires. Le maître des chiens se relève et les chiens le suivent joyeusement. Il hoche la tête.%SPEECH_ON%Juste une petite dispute entre chiens, heh.%SPEECH_OFF%Il s\'en va tandis que le reste de la compagnie regarde bouche bée, comme s\'ils venaient d\'assister à une sorte de procession de sorcellerie druidique.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un maître de son art, en effet.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_houndmaster = [];
		local candidates_other = [];
		local candidates_wardog = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates_houndmaster.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();

		foreach( item in stash )
		{
			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				candidates_wardog.push(item);
			}
		}

		if (candidates_wardog.len() < 2)
		{
			return;
		}

		this.m.Otherbrother = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_houndmaster.len() != 0)
		{
			this.m.Houndmaster = candidates_houndmaster[this.Math.rand(0, candidates_houndmaster.len() - 1)];
		}

		local r = this.Math.rand(0, candidates_wardog.len() - 1);
		this.m.Wardog1 = candidates_wardog[r];
		candidates_wardog.remove(r);
		r = this.Math.rand(0, candidates_wardog.len() - 1);
		this.m.Wardog2 = candidates_wardog[r];
		this.m.Score = candidates_wardog.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Otherbrother.getName()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getNameOnly() : ""
		]);
		_vars.push([
			"randomwardog1",
			this.m.Wardog1 != null ? this.m.Wardog1.getName() : ""
		]);
		_vars.push([
			"randomwardog2",
			this.m.Wardog2 != null ? this.m.Wardog2.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
		this.m.Otherbrother = null;
		this.m.Wardog1 = null;
		this.m.Wardog2 = null;
	}

});

