this.sickness_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy = null
	},
	function create()
	{
		this.m.ID = "event.sickness";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img] {The swamp clutches at your every step, so wanting you to stay it is. While your boots sink into the mire, %someguy% turns and suddenly heaves, adding his breakfast to the bog. You turn to see another brother in the distance double over, loosing from his mouth a great spew that has you choking back some vomit yourself. The %companyname% express their collective discomfort as more men wretch and gag. This truly is no place for man to be. | While teeming with disgusting forms of life, the swamp actually smells of noxious death. Seemingly toxic steam undulates off the bog\'s still currents. It burns your eyes and throat and poisons all your foods with ill-tastes. What foul things would dare live here? You see toads and snakes and critters that certainly had the devil\'s touch in their birthing. The %companyname% are uniformly falling sick in this damned place. Only the strong may have the gut to bear it, everyone else is already heaving and seeing things which are not there.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn this place!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveSicknessEffect();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_08.png[/img] Your breath appears before you as though it were carried in purses of grey. It started slowly, this pain. Spits of snow. Winds that had come from ancient glaciers. One step sank your foot deep into the white powder and it was then you knew the rest of the journey would be a test of endurance.\n\nYou wonder how the men of old did it, living in these parts. They sat around campfires with all the world out to get them. Sat in the darkness surrounded by flurries of ice. Sat in isolation. They were born here, that must have been their trick. Ignorance was their warmth. Only a man who knows no better could live in a place such as this.\n\nThe men of the %companyname% stagger and fall and don\'t get back up with quite the speed they used to. A few have taken to coughing fits and others look about ready to succumb to exhaustion. Only the strongest of the bunch carry on with no problem. It is those men who surely share a link with the ancestors of this horrid land.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn this place!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveSicknessEffect();
			}

		});
	}

	function giveSicknessEffect()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];
		local lowestChance = 9000;
		local lowestBro;
		local applied = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("effects.sickness"))
			{
				continue;
			}

			local chance = bro.getHitpoints() + 20;

			if (bro.getSkills().hasSkill("trait.strong"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.tough"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.lucky"))
			{
				chance = chance + 20;
			}

			if (this.m.SomeGuy.getID() != bro.getID() && this.Math.rand(1, 100) < chance)
			{
				if (chance < lowestChance)
				{
					lowestChance = chance;
					lowestBro = bro;
				}

				continue;
			}

			applied = true;
			local effect = this.new("scripts/skills/injury/sickness_injury");
			bro.getSkills().add(effect);
			result.push({
				id = 10,
				icon = effect.getIcon(),
				text = bro.getName() + " is sick"
			});
		}

		if (!applied && lowestBro != null)
		{
			local effect = this.new("scripts/skills/injury/sickness_injury");
			lowestBro.getSkills().add(effect);
			result.push({
				id = 10,
				icon = effect.getIcon(),
				text = lowestBro.getName() + " is sick"
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		if (this.World.Retinue.hasFollower("follower.scout"))
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Swamp && currentTile.Type != this.Const.World.TerrainType.Snow && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		this.m.SomeGuy = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"someguy",
			this.m.SomeGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Swamp)
		{
			return "A";
		}
		else if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.SomeGuy = null;
	}

});

