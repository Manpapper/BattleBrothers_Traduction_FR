this.rangers_origin_hunt_food_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.rangers_origin_hunt_food";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]{En tant que communauté de chasseurs, il est évident que vous êtes entrés sur un bon terrain de chasse. %randombrother% suggère que la compagnie parte à la chasse, mais il prévient que le groupe doit faire attention à ce qu\'il prélève dans ces généreuses étendues.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allons Chasser !",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 70)
						{
							return "C";
						}
						else if (r <= 90)
						{
							return "B";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "Il y a du temps pour ça plus tard.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Les hommes reçoivent l\'ordre de partir à la chasse et ils prennent un pouce par mille ! Ils tirent, dépouillent et massacrent à peu près tous les animaux qui respirent à leur portée. Vous craignez que cela n\'attire l\'attention des nobles locaux, mais ils ne se doutent de rien. Les magasins d\'inventaire vont déborder !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une bonne chasse.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez du Gibier"
				});
				local item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Quelques hommes partent à la chasse et reviennent avec quelques animaux tués. Vous leur demandez s\'ils ont eu des problèmes et ils répondent par la négative. On dirait que l\'inventaire va connaître quelques ajouts savoureux et aucun noble ne sera plus sage !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une chasse décente.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez du Gibier"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{Une heure environ après avoir envoyé les hommes à la chasse, ils reviennent. Sauf qu\'ils ramènent au camp %bearbrother% ensanglanté et déchiqueté. Ils rapportent que le groupe a croisé le chemin d\'une maman ours brun. Elle s\'est battue comme une folle et n\'a cessé de déchiqueter le braconnier blessé que parce que l\'un des hommes a menacé ses petits avec une torche. Vous êtes heureux que les hommes soient tous en vie, même si %bearbrother% aura besoin de beaucoup de temps pour se remettre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce travail de mercenaire émousse nos sens.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Hunter.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Hunter.getName() + " souffre de " + injury.getNameOnly()
				});
				this.Characters.push(_event.m.Hunter.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.rangers")
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Hunter = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bearbrother",
			this.m.Hunter.getName()
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
	}

});

