this.brawler_vs_brawler_event <- this.inherit("scripts/events/event", {
	m = {
		Brawler1 = null,
		Brawler2 = null
	},
	function create()
	{
		this.m.ID = "event.brawler_vs_brawler";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Tandis que vous vous asseyez avec vos hommes autour du feu, une discussion au-delà des flammes commence à devenir un peu bruyante. %brawler% le bagarreur se lève et montre sa poitrine en riant.%SPEECH_ON%Toi ? Tu penses que tu peux me battre ?%SPEECH_OFF%L\'autre bagarreur, %brawler2%, se lève d\'un bond.%SPEECH_ON%Te battre ? Je pourrais te mettre sous terre avec une main, espèce d\'imbécile !%SPEECH_OFF%La mention du fait que les poings de %brawler% n\'étaient pas assez puissant pour démolir des murs de briques déclenche un combat brutal. Les bagarreurs s\'agrippent l\'un à l\'autre et utilisent leurs mains libres pour faire des uppercut à la chaîne. Chaque coup de poing atterrit avec une férocité déconcertante. Aucun homme ne pourrait encaisser autant de dégâts et rester sur leurs pieds, mais ici vous êtes témoins de deux hommes qui le font. Vous ordonnez à la compagnie d\'interrompre le combat. %brawler% se pince une narine et fait couler du sang par l\'autre. Il hausse les épaules.%SPEECH_ON%On s\'amusait juste un peu, monsieur.%SPEECH_OFF%Remettant une épaule en place, %brawler2% acquiesce.%SPEECH_ON%Oui, il n\'y a pas de mal à ça.%SPEECH_OFF%Vous regardez les deux hommes se serrer la main et se taper sur l\'épaule, chacun félicitant l\'autre pour la qualité de ses coups.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est une façon de se réconcilier.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler1.getImagePath());
				this.Characters.push(_event.m.Brawler2.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Brawler1.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Brawler1.getName() + " souffre de " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Brawler1.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Brawler1.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Brawler1.improveMood(2.0, "Bonded with " + _event.m.Brawler2.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Brawler1.getMoodState()],
					text = _event.m.Brawler1.getName() + this.Const.MoodStateEvent[_event.m.Brawler1.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Brawler2.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Brawler2.getName() + " suffers " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Brawler2.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Brawler2.getName() + " suffers light wounds"
					});
				}

				_event.m.Brawler2.improveMood(2.0, "Bonded with " + _event.m.Brawler1.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Brawler2.getMoodState()],
					text = _event.m.Brawler2.getName() + this.Const.MoodStateEvent[_event.m.Brawler2.getMoodState()]
				});
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

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.brawler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local idx = this.Math.rand(0, candidates.len() - 1);
		this.m.Brawler1 = candidates[idx];
		candidates.remove(idx);
		idx = this.Math.rand(0, candidates.len() - 1);
		this.m.Brawler2 = candidates[idx];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brawler",
			this.m.Brawler1.getNameOnly()
		]);
		_vars.push([
			"brawler2",
			this.m.Brawler2.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Brawler1 = null;
		this.m.Brawler2 = null;
	}

});

