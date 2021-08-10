this.have_z_renown_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_z_renown";
		this.m.Duration = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "There were few legendary mercenary companies throughout history.\nWe are close to having our name become immortal and be counted among them!";
		this.m.UIText = "Reach \'Invincible\' renown";
		this.m.TooltipText = "Become known as \'Invincible\' (8,000 renown) and leave your mark in history. You can increase your renown by completing contracts and winning battles.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]With rivers of blood, a hundred burned fortresses, and ten thousand fat, feasting crows at your back, the tales of your company\'s prowess will never die. The name \'%companyname%\' is spoken in triumphant shouts and hushed awe in every corner of the known world. Fathers name their sons after your bravest men, and those boys will grow up acting out the many famous battles you fought.\n\nYour renown is such now that is has become an inconvenience to visit any place larger than a hamlet. Everywhere you travel you are harried day and night. Eligible maidens competing for the mens\' attention end up in fisticuffs. Shopkeepers, thinking you magnificently wealthy, call at all hours with their wares. Worst of all, every braggart in the land wishes to challenge your men, with the militia waiting for the outcome, hoping that the simple fine for fighting in the street may be elevated to a blood debt.\n\nBut you achieved what you set out to, even if the result is not quite what you anticipated. Whatever your fate, the %companyname% has already become immortal in the history of the world.";
		this.m.SuccessButtonText = "The %companyname%\'s name shall live on forever!";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 60)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() <= 4000 || this.World.Assets.getBusinessReputation() >= 7800)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 8000)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		if (!this.World.Assets.getOrigin().isFixedLook())
		{
			if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
			{
				this.World.Assets.updateLook(15);
			}
			else
			{
				this.World.Assets.updateLook(3);
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

