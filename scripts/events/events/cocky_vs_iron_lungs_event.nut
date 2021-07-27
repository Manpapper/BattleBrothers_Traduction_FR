this.cocky_vs_iron_lungs_event <- this.inherit("scripts/events/event", {
	m = {
		Cocky = null,
		IronLungs = null
	},
	function create()
	{
		this.m.ID = "event.cocky_vs_iron_lungs";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]As you roll up some maps and put them back in their panniers, a commotion draws you outside your tent. The men are dragging %cocky% across the ground. His clothes are sopping wet and his face one shade short of death. The men give him some good slaps on the cheeks. Eventually, he wakes up, eyes wild, mouth gargling water like a broken fountain. He looks around and asks what you, too, wish to know.%SPEECH_ON%What happened?%SPEECH_OFF%%ironlungs% walks over, a similarly wet visage, but with a far more colorful complexion.%SPEECH_ON%You cocky cunt dared to see which of us could hold their breath the longest. You lost because they don\'t call these the iron lungs for nuttin\'.%SPEECH_OFF%The men have a laugh as %ironlungs% boastfully pounds his chest. %cocky%, still wobbly, gets to his feet. Mere moments after being completely unconscious, he\'s already back to his prideful ways.%SPEECH_ON%Yeah yeah, you bested me this day, but I shall be the best, just you wait!%SPEECH_OFF%Another sellsword whimsically points out that the cocksure fella has a huge string of snot dangling from his nose. He confidently wipes it away despite the roaring laughter of the company.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah, the always safe measurement of manliness.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
				_event.m.Cocky.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Cocky.getName() + " suffers light wounds"
				});
				_event.m.Cocky.worsenMood(1.0, "Was humiliated in front of the company");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cocky.getMoodState()],
					text = _event.m.Cocky.getName() + this.Const.MoodStateEvent[_event.m.Cocky.getMoodState()]
				});
				_event.m.IronLungs.improveMood(1.0, "Beat " + _event.m.Cocky.getName() + " in a contest of strength");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.IronLungs.getMoodState()],
					text = _event.m.IronLungs.getName() + this.Const.MoodStateEvent[_event.m.IronLungs.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Cocky.getID() && bro.getID() != _event.m.IronLungs.getID() && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Felt entertained by " + _event.m.Cocky.getNameOnly());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local cocky_candidates = [];
		local ironlungs_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.cocky"))
			{
				cocky_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				ironlungs_candidates.push(bro);
			}
		}

		if (cocky_candidates.len() == 0 || ironlungs_candidates.len() == 0)
		{
			return;
		}

		this.m.Cocky = cocky_candidates[this.Math.rand(0, cocky_candidates.len() - 1)];
		this.m.IronLungs = ironlungs_candidates[this.Math.rand(0, ironlungs_candidates.len() - 1)];
		this.m.Score = (cocky_candidates.len() + ironlungs_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cocky",
			this.m.Cocky.getNameOnly()
		]);
		_vars.push([
			"ironlungs",
			this.m.IronLungs.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cocky = null;
		this.m.IronLungs = null;
	}

});

