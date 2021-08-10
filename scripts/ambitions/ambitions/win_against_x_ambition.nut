this.win_against_x_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_x";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Let us set aside skirmishes for now and seek to defeat a group of at least a dozen\nopponents. That is how our name will become known throughout the land!";
		this.m.RewardTooltip = "Gain an additional 150 renown for your victory.";
		this.m.UIText = "Win a battle against 12 or more enemies";
		this.m.TooltipText = "Win a battle against 12 or more enemies, whether by killing them or having them scatter and flee. You can do so as part of a contract or by fighting on your own terms.";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]As all your enemies either lie dead or are in retreat, %bravest_brother% waves the company\'s banner in celebration.%SPEECH_ON%Once more the %companyname% fought, and once more the %companyname% prevailed!%SPEECH_OFF%Raucous cheers echo him all around. You soon discover that your recent battle is the talk of the local towns and villages. Whenever they stop at a tavern along the road, the brothers find that drinks are poured when the story of that battle is told, and the more the telling is embellished, the more freely the libations flow.";
		this.m.SuccessButtonText = "Who dares stand against us now?";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12 || this.m.IsFulfilled)
		{
			return true;
		}

		return false;
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onReward()
	{
		this.World.Assets.addBusinessReputation(150);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Vous recevez additional renown for your victory"
		});
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

