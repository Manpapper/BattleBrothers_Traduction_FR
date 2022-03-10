this.anatomist_reflects_on_webknechts_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		OtherBro = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_reflects_on_webknechts";
		this.m.Title = "During camp...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% is holding out his arm, watching a long-legged spider trundling across his flesh. As the creature reaches the ends of its newfound earth, the anatomist turns his arm, suggesting the spider continue on another way. He does this for a time until putting his fingers toward the ground and the spider shuffles off entirely, perhaps not ever once aware it was on a living being. The anatomist writes a few pages down in his notes.%SPEECH_ON%The other day I watched a spider jump twenty-times its body length to snatch a fly. And this spider I\'ve let go would, upon seeing its prey, speed across the ground like a hunting dog. It seems that the old gods have taken pity on us, scapegrace, for neither of these creatures can be found in their larger, webknecht forms.%SPEECH_OFF%While being tackled and ripped apart would be quite terrible, you tell him that being wrapped in a cocoon before having your blood sucked out by fangs is undoubtedly worse. The anatomist raises a finger.%SPEECH_ON%A common misconception, scapegrace, for the webknecht actually prefers to feed long after you are deceased. We believe its toxins are designed to target the belly, opening it up and using its fluids to melt you from the inside out. This is presumably why they hang their prey upside down, so the toxins can slosh over the organs, turning you into a sort of sack of fluids. The consuming phase of the process is merely one of digesting whatever is left. The only time they don\'t eat you is if they\'re placing their brood inside you as the spiderlings will need sustenance upon hatching.%SPEECH_OFF%That still sounds infinitely worse than being shanked by a hunting spider, but either way you regret having the conversation and pursue it no further. Unfortunately, %otherbro% is nearby and has heard all too much...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Stop spreading the heebiejeebies, dammit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.OtherBro.getImagePath());
				local trait = this.new("scripts/skills/traits/fear_beasts_trait");
				_event.m.OtherBro.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.OtherBro.getName() + " now fears beasts"
				});
				_event.m.OtherBro.worsenMood(1.0, "Terrified of spiders");

				if (_event.m.OtherBro.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherBro.getMoodState()],
						text = _event.m.OtherBro.getName() + this.Const.MoodStateEvent[_event.m.OtherBro.getMoodState()]
					});
				}

				_event.m.Anatomist.improveMood(1.0, "Fascinated with spiders");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
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

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.beast_slayer" && bro.getBackground().getID() != "background.wildman" && !bro.getSkills().hasSkill("trait.brave") && !bro.getSkills().hasSkill("trait.fearless") && !bro.getSkills().hasSkill("trait.fear_beasts") && !bro.getSkills().hasSkill("trait.hate_beasts"))
			{
				other_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || other_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.OtherBro = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"otherbro",
			this.m.OtherBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.OtherBro = null;
	}

});

