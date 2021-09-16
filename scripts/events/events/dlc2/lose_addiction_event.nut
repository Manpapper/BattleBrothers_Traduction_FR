this.lose_addiction_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lose_addiction";
		this.m.Title = "During camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%addict% enters your tent with his hands behind his back in a respective posture. He asks if you have a moment. You nod and he states that he is rid of his tremors and ailments. You ask what he means. He twists his hand above his mouth as though taking a swig.%SPEECH_ON%The potions, sir, I\'ve no longer any overbearing affinity for the things. I\'m good. Sound. Quite sound. Ready to fight as the man I am.%SPEECH_OFF%You\'re not entirely sure what he\'s driving at. You thought most men took to alcohol, but you\'ve no issue with that. Whatever it is it appears he\'s bettered it. | You find %addict% sitting on the ground looking at his palms. He\'s following the grooves with a finger.%SPEECH_ON%I hear you, sir.%SPEECH_OFF%Nodding, you ask what he\'s up to. He smiles.%SPEECH_ON%Feeling better. Feeling like I don\'t need to loosen myself with them potions no longer. Feeling myself, I suppose. Ready to kill, as you command, sir, and do it with clarity of mind to know what I\'m doing and why.%SPEECH_OFF%Great. You\'re not sure what that was about but wish him good luck in staying that way.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good work being you.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local trait = _event.m.Addict.getSkills().getSkillByID("trait.addict");
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Addict.getName() + " no longer is an addict"
				});
				_event.m.Addict.getSkills().remove(trait);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getFlags().get("PotionLastUsed") >= 14.0 * this.World.getTime().SecondsPerDay && bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 5 + candidates_addict.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
	}

});

