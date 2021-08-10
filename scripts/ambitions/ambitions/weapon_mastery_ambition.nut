this.weapon_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.weapon_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Imagine the trail of terror we could blaze if your skills matched your bravery.\nWe shall train five men to master their weapons so that they may act as a vanguard!";
		this.m.UIText = "Have men with a weapon mastery perk each";
		this.m.TooltipText = "Have 5 of your men with a weapon mastery perk each, no matter which one.";
		this.m.SuccessText = "[img]gfx/ui/events/event_50.png[/img]Introducing a new regimen to train the brothers in mastering a weapon is good for everyone\'s morale. Those who do the training improve their prowess and chances of survival, and earn the admiration of their companions, while the others have something fun to watch while sitting on a log and stuffing their faces with mutton.\n\nThe trainees practice in every spare moment with a variety of weapons until hard arms have become like oaken branches, and sharp eyes grow as keen and unforgiving as those of a great cat.%SPEECH_ON%Not only is %weaponbrother% a fearsome threat to our enemies, but his swift footwork makes you think of dancing girls.%SPEECH_OFF%%notweaponbrother% remarks, only to be soundly chastised with a training sword by %weaponbrother%.";
		this.m.SuccessButtonText = "They\'re professionals now.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(5, this.getBrosWithMastery()) + "/5)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInCrossbows)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInThrowing)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInSwords)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInCleavers)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInMaces)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInHammers)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInAxes)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInFlails)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInSpears)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInPolearms)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInDaggers)
			{
				count = ++count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 5)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local not_candidates = [];

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
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInCrossbows)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInThrowing)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInSwords)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInCleavers)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInMaces)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInHammers)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInAxes)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInFlails)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInSpears)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInPolearms)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInDaggers)
			{
				candidates.push(bro);
			}
			else
			{
				not_candidates.push(bro);
			}
		}

		if (not_candidates.len() == 0)
		{
			not_candidates = brothers;
		}

		_vars.push([
			"weaponbrother",
			candidates[this.Math.rand(0, candidates.len() - 1)].getName()
		]);
		_vars.push([
			"notweaponbrother",
			not_candidates[this.Math.rand(0, not_candidates.len() - 1)].getName()
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

