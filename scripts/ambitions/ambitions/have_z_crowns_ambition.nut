this.have_z_crowns_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_z_Couronnes";
		this.m.Duration = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Crowns mean power and influence, and we can never have enough of either.\nLet us gather 50,000 crowns and earn our seat amongst noblemen and kings!";
		this.m.UIText = "Have at least 50,000 crowns.";
		this.m.TooltipText = "Have at least 50,000 crowns to be counted among the wealthy. You can make money by completing contracts, looting camps and ruins, or trading.";
		this.m.SuccessText = "[img]gfx/ui/events/event_04.png[/img]Plunder, plunder and, yes, more plunder! The company has accumulated riches to rival a dragon\'s hoard. The finest armor and weapons are yours for the asking. Should you wish to hire a ship, or a fleet of ships, you need merely snap your fingers. Vendors of all kinds lay out their best wares when you are in town, most eager to help you find new ways to spend your gold.\n\nAs your wealth rivals that of a nobleman, you no longer need defer to them. You could purchase your own noble title and lands, or take up the career of a merchant banker, should you ever tire of acting nursemaid to this bunch of hardheaded, temperamental louts.";
		this.m.SuccessButtonText = "Excellent.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 25)
		{
			return;
		}

		if (this.World.Assets.getMoney() >= 45000)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 10000 && !this.World.Ambitions.getAmbition("ambition.have_y_Couronnes").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 50000)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

