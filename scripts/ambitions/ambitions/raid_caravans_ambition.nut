this.raid_caravans_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		RaidsToComplete = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.raid_caravans";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "There are lots of riches to be claimed from caravans.\nWe need but take them like fruit from a tree!";
		this.m.UIText = "Raid trade or supply caravans";
		this.m.TooltipText = "Raid 4 trade or supply caravans along the road. If you\'re not already hostile to their faction, you can force an attack by holding the CTRL key while left-clicking on them - but only if you\'re not currently hired for a contract.";
		this.m.SuccessText = "[img]gfx/ui/events/event_60.png[/img]A dead merchant\'s voice rings in your head.%SPEECH_ON%Why did you do it? We\'d have given you it all.%SPEECH_OFF%But the memory isn\'t about him. It\'s about his wagon, and what parts of it he wouldn\'t even divulge with his life on the balance. Since setting out to raid them, attacking caravans has turned into something of a sport for you and the %companyname%. Awashed in the riches of your ambushes, the men are happy, and you\'ve accrued a bit of renown for your dastardly deeds.";
		this.m.SuccessButtonText = "Like taking candy from a child.";
	}

	function getUIText()
	{
		this.logInfo("to raid: " + this.m.RaidsToComplete);
		this.logInfo("raided: " + this.World.Statistics.getFlags().getAsInt("CaravansRaided"));
		local d = 4 - (this.m.RaidsToComplete - this.World.Statistics.getFlags().getAsInt("CaravansRaided"));
		return this.m.UIText + " (" + this.Math.min(4, d) + "/4)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") <= 0 && this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		this.m.RaidsToComplete = this.World.Statistics.getFlags().getAsInt("CaravansRaided") + 4;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") >= this.m.RaidsToComplete)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.RaidsToComplete);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.RaidsToComplete = _in.readU16();
	}

});

