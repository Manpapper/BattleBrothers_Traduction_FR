this.apprentice_vs_oathtaker_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_vs_oathtaker";
		this.m.Title = "During camp...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%apprentice% the apprentice is sitting beside the campfire when %oathtaker% the Oathtaker starts sizing him up. The apprentice returns a confused look.%SPEECH_ON%What is it?%SPEECH_OFF%The Oathtaker grins.%SPEECH_ON%Young Anselm, the First Oathtaker, was an apprentice much like you. He wandered the lands in seeking knowledge and finding himself the Final Path. You even look just like him.%SPEECH_OFF%The apprentice smiles warmly. It seems this notion of connectedness with the dead Oathtaker has emboldened the apprentice. But, as far as you\'re concerned, Young Anselm\'s skull looks absolutely nothing like %apprentice%. The nose is too big, the brow too ridged, and the First Oathtaker\'s teeth are impeccable while %apprentice% looks like he cleans his with a mallet. But maybe %apprentice% will look more the part when he is also a shiny skull cared for by an unwavering cult.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Not that I want that to happen.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Apprentice.getBaseProperties().Bravery += resolveBoost;
				_event.m.Apprentice.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Apprentice.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});
				_event.m.Apprentice.getFlags().add("learnedFromOathtaker");
				_event.m.Apprentice.improveMood(1.0, "Learned from " + _event.m.Oathtaker.getName());
				_event.m.Oathtaker.improveMood(0.5, "Has taught " + _event.m.Apprentice.getName() + " something");

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local apprentice_candidates = [];
		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learnedFromOathtaker"))
			{
				apprentice_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.paladin")
			{
				teacher_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() == 0 || teacher_candidates.len() == 0)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Oathtaker = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = (apprentice_candidates.len() + teacher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"apprentice",
			this.m.Apprentice.getNameOnly()
		]);
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Oathtaker = null;
	}

});

