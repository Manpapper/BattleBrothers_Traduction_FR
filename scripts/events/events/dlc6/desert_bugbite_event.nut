this.desert_bugbite_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy = null
	},
	function create()
	{
		this.m.ID = "event.desert_bugbite";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{While standing around looking at maps and taking inventory, %bitbro% suddenly yells out and falls over in the sand. He slaps at his legs and a black scorpion goes soaring. Another sellsword screams and chops the bug in half with the sort of ferocity you\'ve never even seen him use on the battlefield. %bitbro% clenches his teeth as he takes off his boots. It looks like someone jammed a nail into his ankle. He says he\'s feeling woozy, but it\'s not too serious.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Watch where you step.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/effects_world/exhausted_effect");
				_event.m.SomeGuy.getSkills().add(effect);
				_event.m.SomeGuy.worsenMood(1.0, "Got stung by a scorpion");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.SomeGuy.getName() + " is exhausted"
				});
				this.Characters.push(_event.m.SomeGuy.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert || currentTile.HasRoad || this.World.Retinue.hasFollower("follower.scout"))
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
		local lowestChance = 9000;
		local lowestBro;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("effects.exhausted"))
			{
				continue;
			}

			local chance = bro.getHitpointsMax();

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

			if (bro.m.Ethnicity == 1)
			{
				chance = chance + 20;
			}

			if (chance < lowestChance)
			{
				lowestChance = chance;
				lowestBro = bro;
			}
		}

		if (lowestBro == null)
		{
			return;
		}

		this.m.SomeGuy = lowestBro;
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bitbro",
			this.m.SomeGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.SomeGuy = null;
	}

});

