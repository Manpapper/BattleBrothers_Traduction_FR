this.raiders_origin_redemption_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.raiders_origin_redemption_";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{%monk% is a monk who, by this point, is very, very far from his home. The days on the road alone are hard enough, and the days off it being filled with violence and pillaging even worse so. It\'s no surprise that he has come to you with an offer. Despite being with your company for some time now, it is clear that he is still a man of civilization.\n\n He explains an old law: as a raider you are persona non grata, but as a raider with a lot of money there is a chance you can buy your way back into dealing with the nobles of this land. The monk says he knows whose palms to cross. Apparently, %noblehouse% is interested in \'opening channels\', and they would just appreciate %crowns% crowns to settle into new affairs. Civilized indeed.}",
			Banner = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Make it happen.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We have no need for this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{You agree to the monk\'s notions. Together, you meet with an intermediary and one of the nobles himself. The meeting takes place in secret and at first there is a lot of dramatic cloak and dagger nonsense. Men wearing black and keeping their hands to their weapons, nobles whispering to one another, but after it\'s all said and done... you have a good long drink together. In the future, %noblehouse% will be more open to dealings.}",
			Banner = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Doing mercenary work for them would further mend relations.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Flags.set("IsRaidersRedemption", true);
				this.World.Assets.addBusinessReputation(50);
				this.World.Assets.addMoney(-2000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-2000[/color] Crowns"
				});
				_event.m.NobleHouse.addPlayerRelation(20.0, "Was bribed to have dealings with you");
				this.List.push({
					id = 10,
					icon = "ui/icons/relations.png",
					text = "Your relations to " + _event.m.NobleHouse.getName() + " improve"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 500)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 2500)
		{
			return;
		}

		if (this.World.Flags.get("IsRaidersRedemption"))
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates_nobles = [];

		foreach( n in nobles )
		{
			if (n.getPlayerRelation() > 5.0 && n.getPlayerRelation() < 25.0)
			{
				candidates_nobles.push(n);
			}
		}

		if (candidates_nobles.len() == 0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk" && bro.getLevel() > 1)
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates_nobles[this.Math.rand(0, candidates_nobles.len() - 1)];
		this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getName()
		]);
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"crowns",
			"2,000"
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.NobleHouse = null;
	}

});

