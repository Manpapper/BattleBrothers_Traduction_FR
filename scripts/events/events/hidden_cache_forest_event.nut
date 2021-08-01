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
			Text = "[img]gfx/ui/events/event_25.png[/img]The forest is no friend of man which is why men of ill-repute sure love to put their keepsakes there. And today you\'ve stumbled across one: a cache that %otherbrother% found by way of stubbing his toe on the edge of it. Digging out the crate and cracking it open, you find an assortment of weapons, armor, and gold. You clap the sellsword on the shoulder and thank him for his \'hard work\'. He wags his boot around.%SPEECH_ON%Yessir, I\'ve got a toe like the nose of a bloodhound.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Indeed you do.",
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
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
			Text = "[img]gfx/ui/events/event_25.png[/img]As you get ready to leave, %graverobber% the graverobber stops you.%SPEECH_ON%Wait a minute.%SPEECH_OFF%He jumps down into the pit in which the cache was buried. He starts knocking around on the dirt. Tap. Tap. Tap. Clack. His knuckle raps hard and a smile crosses his face.%SPEECH_ON%Yeah, that\'s what I thought.%SPEECH_OFF%The man digs into the earth and drags out another crate and opens it up. You\'re wowed by the sight of what\'s inside. The graverobber nods.%SPEECH_ON%If someone has something good to hide, they don\'t just hide it in the ground, they hide it with things of lesser value. That way, even if you find their treasure there\'s still a chance you\'ll get distracted from the real good stuff. Quite clever, really, but it don\'t fool me none.%SPEECH_OFF%",
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

