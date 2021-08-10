this.find_and_destroy_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.find_and_destroy_location";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Let us set out into the wilderness, discover the unknown, and plunder it.\nBe it a wizard\'s tomb, goblin camp, or aught else we may find.";
		this.m.UIText = "Discover a ruin or hostile camp, and destroy it";
		this.m.TooltipText = "Discover a ruin, camp or other hostile location on your own by exploring the land, destroy it, and take the plunder.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]It sounded like a good idea at the time, but tramping around the wilderness without a map or any destination in mind turned out to be quite a strenuous way to find riches, or even a battle. Your footsore band did eventually come upon a worthy target though, and everyone had to agree the venture was worthwhile after all. %farmer% is almost glowing with satisfaction as he surveys the few remaining embers of the %recently_destroyed%.%SPEECH_ON%They hadn\'t the merest clue we were coming. Like wheat before our scythes, brothers!%SPEECH_OFF%%notfarmer% raises an eyebrow.%SPEECH_ON%Speak for yourself. I\'m no farmer.%SPEECH_OFF%";
		this.m.SuccessButtonText = "Another challenge conquered.";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastLocationDestroyedFaction") != 0 && this.World.Statistics.getFlags().get("LastLocationDestroyedForContract") == false)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastLocationDestroyedFaction") != 0 && this.World.Statistics.getFlags().get("LastLocationDestroyedForContract") == false)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local farmers = [];
		local workers = [];
		local not_farmers = [];

		if (brothers.len() > 2)
		{
			for( local i = 0; i < brothers.len(); i = ++i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.farmhand")
			{
				farmers.push(bro);
			}
			else if (bro.getBackground().getID() == "background.shepherd" || bro.getBackground().getID() == "background.miller" || bro.getBackground().getID() == "background.daytaler")
			{
				workers.push(bro);
			}
			else
			{
				not_farmers.push(bro);
			}
		}

		local farmer;

		if (farmers.len() != 0)
		{
			farmer = farmers[this.Math.rand(0, farmers.len() - 1)];
		}
		else if (workers.len() != 0)
		{
			farmer = workers[this.Math.rand(0, workers.len() - 1)];
		}
		else
		{
			farmer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		local not_farmer;

		if (not_farmers.len() != 0)
		{
			not_farmer = not_farmers[this.Math.rand(0, not_farmers.len() - 1)];
		}
		else
		{
			not_farmer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		_vars.push([
			"farmer",
			farmer.getName()
		]);
		_vars.push([
			"notfarmer",
			not_farmer.getName()
		]);
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
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

