this.training_accident_event <- this.inherit("scripts/events/event", {
	m = {
		ClumsyGuy = null,
		OtherGuy1 = null,
		OtherGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.training_accident";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 16.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au moins, il ne s\'est pas suicidé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.ClumsyGuy.getImagePath());
				local r = this.Math.rand(1, 6);
				local injury;

				if (r == 1)
				{
					this.Text = "[img]gfx/ui/events/event_19.png[/img]Pendant son entraînement, %clumsyguy%, qui n\'est pas le plus adroit des hommes, parvient à se blesser avec sa propre arme.";
					injury = _event.m.ClumsyGuy.addInjury(this.Const.Injury.Accident1);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.ClumsyGuy.getName() + " souffre de " + injury.getNameOnly()
						}
					];
				}
				else if (r == 2)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]En voyage, vous aimez garder vos hommes frais et dispos avec un exercice d\'entraînement occasionnel. Malheureusement, en s\'exerçant à une riposte, %clumsyguy% a réussi à se planter dans le pied. L\'homme semble encore plus blessé par cet embarras.";
					_event.m.ClumsyGuy.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.ClumsyGuy.getName() + " souffre de blessures légères"
					});
				}
				else if (r == 3)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]En faisant l\'inventaire, vous demandez à %clumsyguy% de vous apporter un carquois de flèches. Ce court et simple voyage se termine lorsque l\'homme trébuche sur un rocher et se transforme en pelote d\'épingles.";
					injury = _event.m.ClumsyGuy.addInjury(this.Const.Injury.Accident2);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.ClumsyGuy.getName() + " souffre de " + injury.getNameOnly()
						}
					];
				}
				else if (r == 4)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]Vous trouvez un %clumsyguy% plutôt ivre en train de soigner le côté de son visage. %otherguy1% explique que l\'idiot a essayé de danser sur une série de rochers, avant de tomber et de se frapper au visage. Super.";
					injury = _event.m.ClumsyGuy.addInjury(this.Const.Injury.Accident3);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.ClumsyGuy.getName() + " souffre de " + injury.getNameOnly()
						}
					];
				}
				else if (r == 5)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]Pendant que %otherguy1% et %otherguy2% s\'entraînent, %clumsyguy% s\'interpose entre eux, leur donnant des leçons sur la façon de faire correctement tout en ne regardant pas où il va. Une épée en bois errante croise son visage et un instant plus tard, l\'idiot est inconscient.";
					injury = _event.m.ClumsyGuy.addInjury(this.Const.Injury.Accident3);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.ClumsyGuy.getName() + " souffre de " + injury.getNameOnly()
						}
					];
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]Il semble que %clumsyguy% ait un peu trop bu avant de participer au combat d\'aujourd\'hui. Comme on vous l\'a expliqué, l\'ivrogne a confondu un arbre avec un combattant ennemi. Il a ensuite, toujours selon l\'histoire, chargé l\'arbre, s\'assommant au passage.";
					_event.m.ClumsyGuy.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.ClumsyGuy.getName() + " souffre de blessures légères"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if ((bro.getSkills().hasSkill("trait.clumsy") || bro.getSkills().hasSkill("trait.drunkard") || bro.getSkills().hasSkill("trait.addict")) && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.ClumsyGuy = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 8;

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.ClumsyGuy.getID())
			{
				this.m.OtherGuy1 = bro;
				break;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.ClumsyGuy.getID() && bro.getID() != this.m.OtherGuy1.getID())
			{
				this.m.OtherGuy2 = bro;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"clumsyguy",
			this.m.ClumsyGuy.getName()
		]);
		_vars.push([
			"otherguy1",
			this.m.OtherGuy1.getName()
		]);
		_vars.push([
			"otherguy2",
			this.m.OtherGuy2.getName()
		]);
	}

	function onClear()
	{
		this.m.ClumsyGuy = null;
		this.m.OtherGuy1 = null;
		this.m.OtherGuy2 = null;
	}

});

