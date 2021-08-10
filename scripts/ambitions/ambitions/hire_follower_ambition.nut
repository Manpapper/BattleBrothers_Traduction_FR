this.hire_follower_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.hire_follower";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "There are cooks, scouts and many more who can support us off the battlefield.\nWe\'ll hire one that suits our needs best!";
		this.m.UIText = "Hire someone for your retinue of non-combat followers";
		this.m.TooltipText = "Gain a renown of at least \'Recognized\' (250) to unlock the first slot for a non-combat follower in your retinue. You can increase your renown by completing contracts and winning battles. Then, hire a non-combat follower in the retinue screen. Some followers require you to fulfill specific prerequisites to unlock their services.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]%SPEECH_ON%So they\'re not a fighter?%SPEECH_OFF%One of the sellswords asks. You shake your head, and they scratch theirs.%SPEECH_ON%But they\'re hired on anyway?%SPEECH_OFF%You nod. The sellsword purses their lips for a second then clarifies.%SPEECH_ON%And absolutely no fighting?%SPEECH_OFF%No fighting.%SPEECH_ON%None? So they\'ll just fart around doing whatever task here and there?%SPEECH_OFF%You explain that not every important role in a mercenary band needs to be one of fighting. After you\'ve laid out all the jobs others could help out around here, the sellsword thinks for a time.%SPEECH_ON%Can they take up inventory counting, then? Cause I\'m real tired of that.%SPEECH_OFF%No. Of course not. You\'ll never let your secret punishment go to someone else.";
		this.m.SuccessButtonText = "This will aid us greatly in the days to come.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < this.Const.BusinessReputation[this.Const.FollowerSlotRequirements[0]] - 100)
		{
			return;
		}

		if (this.World.Retinue.getNumberOfCurrentFollowers() >= 1)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Retinue.getNumberOfCurrentFollowers() >= 1)
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

