this.desert_bugbite_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy = null
	},
	function create()
	{
		this.m.ID = "event.desert_bugbite";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Alors qu'il est en train de regarder des cartes et de faire son inventaire, %bitbro% crie soudainement et tombe dans le sable. Il se tape sur les jambes et un scorpion noir s'envole. Un autre mercenaire hurle et coupe l'insecte en deux avec une férocité que vous ne lui avez jamais vue utiliser sur le champ de bataille. %bitbro% serre les dents en enlevant ses bottes. On dirait que quelqu'un a enfoncé un clou dans sa cheville. Il dit qu'il se sent étourdi, mais que ce n'est pas trop grave.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Regardez où vous mettez les pieds.",
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

