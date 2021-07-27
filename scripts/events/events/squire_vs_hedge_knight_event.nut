this.squire_vs_hedge_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Squire = null,
		HedgeKnight = null
	},
	function create()
	{
		this.m.ID = "event.squire_vs_hedge_knight";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]%squire% the young squire is eyeing %hedgeknight% from a safe distance. The hedge knight is sharpening his blades, running a whetstone over the edges and stropping the metals to give \'em a good sheen. Catching the squire staring, %hedgeknight% lowers his equipment.%SPEECH_ON%So you want to be a knight, is that it?%SPEECH_OFF%%squire% nods and answers proudly.%SPEECH_ON%It is my dream, yes, and one day it will happen.%SPEECH_OFF%The hedge knight stands and walks over, coming to tower over the youth.%SPEECH_ON%What is it you think a knight does? Saves damsels? Rules fiefs to be loved by the peasants? Owes allegiance to his lord? Well let me tell you, that\'s all bullshit. Dainty farks like yourself are nothing but mealworm. You want to be a knight you gotta learn to kill.%SPEECH_OFF%The squire straightens up and pulls his shoulders back.%SPEECH_ON%I\'ve no issue killing.%SPEECH_OFF%The hedge knight pushes the man back with only a single finger.%SPEECH_ON%Is that so? And have you gutted a man and murdered his family while he bled out on the ground? What of crushing a child\'s head in your hands because your liege gave the order? Would you gouge out a woman\'s eyes because your lord believed that was due punishment for stealing a loaf of bread? Who do you think I am, squire? Do you think I was born big, mean, and savage? No, little squire, you will have to kill, and who you kill first is none other than yourself. That is how you become a knight in these lands, in these times.%SPEECH_OFF%The hedge knight returns to his work. The squire is visibly shaken, but seems to be earnestly thinking over what he\'d just heard.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Life\'s not a knight\'s tale.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Squire.getImagePath());
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				_event.m.Squire.getFlags().set("squire_vs_hedge_knight", true);
				local resolve = this.Math.rand(1, 4);
				_event.m.Squire.getBaseProperties().Bravery += resolve;
				_event.m.Squire.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Squire.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
				});
				_event.m.Squire.worsenMood(1.5, "Has been shaken in his beliefs");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Squire.getMoodState()],
					text = _event.m.Squire.getName() + this.Const.MoodStateEvent[_event.m.Squire.getMoodState()]
				});
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

		local squire_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 4 && bro.getBackground().getID() == "background.squire" && !bro.getFlags().has("squire_vs_hedge_knight"))
			{
				squire_candidates.push(bro);
			}
		}

		if (squire_candidates.len() == 0)
		{
			return;
		}

		local hk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hk_candidates.push(bro);
			}
		}

		if (hk_candidates.len() == 0)
		{
			return;
		}

		this.m.Squire = squire_candidates[this.Math.rand(0, squire_candidates.len() - 1)];
		this.m.HedgeKnight = hk_candidates[this.Math.rand(0, hk_candidates.len() - 1)];
		this.m.Score = (squire_candidates.len() + hk_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"squire",
			this.m.Squire.getNameOnly()
		]);
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Squire = null;
		this.m.HedgeKnight = null;
	}

});

