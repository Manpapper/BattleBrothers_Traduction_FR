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
					Text = "À least he didn\'t kill himself.",
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
					this.Text = "[img]gfx/ui/events/event_19.png[/img]While training, %clumsyguy%, not being the most dexterous fellow, manages to hurt himself with his own weapon.";
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
					this.Text = "[img]gfx/ui/events/event_34.png[/img]Traveling, you like to keep your men fresh with the occasional training exercise. Unfortunately, while practicing a riposte, %clumsyguy% managed to stick himself in the foot. The man appears even more hurt by the embarrassment.";
					_event.m.ClumsyGuy.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.ClumsyGuy.getName() + " souffre de blessures légères"
					});
				}
				else if (r == 3)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]While doing inventory, you ask %clumsyguy% to carry over a quiver of arrows. The short, simple journey ends with the man tripping over a rock and turning himself into a pincushion.";
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
					this.Text = "[img]gfx/ui/events/event_34.png[/img]You find a rather drunk %clumsyguy% nursing the side of his face. %otherguy1% explains that the idiot tried to dance over a series of rocks, only to fall and bash himself in the face. Great.";
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
					this.Text = "[img]gfx/ui/events/event_34.png[/img]While %otherguy1% and %otherguy2% train, %clumsyguy% comes in between them, lecturing on how to do it properly while at the same time not watching where he\'s going. A wayward wooden sword crosses paths with his face and a moment later the idiot is unconscious.";
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
					this.Text = "[img]gfx/ui/events/event_34.png[/img]It appears %clumsyguy% got a little too much to drink before partaking in today\'s sparring. As the story was explained to you, the drunkard mistakened a tree for an enemy combatant. He then, again as the story goes, proceeded to charge said tree, knocking himself out in the process.";
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

