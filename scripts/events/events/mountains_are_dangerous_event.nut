this.mountains_are_dangerous_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.mountains_are_dangerous";
		this.m.Title = "In the mountains...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]Bien que profondément ancrés dans les montagnes, vous pouvez voir les sommets de la cordillère s\'étendre plus loin encore, chacun s\'insérant entre les vallées des alentours. C\'est un spectacle magnifique, mais aussi épuisant. La randonnée à travers les cols - et parfois la recherche de cols par soi-même - a été difficile pour les hommes. Les pentes de pierres blanches, de sédiments et de gravier indiscipliné obligent vos hommes à grimper à quatre pattes. Chaque éboulis ramène les fatigués d\'où ils viennent, mettant à l\'épreuve la détermination de ceux qui n\'ont pas envie de refaire autant de voyages.\n\n Et pourtant, autour de vous, des chèvres de montagne se promènent. L\'une d\'entre elles bondit sur un rocher avec une facilité déconcertante, tandis qu\'une autre se fraye un chemin dans l\'herbe sèche entre deux bêlements confus. Des ponts de pierre, en porte-à-faux avec la géologie du jurassique, portent les têtes grimaçantes de lions de montagne curieux. On a l\'impression qu\'ils ont déjà vu votre espèce. Ils savent qu\'il ne faut pas attaquer, mais ils vous suivent quand même. Peut-être que l\'un d\'entre vous tombera et se cassera quelque chose et que les mutilés seront laissés derrière parce que transporter des blessés dans un tel endroit est une mort pour deux.\n\n En faisant le point avec vos hommes, vous constatez que beaucoup souffrent de blessures. Des tibias douloureux. Mollets douloureux. Genoux douloureux. Probablement quelques os cassés, mais rien de fatal. Seuls les plus forts et les plus agiles peuvent se frayer un chemin en toute sécurité dans un endroit comme celui-ci, et en effet, ils sont généralement les premiers à atteindre le sommet à chaque escalade.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maudit soit cet endroit !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveEffect();
			}

		});
	}

	function giveEffect()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];
		local lowestChance = 9000;
		local lowestBro;
		local applied = false;

		foreach( bro in brothers )
		{
			local chance = bro.getHitpoints() + 20;

			if (bro.getSkills().hasSkill("trait.dexterous"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.sure_footing"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.strong"))
			{
				chance = chance + 20;
			}

			for( ; this.Math.rand(1, 100) < chance; )
			{
				if (chance < lowestChance)
				{
					lowestChance = chance;
					lowestBro = bro;
				}
			}

			applied = true;
			local injury = bro.addInjury(this.Const.Injury.Mountains);
			result.push({
				id = 10,
				icon = injury.getIcon(),
				text = bro.getName() + " souffre de " + injury.getNameOnly()
			});
		}

		if (!applied && lowestBro != null)
		{
			local injury = lowestBro.addInjury(this.Const.Injury.Mountains);
			result.push({
				id = 10,
				icon = injury.getIcon(),
				text = lowestBro.getName() + " souffre de " + injury.getNameOnly()
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains || this.World.Retinue.hasFollower("follower.scout"))
		{
			return;
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

