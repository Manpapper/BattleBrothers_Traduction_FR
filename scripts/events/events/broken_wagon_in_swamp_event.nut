this.broken_wagon_in_swamp_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null
	},
	function create()
	{
		this.m.ID = "event.broken_wagon_in_swamp";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img]Les marais ne sont pas un endroit sûr pour les voyages. À en juger par le brouillard incessant et la façon dont les arbres se courbent, il ne fait aucun doute que c\'est un lieu où grouillent des choses démoniaques. Du moins, c\'est ce que les druides de ces régions disent. Tout ce que vous trouvez, c\'est un couple de chevaux morts noyés dans la boue et un chariot écrasé par la boue qui s\'est infiltrée sur ses roues et sur lui-même. %randombrother% fouille les restes et parvient à récupérer quelques objets.%SPEECH_ON%Eh bien, c\'est quelque chose. Celui qui a laissé ça ici est parti il y a peu de temps. Probablement effrayé par ce qui vit ici.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Toujours utile.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] d\'Outils et de Provisions."
				});
			}

		});
		this.m.Screens.push({
			ID = "Butcher",
			Text = "[img]gfx/ui/events/event_14.png[/img]%SPEECH_ON%Monsieur, attendez.%SPEECH_OFF% Dit l\'ancien boucher, %butcher%. Il avance et commence à tailler dans le cadavre d\'un cheval. Il découpe une série de morceaux, les enveloppe dans de grandes feuilles, les fait sécher avec un peu de terre et de sel, et vous les remet.%SPEECH_ON%Il n\'y a aucune raison de laisser derrière nous ce qui peut être utilisé.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et vous êtes sûr que c\'est encore comestible ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Butcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 9;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
	}

});

