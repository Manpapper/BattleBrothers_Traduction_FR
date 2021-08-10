this.roster_of_16_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_16";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "We shall get the company strength to sixteen men! It will make us\na formidable force and will allow us to take on more profitable work.";
		this.m.UIText = "Have a roster of at least 16 men";
		this.m.TooltipText = "Hire enough men to have a full roster of at least 16 men. Visit settlements across the lands to find recruits that suit your needs. Having a full roster will allow you to take on more dangerous and better paying contracts.";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]Having finally gathered the coin and equipment, you manage to assemble a full complement of sixteen able-bodied men. When next you walk down %currenttown%\'s main street, the men break into a full-throated marching song. A few of the townsfolk mutter under their breath about dirty mercenaries taking over the town, but others walk alongside and shout the words with you. %SPEECH_ON%Stand tall, brothers. People can see this is a real mercenary company now, and not a handful of rabble.%SPEECH_OFF%%highestexperience_brother% declares.%SPEECH_ON%We trade in strength, and now that our numbers have gone up, so will our price.%SPEECH_OFF%It appears he has the right of it. You notice one particularly fat merchant sizing up the company as if he already has a task in mind. The %companyname% are now a force to be reckoned with. Once the men have settled in for a celebratory drink, perhaps you should take another stroll through town to see if any more lucrative contracts may be available.";
		this.m.SuccessButtonText = "We\'re getting there.";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.militia")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 16)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 16)
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

