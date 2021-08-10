this.make_nobles_aware_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.make_nobles_aware";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "We need to catch the eye of one of the noble houses for more profitable work. They\nplay their own dangerous game, but what does it matter as long as the pay is good?";
		this.m.RewardTooltip = "You\'ll unlock entirely new contracts issued by nobles which pay better.";
		this.m.UIText = "Reach \'Professional\' renown";
		this.m.TooltipText = "Become known as \'Professional\' (1,050 renown) in order to catch the attention of the noble houses. You can increase your renown by completing contracts and winning battles.";
		this.m.SuccessText = "[img]gfx/ui/events/event_31.png[/img]Thinking to set tongues wagging with the name the %companyname%, and thereby increase your prospects with the nobility, you pushed your men to great deeds, outstanding bravery, and plentiful bloodshed. After several contracts and more than a few skirmishes, you worked hard enough and long enough to have some of the lords take notice of the company\'s competence.\n\nThese are the gentlefolk who rule the land by virtue of some long-dead ancestor subjugating a group of unarmed peasants. As %highestexperience_brother% puts it, now these pampered, inbred fops are well impressed enough with you to grind the company in one of their feuds. If you wash your face and ask politely, they should favor you with a profitable contract now and again. You can congratulate yourself!";
		this.m.SuccessButtonText = "We are about to reach into the nobility\'s deep pockets!";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 800)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() >= 1050 && this.World.FactionManager.isGreaterEvil())
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 1050)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Nobles will now give you contracts"
		});

		if (!this.World.Assets.getOrigin().isFixedLook())
		{
			if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
			{
				this.World.Assets.updateLook(14);
			}
			else
			{
				this.World.Assets.updateLook(2);
			}

			this.m.SuccessList.push({
				id = 10,
				icon = "ui/icons/special.png",
				text = "Your look on the worldmap has been updated"
			});
		}
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

