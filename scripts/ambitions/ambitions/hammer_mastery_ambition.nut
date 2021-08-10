this.hammer_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.hammer_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Our company is ill-prepared to fight armored opponents. We shall train two men\nto master the hammer in combat, and no knight will be safe from us.";
		this.m.UIText = "Have men with the hammer mastery perk";
		this.m.TooltipText = "Have 2 men with the hammer mastery perk.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]The men gather around to watch %hammerbrother%\'s prowess as he practices his strokes against a pine tree, crack-crack-crack.%SPEECH_ON%Behold the hammer head! You could practically punch right through any helmet and have a good look what\'s inside that skull-bowl!%SPEECH_OFF%He swings once more and the tree trunk splits in the middle, with the upper half falling directly into the camp. %nothammerbrother% scrambles up from his seat, spilling soup all over himself, to narrowly avoid being crushed. %SPEECH_ON%Here I thought there was nothing new to see in the world but I have never killed a man with a falling tree before!%SPEECH_OFF%%hammerbrother% shouts laughingly. You anticipate that you will fare well next time you come up against heavily armored enemies.";
		this.m.SuccessButtonText = "Armor, what armor?";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(2, this.getBrosWithMastery()) + "/2)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInHammers)
			{
				count = ++count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 2)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 2)
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

			if (p.IsSpecializedInHammers)
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
			this.candiates = not_candidates;
		}

		_vars.push([
			"hammerbrother",
			candidates[this.Math.rand(0, candidates.len() - 1)].getName()
		]);
		_vars.push([
			"nothammerbrother",
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

