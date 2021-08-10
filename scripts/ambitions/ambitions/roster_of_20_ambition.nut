this.roster_of_20_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_20";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Let\'s build up our numbers to twenty good men so that the wounded\nmay rest and the weary regain their strength between skirmishes.";
		this.m.UIText = "Have a roster of 20 men";
		this.m.TooltipText = "Hire enough men to have a full roster of 20 men. Visit settlements across the lands to find recruits that suit your needs.";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]For many days you speak with potential recruits from different backgrounds and from every corner of society, weeding out the incompetent and haggling with the greedy. It seems as if in troubled times every vagrant, daytaler and nobleman\'s youngest son wishes to become a mercenary.\n\nThe men are glad for the company\'s bigger roster, and those you rejected will be the butt of many jests for weeks to come. %highestexperience_brother% claps you on the shoulder.%SPEECH_ON%How about that man who said he\'d taken the heads of a bunch of orcs, but was really a baker from %randomtown%! Pinching flabby biceps and beating farmers\' sons with tree branches was good sport for the first few days but by the end it was more work than chasing brigands around, if you ask me.%SPEECH_OFF%You now have twenty men under your command. Not all are veterans, and not all have been tested, but being able to rotate out your wounded will mean fresher units in the field.";
		this.m.SuccessButtonText = "A full company, finally.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 20)
		{
			this.m.IsDone = true;
			return;
		}

		if (this.World.Assets.getBrothersMax() < 20)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.roster_of_12").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 20)
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

