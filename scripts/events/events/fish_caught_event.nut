this.fish_caught_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null
	},
	function create()
	{
		this.m.ID = "event.hunt_food";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{Lors de votre halte près d\'un cours d\'eau, il semble que %fisherman% soit sorti pour pratiquer son vieux métier et ait attrapé quelques poissons ! | Vous êtes arrivé à un plan d\'eau et vous vous êtes arrêté pour parler à quelques habitants des terres environnantes. %fisherman%, l\'ancien pêcheur, a profité de cette occasion pour aller attraper quelques saumons et autres créatures de la rivière. | Alors que vous marchiez près d\'une rivière, %fisherman% l\'ancien pêcheur a réussi à courir le long des berges et à ramasser un seau plein d\'écrevisses ! Bouillies dans une marmite, elles constitueront un bon repas.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est poisson ce soir !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fisherman.getImagePath());
				local food = this.new("scripts/items/supplies/dried_fish_item");
				this.World.Assets.getStash().add(food);
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + food.getAmount() + "[/color] Poissons"
					}
				];
				_event.m.Fisherman.improveMood(0.5, "A attrapé quelques poissons");

				if (_event.m.Fisherman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Fisherman.getMoodState()],
						text = _event.m.Fisherman.getName() + this.Const.MoodStateEvent[_event.m.Fisherman.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Shore)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.fisherman")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Fisherman = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 15;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fisherman",
			this.m.Fisherman.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Fisherman = null;
	}

});

