this.win_against_y_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_y";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "We achieved some renown, but now you can see real fame on the horizon.\nLet us defeat a formidable force of two dozen opponents in battle!";
		this.m.UIText = "Win a battle against 24 or more enemies";
		this.m.TooltipText = "Win a battle against 24 or more enemies, whether by killing them or having them scatter and flee. You can do so as part of a contract or by fighting on your own terms.";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]After the fight, %lowesthp_brother% sits gazing at his feet, looking completely knackered, as do the others. %SPEECH_ON%That was the battle I was born to fight! Now if I die, it will be alongside the bravest and deadliest bunch of men I\'ve ever known, and I\'m proud to call them my brothers!%SPEECH_OFF%This is met with a chorus of weary assent all round.%SPEECH_ON%Peasants talk of sweat, blood and tears but the men of the %companyname% have walked through fire and prevailed!%SPEECH_OFF%Three times the men shout the company name, tired but victorious.\n\nIn the days to come you find that wherever civilized people gather, they point you out and whisper, whether in fear or admiration you do not know. Everywhere you go, word of your mighty victory has traveled the land before you.";
		this.m.SuccessButtonText = "Who dares stand against us now?";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.win_against_x").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24 || this.m.IsFulfilled)
		{
			return true;
		}

		return false;
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeBool(this.m.IsFulfilled);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.IsFulfilled = _in.readBool();
	}

});

