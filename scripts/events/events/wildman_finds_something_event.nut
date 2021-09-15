this.wildman_finds_something_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.wildman_finds_something";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Alors que vous essayez de ne pas perdre votre sang-froid devant le nombre de branches basses qui vous tombent dessus, %otherguy% se précipite à vos côtés et vous dit %wildman% que le sauvage s\'est enfui. Vous vous retournez pour voir le reste des hommes aussi confus que vous. Levant le poing pour faire taire la compagnie, la forêt vous rend votre ordre de silence avec des gazouillis sourds d\'oiseaux lointains et le bourdonnement d\'une abeille ou d\'une guêpe quelque part dans l\'ombre.\n\nSecouant la tête, vous décidez de poursuivre la marche. Quelques heures plus tard, le sauvage surgit d\'un buisson que vous étiez sur le point de fendre avec une machette. Il a une brassée d\'objets divers à la main. Vous n\'avez aucune idée de l\'endroit où il a trouvé ces objets, mais vous demandez aux hommes de passer en revue les trouvailles. %wildman% reprend son rang comme si de rien n\'était. Vous regardez l\'homme et le surprenez en train de fixer un papillon à son doigt. Lorsque vous le regardez à nouveau, le papillon a disparu et l\'homme est en train d\'avaler quelque chose. %otherguy% vous fait un rapport sur ce qu\'il a apporté.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Où les a-t-il trouvées ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				local item;
				local items = 0;

				for( local maxitems = this.Math.rand(1, 2); items < maxitems; )
				{
					item = null;
					local r = this.Math.rand(1, 10);

					if (r == 1)
					{
						item = this.new("scripts/items/weapons/wooden_stick");
					}
					else if (r == 2)
					{
						item = this.new("scripts/items/armor/tattered_sackcloth");
					}
					else if (r == 3)
					{
						item = this.new("scripts/items/weapons/knife");
					}
					else if (r == 4)
					{
						item = this.new("scripts/items/helmets/hood");
					}
					else if (r == 5)
					{
						item = this.new("scripts/items/misc/ghoul_teeth_item");
					}
					else if (r == 6)
					{
						item = this.new("scripts/items/weapons/woodcutters_axe");
					}
					else if (r == 7)
					{
						item = this.new("scripts/items/shields/wooden_shield_old");
					}
					else if (r == 8)
					{
						item = this.new("scripts/items/weapons/militia_spear");
					}
					else
					{
						item = this.new("scripts/items/accessory/berserker_mushrooms_item");
					}

					if (item != null)
					{
						items = ++items;
						this.World.Assets.getStash().add(item);
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_wildman.len() == 0)
		{
			return;
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		this.m.OtherGuy = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates_wildman.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.OtherGuy = null;
	}

});

