this.player_corpse_stub <- {
	m = {
		CombatStats = null,
		LifetimeStats = null,
		OriginalID = 0,
		Name = "",
		Title = "",
		DaysWithCompany = 0,
		Level = 0,
		DailyCost = 0
	},
	function getName()
	{
		if (this.m.Title.len() != 0)
		{
			return this.m.Name + " " + this.m.Title;
		}
		else
		{
			return this.m.Name;
		}
	}

	function getNameOnly()
	{
		return this.m.Name;
	}

	function getTitle()
	{
		return this.m.Title;
	}

	function setName( _n )
	{
		this.m.Name = _n;
	}

	function setTitle( _t )
	{
		this.m.Title = _t;
	}

	function getCombatStats()
	{
		return this.m.CombatStats;
	}

	function setCombatStats( _s )
	{
		this.m.CombatStats = clone _s;
	}

	function setLifetimeStats( _s )
	{
		this.m.LifetimeStats = clone _s;
	}

	function isLeveled()
	{
		return false;
	}

	function getDaysWounded()
	{
		return 0;
	}

	function getOriginalID()
	{
		return this.m.OriginalID;
	}

	function setOriginalID( _id )
	{
		this.m.OriginalID = _id;
	}

	function isAlive()
	{
		return false;
	}

	function getImagePath()
	{
		return "tacticalentity(" + this.Math.rand() + "," + this.getID() + ")";
	}

	function getImageOffsetX()
	{
		return 0;
	}

	function getImageOffsetY()
	{
		return 0;
	}

	function getRosterTooltip()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		local time = this.m.DaysWithCompany;
		local text;

		if (time == -1)
		{
			text = "Avec la compagnie depuis le tout début.";
		}
		else if (time > 1)
		{
			text = "Avec la compagnie depuis " + time + " jours.";
		}
		else
		{
			text = "Vient de rejoindre la compagnie.";
		}

		if (this.m.LifetimeStats.Battles != 0)
		{
			text = text + (" A pris part à " + this.m.LifetimeStats.Battles + " batailles et a tué " + this.m.LifetimeStats.Kills + " ennemis.");
		}

		if (this.m.LifetimeStats.MostPowerfulVanquished != "")
		{
			text = text + (" L\'adversaire le plus puissant qu\'il a vaincu était " + this.m.LifetimeStats.MostPowerfulVanquished + ".");
		}

		tooltip.push({
			id = 2,
			type = "description",
			text = text
		});
		tooltip.push({
			id = 5,
			type = "text",
			icon = "ui/icons/xp_received.png",
			text = "Niveau " + this.m.Level
		});

		if (this.m.DailyCost != 0)
		{
			tooltip.push({
				id = 3,
				type = "text",
				icon = "ui/icons/asset_daily_money.png",
				text = "Payé [img]gfx/ui/tooltips/money.png[/img]" + this.m.DailyCost + " par jour"
			});
		}

		return tooltip;
	}

	function create()
	{
	}

	function onInit()
	{
		this.setAlwaysApplySpriteOffset(true);
	}

};

