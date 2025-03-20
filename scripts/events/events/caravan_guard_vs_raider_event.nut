this.caravan_guard_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		CaravanHand = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.caravan_guard_vs_raider";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]Vous vous attendez à ce que les hommes que vous engagez laissent leur ancienne vie derrière eux, mais parfois il n\'en est rien. Il semble que %caravanhand% et %raider% se connaissent bien : le caravanhand a déjà eu affaire au raider personnellement dans une sorte de bataille qui s\'est terminée sans vainqueur. Maintenant, ils cherchent à finir ce qu\'ils ont commencé il y a longtemps, les deux tombent au sol, lançant des coups de poing et de coude et quelques crachats si un œil ou une joue l\'exige. Vous séparez les deux vous-même, les éloignant l\'un de l\'autre et faisant clairement comprendre qu\'ils sont désormais des mercenaires et non des ennemis. Vous forcez les deux à se serrer la main, ce qu\'ils font. L\'ancien homme de main de la caravane acquiesce.%SPEECH_ON%Bien il reste %raider% maintenant.%SPEECH_OFF%Le pillard acquiesce en essuyant un peu de sang qui coule de son nez.%SPEECH_ON%Tu es plus fort que dans mon souvenir.%SPEECH_OFF%Les deux hommes partent ensemble pour s\'arranger, comme le font les hommes, leurs problèmes étant si facilement oubliés.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que le monde est petit...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CaravanHand.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.CaravanHand.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.CaravanHand.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.CaravanHand.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.CaravanHand.getName() + " souffre de " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 11,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Raider.getName() + " souffre de " + injury.getNameOnly()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]Vous vous attendez à ce que les hommes que vous engagez laissent leur ancienne vie derrière eux, mais parfois il n\'en est rien. Il semble que %caravanhand% et %raider% se connaissent bien : le caravanhand a déjà eu affaire au raider personnellement dans une sorte de bataille qui s\'est terminée sans vainqueur. Maintenant, ils cherchent à finir ce qu\'ils ont commencé il y a longtemps, les deux tombent au sol, lançant des coups de poing et de coude et quelques crachats si un œil ou une joue l\'exige. Vous séparez les deux vous-même, les éloignant l\'un de l\'autre et faisant clairement comprendre qu\'ils sont désormais des mercenaires et non des ennemis. Vous forcez les deux à se serrer la main, ce qu\'ils font. L\'ancien homme de main de la caravane acquiesce.%SPEECH_ON%Bien il reste %raider% maintenant.%SPEECH_OFF%Le pillard acquiesce en essuyant un peu de sang qui coule de son nez.%SPEECH_ON%Tu es plus fort que dans mon souvenir.%SPEECH_OFF%Les deux hommes partent ensemble pour s\'arranger, comme le font les hommes, leurs problèmes étant si facilement oubliés.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que le monde est petit...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CaravanHand.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.CaravanHand.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.CaravanHand.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.CaravanHand.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.CaravanHand.getName() + " souffre de " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 11,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Raider.getName() + " souffre de " + injury.getNameOnly()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_caravan = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 7 && bro.getBackground().getID() == "background.caravan_hand" && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_caravan.push(bro);
			}
		}

		if (candidates_caravan.len() == 0)
		{
			return;
		}

		local candidates_raider = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 7 && (bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.nomad") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_raider.push(bro);
			}
		}

		if (candidates_raider.len() == 0)
		{
			return;
		}

		this.m.CaravanHand = candidates_caravan[this.Math.rand(0, candidates_caravan.len() - 1)];
		this.m.Raider = candidates_raider[this.Math.rand(0, candidates_raider.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onDetermineStartScreen()
	{
		if (this.m.Raider.getBackground().getID() == "background.raider")
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"caravanhand",
			this.m.CaravanHand.getName()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getName()
		]);
	}

	function onClear()
	{
		this.m.CaravanHand = null;
		this.m.Raider = null;
	}

});

