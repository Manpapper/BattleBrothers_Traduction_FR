this.hidden_cache_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Otherbrother = null
	},
	function create()
	{
		this.m.ID = "event.hidden_cache_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]La forêt n\'est pas l\'amie de l\'homme, c\'est pourquoi les hommes de mauvaise réputation aiment y déposer leurs trésors. Et aujourd\'hui, vous êtes tombé sur l\'un d\'entre eux : une cache que  %otherbrother% a trouvée en se cognant l\'orteil à l\'orée de la forêt. En déterrant la caisse et en l\'ouvrant, vous trouvez un assortiment d\'armes, d\'armures et d\'or. Vous tapez sur l\'épaule du mercenaire et le remerciez pour son \"dur labeur\". Il remue sa botte dans tous les sens.%SPEECH_ON%Oui, Boss, j\'ai un orteil aussi fin comme le nez d\'un limier.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "En effet, c\'est le cas.",
					function getResult( _event )
					{
						if (_event.m.Graverobber != null)
						{
							return "B";
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
				this.Characters.push(_event.m.Otherbrother.getImagePath());
				local money = this.Math.rand(30, 150);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				local r = this.Math.rand(1, 8);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/bludgeon");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/falchion");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/shortsword");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/scramasax");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				r = this.Math.rand(1, 5);

				if (r == 1)
				{
					item = this.new("scripts/items/armor/gambeson");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/armor/leather_tunic");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/armor/thick_tunic");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/armor/wizard_robe");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/armor/worn_mail_shirt");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]Alors que vous vous apprêtez à partir, %graverobber% le fossoyeur vous arrête.%SPEECH_ON%Attendez une minute.%SPEECH_OFF%Il saute dans la fosse dans laquelle la cache était enterrée. Il commence à frapper sur la terre. Tape. Tape. Tap. Clack. Sa jointure frappe fort et un sourire traverse son visage.%SPEECH_ON%Ouais, c\'est ce que je pensais.%SPEECH_OFF%L\'homme creuse dans la terre et sort une autre caisse qu\'il ouvre. Vous êtes impressionnés par la vue de ce qu\'il y a à l\'intérieur. Le fossoyeur acquiesce.%SPEECH_ON%Si quelqu\'un a quelque chose de bien à cacher, il ne se contente pas de le cacher dans le sol, il le cache avec des choses de moindre valeur. De cette façon, même si vous trouvez leur trésor, il y a toujours une chance que vous soyez distrait de la vraie bonne chose. Très astucieux, vraiment, mais il ne m\'auront pas.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local r = this.Math.rand(1, 4);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/loot/gemstones_item");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/loot/silver_bowl_item");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/loot/silverware_item");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/loot/golden_chalice_item");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d < 15)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local graverobber_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				graverobber_candidates.push(bro);
			}
			else
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		if (graverobber_candidates.len() != 0)
		{
			this.m.Graverobber = graverobber_candidates[this.Math.rand(0, graverobber_candidates.len() - 1)];
		}

		this.m.Otherbrother = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Otherbrother.getName()
		]);
		_vars.push([
			"graverobber",
			this.m.Graverobber != null ? this.m.Graverobber.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Otherbrother = null;
	}

});

