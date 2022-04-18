this.desert_fall_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy = null
	},
	function create()
	{
		this.m.ID = "event.desert_fall";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Alors que vous descendez la pente d\'une dune, %fallbro% perd pied et commence à glisser vers le bas. Il crie à l\'aide et se débat en dégringolant. Chaque culbute prend de la vitesse et d\'amplitude, chaque roulement des membres semble l\'élever plus haut dans les airs que la précédente. Malgré le caractère soyeux et glissant de la pente de la dune, le fond de sa vallée est un firmament dur et l\'épée s\'écrase dessus jusqu\'à ce qu\'il s\'arrête complètement. Il n\'est pas mort mais s\'en sort un peu amoché, avec des éraflures, des bleus, des brûlures et un soupçon d\'embarras.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Attention!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.SomeGuy.worsenMood(1.0, "Il s\'est blessé à la jambe en glissant sur une dune de sable.");
				local injury = _event.m.SomeGuy.addInjury([
					{
						ID = "injury.bruised_leg",
						Threshold = 0.25,
						Script = "injury/bruised_leg_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.SomeGuy.getName() + " souffre de " + injury.getNameOnly()
					}
				];
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
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local lowestChance = 9000;
		local lowestBro;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("injury.bruised_leg"))
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
			"fallbro",
			this.m.SomeGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.SomeGuy = null;
	}

});

