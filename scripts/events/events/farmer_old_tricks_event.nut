this.farmer_old_tricks_event <- this.inherit("scripts/events/event", {
	m = {
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.farmer_old_tricks";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]You find %farmhand% sitting beside the company wagon. He\'s rolling some boomstraw between his teeth, gritting it here and there and spitting out the flakes. You ask what he\'s thinking about. The farmer shrugs.%SPEECH_ON%What my pa told me about baling hay. He had this method of turning the wrist at the catch and again at the release. Never could get the second part right.%SPEECH_OFF%The man takes the straw out and flicks it. You ask.%SPEECH_ON%But you could get the first part right? Where ya stab the hay and yank?%SPEECH_OFF%He nods. You tell the man that he only needs the first part of that technique to properly gut a man. You watch as his face glows with realization.%SPEECH_ON%Yeah... yeah that\'s right! Why didn\'t I think of that before? Yer a genius, sir! I\'ll try it our next go out! It\'ll just be like baling hay!%SPEECH_OFF%With a lot more screaming and bleeding, but sure.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just don\'t try and throw them over your shoulder.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Farmer.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				_event.m.Farmer.getBaseProperties().MeleeSkill += meleeSkill;
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Farmer.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Maîtrise de Mêlée"
				});
				_event.m.Farmer.improveMood(1.0, "Realized he has some fighting knowledge");

				if (_event.m.Farmer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
						text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 2 && bro.getBackground().getID() == "background.farmhand")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Farmer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"farmhand",
			this.m.Farmer.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Farmer = null;
	}

});

